import { observable } from 'mobx';
import _bindAll from 'lodash/bindAll'
import socket from 'utils/socket'

class WorldStore {
  @observable worlds = [];

  constructor () {
    this.joinChannel()
  }

  get channel () {
    return socket.channel("worlds:lobby", {})
  }

  handleChannelJoin(response) {
    this.worlds = response.worlds
  }

  joinChannel() {
    _bindAll(this, 'handleChannelJoin');

    this.channel.join()
        .receive("ok", this.handleChannelJoin)
        .receive("error", () => console.error('Connection error'))
  }
}

const worldStore = new WorldStore();

export default worldStore