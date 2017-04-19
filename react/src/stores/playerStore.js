import { observable, action } from 'mobx'
import _bindAll from 'lodash/bindAll'
import PlayerChannel from 'channels/PlayerChannel'

class PlayerStore {
  @observable.shallow tiles = [];
  @observable range = 10;

  constructor () {
    _bindAll(this, 'handleConnectionSuccess');

    this.channel = new PlayerChannel('player:lobby');
    this.channel.connect(this.handleConnectionSuccess);
  }

  @action handleConnectionSuccess (response) {
    this.tiles = response.tiles;
  }

  move (coordinates) {
    this.channel.socket.push("move", {coordinates: coordinates, range: this.range});
    this.range += 1;
  }
}

const playerStore = new PlayerStore();

export default playerStore