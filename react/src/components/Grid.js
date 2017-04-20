import React, {Component} from 'react';
import { action } from 'mobx'
import {observer} from 'mobx-react';
import Tile from 'components/meshes/Tile';
import playerStore from 'stores/playerStore';
import _bindAll from 'lodash/bindAll';
import _differenceBy from 'lodash/differenceBy';
import _chunk from 'lodash/chunk';
import * as THREE from 'three';

@observer
export default class Grid extends Component {
  constructor(props, context) {
    super(props, context);

    _bindAll(this, 'handleKeyPress')
  }

  componentDidMount() {
    // document.addEventListener("keydown", this.handleKeyPress);
    // playerStore.channel.socket.on("move", this.loadTiles)
    this.drawGrid()
  }

  componentDidUpdate() {
    this.drawGrid()
  }

  drawGrid() {
    let matrix = new THREE.Matrix4();

    let tmpGeometry = new THREE.Geometry();

    playerStore.tiles.map((tile) => {
      let hexTmpGeometry = new THREE.CylinderGeometry(1, 1, tile.height, 6);

      matrix.makeScale(0, tile.height || 1, 0);
      matrix.makeTranslation(
          (tile.x * Math.sqrt(3) / 2) - (tile.y * Math.sqrt(3) / 2),
          (tile.height || 1) / 2,
          (tile.z / 2) - (tile.x) - (tile.y)
      );

      tmpGeometry.merge(hexTmpGeometry, matrix);
    });

    let geometry = new THREE.BufferGeometry().fromGeometry( tmpGeometry );
    geometry.computeBoundingSphere();

    console.log(playerStore.tiles.length);
    let mesh = new THREE.Mesh( geometry, new THREE.MeshLambertMaterial( { color: 0xCCCCAA, shading: THREE.FlatShading } ) );
    this.grid.add( mesh );
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
    console.log(playerStore.tiles.length);
    return (
        <group ref={(grid) => this.grid = grid}>
          {/*{playerStore.tiles.map((tile) =>*/}
            {/*<Tile key={tile.id} {...tile}/>*/}
          {/*)}*/}
        </group>
    )
  }
}
