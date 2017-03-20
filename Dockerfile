FROM marcelocg/phoenix

RUN mix local.hex --force
RUN mix local.rebar --force

WORKDIR /app
