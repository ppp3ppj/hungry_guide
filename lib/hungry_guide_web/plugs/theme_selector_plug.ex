defmodule HungryGuideWeb.Plugs.ThemeSelectorPlug do
  @moduledoc """
  A plug that retrieves the theme from the session and assigns it to `conn.assigns[:theme]`.
  """
  import Plug.Conn

  @backpex_key "backpex"
  @theme_key "theme"

  def init(opts), do: opts

  def call(conn, _opts) do
    session = get_session(conn)
    theme = get_in(session, [@backpex_key, @theme_key]) || "default"

    assign(conn, :theme, theme)
  end
end
