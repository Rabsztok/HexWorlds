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

world = Game.Repo.insert!(%Game.World{name: "Sample World"})

Game.WorldGenerator.call(world, 10)