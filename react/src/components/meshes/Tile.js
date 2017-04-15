import React, {Component} from 'react';
import * as THREE from 'three';

export default class Tile extends Component {
  constructor(props, context) {
    super(props, context);

    let { x, y, z, height, terrain_type } = this.props;

    this.terrain_type = terrain_type;
    this.scale = new THREE.Vector3(1, height || 1, 1);
    this.position = new THREE.Vector3(
        (x * Math.sqrt(3) / 2) - (y * Math.sqrt(3) / 2),
        0,
        (z / 2) - (x) - (y)
    );
  }

  render() {
    return (
        <mesh position={this.position} scale={this.scale}>
          <geometryResource resourceId="tileGeometry"/>
          <materialResource resourceId={`${this.terrain_type}TileMaterial`}/>
        </mesh>
    )
  }
}