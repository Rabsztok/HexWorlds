import React, {Component} from 'react';
import {observer} from 'mobx-react';
import playerStore from 'stores/playerStore';
import _each from 'lodash/each';
import GridGeometry from 'components/geometries/GridGeometry'
import * as THREE from 'three';

@observer
export default class Grid extends Component {
  constructor(props, context) {
    super(props, context);

    this.tileRotation = new THREE.Euler(-Math.PI / 2, 0, Math.PI / 2);
    this.terrains = {dirt: 0x007B0C, stone: 0x666666, sand: 0xC2B280, water: 0x40A4DF};
  }

  componentDidUpdate() {
    this.drawGrid()
  }

  drawGrid() {
    _each(this.terrains, (color, terrain) => {
      let geometry = new GridGeometry().drawGrid(terrain);
      let mesh = new THREE.Mesh(
          geometry,
          new THREE.MeshLambertMaterial({color: color, shading: THREE.FlatShading})
      );
      playerStore.grid.add(mesh);
    });
  }

  tilePosition(tile) {
    return new THREE.Vector3(
        ( 2 * tile.x + tile.z) * Math.sqrt(3) / 2,
        tile.height || 1,
        tile.z * 3 / 2
    )
  }

  render() {
    console.log(playerStore.tiles.length);
    return (
        <group ref={(grid) => playerStore.grid = grid}>
          {playerStore.tiles.map((tile, index) =>
              <mesh key={index} name="tile"
                    position={this.tilePosition(tile)} rotation={this.tileRotation}>
                <geometryResource resourceId="tileGeometry"/>
                <materialResource resourceId="tileMaterial"/>
              </mesh>
          )}
        </group>
    )
  }
}
