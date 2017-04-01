import { observable } from 'mobx';
import _bindAll from 'lodash/bindAll'
import _find from 'lodash/find'
import WorldChannel from 'channels/WorldChannel'

class WorldStore {
  @observable worlds = [];

  constructor () {
    _bindAll(this, 'handleConnectionSuccess');

    this.channel = new WorldChannel('worlds:lobby').connect(this.handleConnectionSuccess)
  }

  handleConnectionSuccess (response) {
    this.worlds = response.worlds;
  }

  world(id) {
    return _find(this.worlds, { id: parseInt(id) })
  }
}

const worldStore = new WorldStore();

export default worldStore