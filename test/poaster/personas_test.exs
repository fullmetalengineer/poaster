defmodule Poaster.PersonasTest do
  use Poaster.DataCase

  alias Poaster.Personas

  describe "followings" do
    alias Poaster.Personas.Following

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def following_fixture(attrs \\ %{}) do
      {:ok, following} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Personas.create_following()

      following
    end

    test "list_followings/0 returns all followings" do
      following = following_fixture()
      assert Personas.list_followings() == [following]
    end

    test "get_following!/1 returns the following with given id" do
      following = following_fixture()
      assert Personas.get_following!(following.id) == following
    end

    test "create_following/1 with valid data creates a following" do
      assert {:ok, %Following{} = following} = Personas.create_following(@valid_attrs)
    end

    test "create_following/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Personas.create_following(@invalid_attrs)
    end

    test "update_following/2 with valid data updates the following" do
      following = following_fixture()
      assert {:ok, %Following{} = following} = Personas.update_following(following, @update_attrs)
    end

    test "update_following/2 with invalid data returns error changeset" do
      following = following_fixture()
      assert {:error, %Ecto.Changeset{}} = Personas.update_following(following, @invalid_attrs)
      assert following == Personas.get_following!(following.id)
    end

    test "delete_following/1 deletes the following" do
      following = following_fixture()
      assert {:ok, %Following{}} = Personas.delete_following(following)
      assert_raise Ecto.NoResultsError, fn -> Personas.get_following!(following.id) end
    end

    test "change_following/1 returns a following changeset" do
      following = following_fixture()
      assert %Ecto.Changeset{} = Personas.change_following(following)
    end
  end
end
