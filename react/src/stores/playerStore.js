import {observable, computed, action} from 'mobx'
import _bindAll from 'lodash/bindAll'
import {distance} from 'utils/coordinates'
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

  @action setGrid(grid) {
    this.grid = grid
  }

  @computed get tileMatrix() {
    let tileMatrix = {};

    this.tiles.map((tile) => {
      if (!tileMatrix[parseInt(tile.x)]) tileMatrix[parseInt(tile.x)] = {}
      if (!tileMatrix[parseInt(tile.x)][parseInt(tile.y)]) tileMatrix[parseInt(tile.x)][parseInt(tile.y)] = {}
      tileMatrix[tile.x][tile.y][tile.z] = tile
    });

    return tileMatrix
  }

  find(x,y,z) {
    return this.tileMatrix && this.tileMatrix[x] && this.tileMatrix[x][y] && this.tileMatrix[x][y][z]
  }

  nearest(vector) {
    let nearest = null;

    [Math.floor(vector.x), Math.ceil(vector.x)].map(x =>
      [Math.floor(vector.y), Math.ceil(vector.y)].map(y =>
        [Math.floor(vector.z), Math.ceil(vector.z)].map(z => {
          const tile = this.find(x,y,z)

          if (tile)
            if (nearest === null)
              nearest = { distance: distance(vector, tile), tile: tile }
            else {
              const currentDistance = distance(vector, tile)
              if (currentDistance < nearest.distance)
                nearest = { distance: currentDistance, tile: tile }
            }
        })
      )
    )

    return nearest.tile
  }

  move(coordinates) {
    this.channel.socket.push("move", {coordinates: coordinates, range: this.range});
    this.range += 1;
  }
}

const playerStore = new PlayerStore();

window.PlayerStore = playerStore

export default playerStore