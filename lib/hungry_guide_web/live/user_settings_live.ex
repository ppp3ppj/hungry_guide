defmodule HungryGuideWeb.UserSettingsLive do
  use HungryGuideWeb, :live_view

  alias HungryGuide.Accounts

  def render(assigns) do
    ~H"""
    <.header class="text-center">
      Account Settings
      <:subtitle>Manage your account email address and password settings</:subtitle>
    </.header>

    <div class="space-y-12 divide-y">
      <form phx-submit="save_avatar" phx-change="avatar_validate">
        <%= if @current_user.avatar do %>
          <img src={@current_user.avatar} alt="User Avatar" width="100" />
        <% else %>
          <p>No avatar uploaded</p>
        <% end %>
        <.live_file_input upload={@uploads.avatar} />
        <button type="submit">Upload</button>
      </form>
      <div>
        <.simple_form
          for={@email_form}
          id="email_form"
          phx-submit="update_email"
          phx-change="validate_email"
        >
          <.input field={@email_form[:email]} type="email" label="Email" required />
          <.input
            field={@email_form[:current_password]}
            name="current_password"
            id="current_password_for_email"
            type="password"
            label="Current password"
            value={@email_form_current_password}
            required
          />
          <:actions>
            <.button phx-disable-with="Changing...">Change Email</.button>
          </:actions>
        </.simple_form>
      </div>
      <div>
        <.simple_form
          for={@password_form}
          id="password_form"
          action={~p"/users/log_in?_action=password_updated"}
          method="post"
          phx-change="validate_password"
          phx-submit="update_password"
          phx-trigger-action={@trigger_submit}
        >
          <input
            name={@password_form[:email].name}
            type="hidden"
            id="hidden_user_email"
            value={@current_email}
          />
          <.input field={@password_form[:password]} type="password" label="New password" required />
          <.input
            field={@password_form[:password_confirmation]}
            type="password"
            label="Confirm new password"
          />
          <.input
            field={@password_form[:current_password]}
            name="current_password"
            type="password"
            label="Current password"
            id="current_password_for_password"
            value={@current_password}
            required
          />
          <:actions>
            <.button phx-disable-with="Changing...">Change Password</.button>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end

  def mount(%{"token" => token}, _session, socket) do
    socket =
      case Accounts.update_user_email(socket.assigns.current_user, token) do
        :ok ->
          put_flash(socket, :info, "Email changed successfully.")

        :error ->
          put_flash(socket, :error, "Email change link is invalid or it has expired.")
      end

    {:ok, push_navigate(socket, to: ~p"/users/settings")}
  end

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    email_changeset = Accounts.change_user_email(user)
    password_changeset = Accounts.change_user_password(user)

    socket =
      socket
      |> assign(:current_password, nil)
      |> assign(:email_form_current_password, nil)
      |> assign(:current_email, user.email)
      |> assign(:email_form, to_form(email_changeset))
      |> assign(:password_form, to_form(password_changeset))
      |> assign(:trigger_submit, false)
      |> assign(:uploaded_files, [])
      |> allow_upload(:avatar, accept: ~w(.jpg .jpeg .png), max_entries: 1)

    {:ok, socket}
  end

  def handle_event("validate_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    email_form =
      socket.assigns.current_user
      |> Accounts.change_user_email(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, email_form: email_form, email_form_current_password: password)}
  end

  def handle_event("update_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.apply_user_email(user, password, user_params) do
      {:ok, applied_user} ->
        Accounts.deliver_user_update_email_instructions(
          applied_user,
          user.email,
          &url(~p"/users/settings/confirm_email/#{&1}")
        )

        info = "A link to confirm your email change has been sent to the new address."
        {:noreply, socket |> put_flash(:info, info) |> assign(email_form_current_password: nil)}

      {:error, changeset} ->
        {:noreply, assign(socket, :email_form, to_form(Map.put(changeset, :action, :insert)))}
    end
  end

  def handle_event("validate_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    password_form =
      socket.assigns.current_user
      |> Accounts.change_user_password(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, password_form: password_form, current_password: password)}
  end

  def handle_event("update_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        password_form =
          user
          |> Accounts.change_user_password(user_params)
          |> to_form()

        {:noreply, assign(socket, trigger_submit: true, password_form: password_form)}

      {:error, changeset} ->
        {:noreply, assign(socket, password_form: to_form(changeset))}
    end
  end

  defp list_existing_files(%{images: images} = _item) when is_list(images), do: images
  defp list_existing_files(_item), do: []

  defp put_upload_change(_socket, params, item, uploaded_entries, removed_entries, action) do
    existing_files = list_existing_files(item) -- removed_entries

    new_entries =
      case action do
        :validate ->
          elem(uploaded_entries, 1)

        :insert ->
          elem(uploaded_entries, 0)
      end

    files = existing_files || Enum.map(new_entries, fn entry -> file_name(entry) end)

    Map.put(params, "images", files)
  end

  defp consume_upload(_socket, _item, %{path: path} = _meta, entry) do
    file_name = file_name(entry)
    dest = Path.join([:code.priv_dir(:hungry_guide), "static", upload_dir(), file_name])

    # Ensure destination folder exists
    File.mkdir_p!(Path.dirname(dest))

    File.cp!(path, dest)

    {:ok, file_url(file_name)}
  end

  defp remove_upload(_socket, _item, removed_entries) do
    for file <- removed_entries do
      path = Path.join([:code.priv_dir(:hungry_guide), "static", upload_dir(), file])
      File.rm!(path)
    end
  end

  defp file_url(file_name) do
    static_path = Path.join([upload_dir(), file_name])
    Phoenix.VerifiedRoutes.static_url(HungryGuideWeb.Endpoint, "/" <> static_path)
  end

  defp file_name(entry) do
    [ext | _tail] = MIME.extensions(entry.client_type)
    "#{entry.uuid}.#{ext}"
  end

  defp upload_dir, do: Path.join(["uploads", "avatar", "images"])

  def handle_event("save_avatar", _params, socket) do
    user = socket.assigns.current_user

    uploaded =
      consume_uploaded_entries(socket, :avatar, fn meta, entry ->
        consume_upload(socket, user, meta, entry)
      end)

    IO.inspect(uploaded, label: "Debug uploaded")

    case uploaded do
      [avatar_url] ->
        case Accounts.update_user_avatar(user, %{avatar: avatar_url}) do
          {:ok, updated_user} ->
            {:noreply,
             socket
             |> put_flash(:info, "Avatar updated.")
             |> assign(:current_user, updated_user)}

          {:error, _changeset} ->
            {:noreply, put_flash(socket, :error, "Failed to update avatar.")}
        end

      _ ->
        {:noreply, put_flash(socket, :error, "No file uploaded.")}
    end
  end

  @impl Phoenix.LiveView
  def handle_event("avatar_validate", _params, socket) do
    {:noreply, socket}
  end
end
