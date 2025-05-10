defmodule HungryGuideWeb.Plugs.ThemeSelectorPlug do
  @moduledoc """
  Sets :theme in conn.assigns from session data.
  """
  import Plug.Conn

  @session_key "theme" # or nested like "preferences.theme" if needed

  def init(opts), do: opts

  def call(conn, _opts) do
    theme = get_session(conn, @session_key) || "light"
    assign(conn, :theme, theme)
  end
end
