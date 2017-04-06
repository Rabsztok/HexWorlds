import { observable } from 'mobx';
import _bindAll from 'lodash/bindAll'
import _find from 'lodash/find'
import PlayerChannel from 'channels/PlayerChannel'

class PlayerStore {
  @observable tiles = [];

  constructor () {
    _bindAll(this, 'handleConnectionSuccess');

    this.channel = new PlayerChannel('player:lobby').connect(this.handleConnectionSuccess)
  }

  handleConnectionSuccess (response) {
    this.tiles = response.tiles;
  }

  // player(id) {
  //   return _find(this.players, { id: parseInt(id) })
  // }
}

const playerStore = new PlayerStore();

export default playerStore