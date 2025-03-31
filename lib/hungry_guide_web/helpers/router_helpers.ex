defmodule HungryGuideWeb.RouterHelpers do
  @doc """
  Finds the cookie path by the given socket.
  """
  def cookie_path(socket) do
    route =
      Enum.find(Map.get(socket, :router).__routes__(), fn element ->
        element[:plug] == HungryGuideWeb.Controllers.CookieController and element[:plug_opts] == :update
      end)

    case route do
      %{path: path} ->
        path

      nil ->
        raise ArgumentError, """
        Could not find backpex_cookies route. Make sure you have added backpex_routes to your router.

        See: https://hexdocs.pm/backpex/installation.html#add-backpex-routes
        """
    end
  end
end
