import { observable, action } from 'mobx'
import _bindAll from 'lodash/bindAll'
import PlayerChannel from 'channels/PlayerChannel'

class PlayerStore {
  @observable tiles = {};
  @observable range = 10;

  constructor () {
    _bindAll(this, 'handleConnectionSuccess');

    this.channel = new PlayerChannel('player:lobby');
    this.channel.connect(this.handleConnectionSuccess);
  }

  @action handleConnectionSuccess (response) {
    let tiles = {};
    response.tiles.map((tile) => {
      if (!tiles[tile.x])
        tiles[tile.x] = {};
      if (!tiles[tile.x][tile.y])
        tiles[tile.x][tile.y] = {};
      tiles[tile.x][tile.y][tile.z] = tile;
    });
    this.tiles = tiles
  }

  move (coordinates) {
    this.channel.socket.push("move", {coordinates: coordinates, range: this.range});
    this.range += 1;
  }
}

const playerStore = new PlayerStore();

export default playerStore