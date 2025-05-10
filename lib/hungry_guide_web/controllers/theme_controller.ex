defmodule HungryGuideWeb.ThemeController do
  use HungryGuideWeb, :controller

  @session_key "theme"

  def update(conn, %{"select_theme" => theme_name}) do
    conn
    |> put_session(@session_key, theme_name)
    |> json(%{})
  end
end
