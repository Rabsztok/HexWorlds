import React, {Component} from 'react';
import { action } from 'mobx'
import {observer} from 'mobx-react';
import playerStore from 'stores/playerStore';
import _bindAll from 'lodash/bindAll';
import _differenceBy from 'lodash/differenceBy';
import _each from 'lodash/each';
import GridGeometry from 'components/geometries/GridGeometry'
import * as  THREE from 'three';

@observer
export default class Grid extends Component {
  constructor(props, context) {
    super(props, context);

    this.terrains = {dirt: 0x007B0C, stone: 0x666666, sand: 0xC2B280, water: 0x40A4DF};

    _bindAll(this, 'handleKeyPress')
  }

  componentDidMount() {
    document.addEventListener("keydown", this.handleKeyPress);
    playerStore.channel.socket.on("move", this.loadTiles)
    this.drawGrid()
  }

  componentDidUpdate() {
    this.drawGrid()
  }

  drawGrid() {
    _each(this.terrains, (color, terrain) => {
      let mesh = new THREE.Mesh(
          new GridGeometry().fromTerrain(playerStore.tiles, terrain),
          new THREE.MeshLambertMaterial( { color: color, shading: THREE.FlatShading } )
      );
      playerStore.grid.add(mesh);
    });
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
    console.log(playerStore.tiles.length) // IMPORTANT to observe!
    return (
        <group ref={(grid) => playerStore.setGrid(grid)}/>
    )
  }
}
