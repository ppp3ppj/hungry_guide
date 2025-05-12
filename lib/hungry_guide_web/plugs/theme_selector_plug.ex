defmodule HungryGuideWeb.Plugs.ThemeSelectorPlug do
  @moduledoc """
  Sets :theme in conn.assigns from session data.
  """
  import Plug.Conn

  # or nested like "preferences.theme" if needed
  @session_key "theme"

  def init(opts), do: opts

  def call(conn, _opts) do
    theme = get_session(conn, @session_key) || "light"

    conn
    |> assign(:theme, theme)
  end
end
