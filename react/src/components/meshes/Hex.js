import React, {Component} from 'react';
import * as THREE from 'three';
import HexGeometry from 'components/geometries/HexGeometry'

export default class Hex extends Component {
  position() {
    let {tile} = this.props;

    return new THREE.Vector3(
        (tile.x * Math.sqrt(3) / 2) - (tile.y * Math.sqrt(3) / 2),
        0,
        (tile.z / 2) - (tile.x) - (tile.y)
    );
  }

  render() {
    let position = this.position();
    let height = this.props.tile.height;
    console.log('hex!');
    return (
        <mesh position={position}>
          <HexGeometry height={height}/>
          <meshPhongMaterial color={0x007B0C} shading={THREE.FlatShading}/>
        </mesh>
    )
  }
}

