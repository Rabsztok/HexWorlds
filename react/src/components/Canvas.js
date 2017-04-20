import React, {Component} from 'react';
import React3 from 'react-three-renderer';
import * as THREE from 'three';
import Grid from 'components/Grid';
import TileResources from 'components/resources/TileResources';

let OrbitControls = require('three-orbit-controls')(THREE);

export default class Canvas extends Component {
  constructor(props, context) {
    super(props, context);

    this.cameraPosition = new THREE.Vector3(-30, 30, -30);
    this.cameraTarget = new THREE.Vector3(0, 0, 0);
    this.lightPosition = new THREE.Vector3(0, 20, 20);
  }

  componentDidMount() {
    const controls = new OrbitControls(this.camera);
    controls.maxPolarAngle = 2 * Math.PI / 5;
    controls.minPolarAngle = Math.PI / 8;
    this.controls = controls;
  }

  componentWillUnmount() {
    this.controls.dispose();
    delete this.controls;
  }

  render() {
    let {width, height} = this.props;

    return (
        <React3 mainCamera="camera" width={width} height={height} clearColor={0xaaeeff}
                antialias gammaInput gammaOutput>

          <TileResources/>

          <scene>
            <perspectiveCamera ref={(c) => this.camera = c} name="camera" fov={75}
                               aspect={width / height} near={0.1} far={2000}
                               position={this.cameraPosition} lookAt={this.cameraTarget}/>

            <Grid/>

            <ambientLight color={0xFFFFFF}/>
            <pointLight color={0xFFFFFF} intensity={1} position={this.lightPosition}/>
          </scene>

        </React3>
    )
  }
}
