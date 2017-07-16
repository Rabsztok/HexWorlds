import React, {Component} from 'react';
import {action, observable} from 'mobx';
import {observer} from 'mobx-react';
import React3 from 'react-three-renderer';
import * as THREE from 'three';
import _find from 'lodash/find';
import _bindAll from 'lodash/bindAll';
import Grid from 'components/Grid';
import TileResources from 'components/resources/TileResources';
import canvasStore from 'stores/canvasStore';
import playerStore from 'stores/playerStore';
import { worldToCube, cubeToWorld } from 'utils/coordinates'

let OrbitControls = require('three-orbit-controls')(THREE);

@observer
export default class Canvas extends Component {
  @observable axisPosition = new THREE.Vector3(0,1,0)

  constructor(props, context) {
    super(props, context);


    _bindAll(this, 'handleTouchMove')
  }

  componentDidMount() {

    const controls = new OrbitControls(this.camera);
    controls.maxPolarAngle = 2 * Math.PI / 5;
    controls.minPolarAngle = Math.PI / 8;
    this.controls = controls;
    this.raycaster = new THREE.Raycaster();

    window.addEventListener( 'mousedown', this.handleTouchMove, false );
  }

  handleTouchMove(e) {
    e.preventDefault();
    e.stopPropagation();

    let mouse = new THREE.Vector2();
    mouse.x = ( e.clientX / window.innerWidth ) * 2 - 1;
    mouse.y = -( e.clientY / window.innerHeight ) * 2 + 1;

    this.raycaster.setFromCamera( mouse, this.camera );
    let intersect = this.raycaster.intersectObjects(playerStore.grid.children)[0];

    if (intersect) {
      let cube = worldToCube(intersect.point)
      let found = playerStore.nearest(cube)
      this.setAxisPosition(new THREE.Vector3(cubeToWorld(found).x, 1, cubeToWorld(found).z))
    }
  }

  @action setAxisPosition(vector) {
    this.axisPosition = vector
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
                               position={canvasStore.cameraPosition} lookAt={canvasStore.cameraTarget}/>

            <Grid/>

            <axisHelper position={this.axisPosition} scale={new THREE.Vector3(5,5,5)}/>

            <ambientLight color={0xFFFFFF}/>
            <pointLight color={0xFFFFFF} intensity={1} position={canvasStore.lightPosition}/>
          </scene>

        </React3>
    )
  }
}
