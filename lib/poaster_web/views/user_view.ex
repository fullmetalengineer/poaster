defmodule PoasterWeb.UserView do
  use PoasterWeb, :view

  def render(conn, "me.json", %{user: user}) do
    IO.puts("me.json")
    IO.inspect(conn)
    %{
      data: render_one(user, PoasterWeb.UserView, "user.json")
    }
  end

  def render("user.json", %{user: user}) do
    IO.puts("user.json")
    %{
      email: user.email,
      phone: user.phone,
      personas: render_many(user.personas, PoasterWeb.PersonaView, "persona.json"),
    }
  end
end
