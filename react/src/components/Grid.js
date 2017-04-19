import React, {Component} from 'react';
import { action } from 'mobx'
import {observer} from 'mobx-react';
import Tile from 'components/meshes/Tile';
import playerStore from 'stores/playerStore';
import _bindAll from 'lodash/bindAll';
import _differenceBy from 'lodash/differenceBy';
import _chunk from 'lodash/chunk';

@observer
export default class Grid extends Component {
  constructor(props, context) {
    super(props, context);

    _bindAll(this, 'handleKeyPress')
  }

  componentDidMount() {
    document.addEventListener("keydown", this.handleKeyPress);

    playerStore.channel.socket.on("move", this.loadTiles)
  }

  shouldComponentUpdate() {
    console.log('update');
    return false;
  }

  @action loadTiles(payload) {
    let uniqTiles  = _differenceBy(payload.tiles, playerStore.tiles.peek(), "id");
    playerStore.tiles.push.apply(playerStore.tiles, uniqTiles);
  }

  handleKeyPress(e) {
    if (e.code === "Space") {
      console.log("Space");
      playerStore.move({x: 0, y: 0, z: 0});
    }
    if (e.code === "Enter") {
      console.log("Enter");
    }
    if (e.code === "Backspace") {
      console.log("Backspace");
    }
  }

  render() {
    return (
        <group>
          {playerStore.tiles.map((tile) =>
            <Tile key={tile.id} {...tile}/>
          )}
        </group>
    )
  }
}
