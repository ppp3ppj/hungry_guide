defmodule HungryGuideWeb.ErrorJSONTest do
  use HungryGuideWeb.ConnCase, async: true

  test "renders 404" do
    assert HungryGuideWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert HungryGuideWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
