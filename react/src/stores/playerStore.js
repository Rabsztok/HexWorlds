import {observable, computed, action} from 'mobx'
import _bindAll from 'lodash/bindAll'
import PlayerChannel from 'channels/PlayerChannel'

class PlayerStore {
  @observable tiles = [];
  @observable range = 10;
  grid = null;

  constructor() {
    _bindAll(this, 'handleConnectionSuccess');

    this.channel = new PlayerChannel('player:lobby');
    this.channel.connect(this.handleConnectionSuccess);
  }

  @action handleConnectionSuccess(response) {
    this.tiles = response.tiles
  }

  @computed get tileMatrix() {
    let tileMatrix = {};

    this.tiles.map((tile) => {
      if (!this.tiles[tile.x])
        this.tiles[tile.x] = {};
      if (!this.tiles[tile.x][tile.y])
        this.tiles[tile.x][tile.y] = {};
      this.tiles[tile.x][tile.y][tile.z] = tile;
    });

    return tileMatrix
  }

  move(coordinates) {
    this.channel.socket.push("move", {coordinates: coordinates, range: this.range});
    this.range += 1;
  }
}

const playerStore = new PlayerStore();

export default playerStore