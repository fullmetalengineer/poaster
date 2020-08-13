defmodule PoasterWeb.PersonaView do
  use PoasterWeb, :view

  def render("persona.json", %{persona: persona}) do
    IO.puts("persona.json")
    %{
      id: persona.id,
      background_image_url: persona.background_image_url,
      bio: persona.bio,
      inserted_at: persona.inserted_at,
      name: persona.name,
      profile_image_url: persona.profile_image_url,
      updated_at: persona.updated_at,
      username: persona.username
    }
  end
end
