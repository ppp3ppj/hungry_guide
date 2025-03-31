defmodule HungryGuideWeb.PageController do
  use HungryGuideWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    theme = conn.assigns[:theme] || "default"
    #render(conn, :home, layout: false)
    render(conn, :home, layout: false, theme: theme)
  end
end
