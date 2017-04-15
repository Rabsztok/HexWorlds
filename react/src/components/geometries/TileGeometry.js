import React, {Component} from 'react';
import * as THREE from 'three';

export default class TileGeometry extends Component {
  vertices() {
    let height = 1;
    let point = 0;
    let size = 1;
    let x = null;
    let z = null;
    let angle = null;
    let vertices = [];

    while (point < 6) {
      angle = 2 * Math.PI / 6 * (point + 0.5);
      x = size * Math.cos(angle);
      z = size * Math.sin(angle);

      vertices.push(new THREE.Vector3(x, 0, z));
      vertices.push(new THREE.Vector3(x, height, z));

      point = point + 1;
    }

    return vertices;
  }

  faces() {
    return [
        // bottom - skip rendering
        // new THREE.Face3( 4, 0, 2),
        // new THREE.Face3( 8, 4, 6),
        // new THREE.Face3( 0, 8, 10),
        // new THREE.Face3( 8, 0, 4 ),
        // top
        new THREE.Face3( 1, 5, 3 ),
        new THREE.Face3( 5, 9, 7 ),
        new THREE.Face3( 9, 1, 11 ),
        new THREE.Face3( 1, 9, 5 ),

        // // sides
        new THREE.Face3( 2, 0, 1 ),
        new THREE.Face3( 1, 3, 2 ),

        new THREE.Face3( 4, 2, 3 ),
        new THREE.Face3( 3, 5, 4 ),

        new THREE.Face3( 6, 4, 5 ),
        new THREE.Face3( 5, 7, 6 ),

        new THREE.Face3( 8, 6, 7 ),
        new THREE.Face3( 7, 9, 8 ),

        new THREE.Face3( 10, 8, 9 ),
        new THREE.Face3( 9, 11, 10 ),

        new THREE.Face3( 0, 10, 11 ),
        new THREE.Face3( 11, 1, 0 ),
    ];
  }

  render() {
    let vertices = this.vertices();
    let faces = this.faces();
    return (
        <geometry resourceId="tileGeometry" vertices={vertices} faces={faces}/>
    )
  }
}

