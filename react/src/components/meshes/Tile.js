import React from 'react';
import * as THREE from 'three';

const Tile = ({ x, y, z, height, terrain_type, hidden }) => (
    <mesh position={new THREE.Vector3(
        (x * Math.sqrt(3) / 2) - (y * Math.sqrt(3) / 2),
        (height || 1) / 2,
        (z / 2) - (x) - (y)
      )} scale={new THREE.Vector3(1, height || 1, 1)}>
      <geometryResource resourceId="tileGeometry"/>
      <materialResource resourceId={`${terrain_type}TileMaterial`}/>
    </mesh>
);

export default Tile