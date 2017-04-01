import _bindAll from 'lodash/bindAll'
import socket from 'utils/socket'

export default class WorldChannel {
  constructor(channelName) {
    this.channelName = channelName;
  }

  async connect (onConnectionSuccess) {
    this.socket = socket.channel(this.channelName, {});

    return await this.socket.join()
                     .receive("ok", onConnectionSuccess)
                     .receive("error", () => console.error('Connection error'))
  }
}