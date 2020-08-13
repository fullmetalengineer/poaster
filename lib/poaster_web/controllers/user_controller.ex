defmodule PoasterWeb.UserController do
  use PoasterWeb, :controller
  alias Poaster.User

  def me(conn, _params) do
    u = Poaster.Repo.get(Poaster.User, conn.assigns[:signed_user].id) |> Poaster.Repo.preload([:personas])
    render(conn, "me.json", u)
  end
end
