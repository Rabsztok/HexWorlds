# HexWorlds

Phoenix backend for generating hexagon-based worlds and seeing them in 3D.
Communication with frontend client is made using websocket channels.
Check out client app [here](https://github.com/Rabsztok/HexWorldsClient).

## Install

To start your app:

  * Install [`docker`](https://www.docker.com/get-docker)
  * Build and run docker container: `docker-compose up --build`
  * Run seeds: `docker-compose run web mix run priv/repo/seeds.exs`

## Note

This project is being made as a hobby in my free time, feel free to contribute or ask about anything here :)
