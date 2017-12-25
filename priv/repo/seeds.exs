# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Game.Repo.insert!(%Game.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

#Game.Repo.delete_all(Game.Tile)
#Game.Repo.delete_all(Game.World)

alias Game.World

world = Game.Repo.insert!(%World{name: "World #{:uniform.rand(9999)}"})
Game.WorldGenerator.call(world, 50)
