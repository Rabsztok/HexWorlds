import { observable, action } from 'mobx';
import * as THREE from 'three';

class CanvasStore {
  mouseButtons = { orbit: THREE.MOUSE.LEFT, zoom: THREE.MOUSE.MIDDLE, pan: THREE.MOUSE.RIGHT };

  @observable canvasWidth = null;
  @observable canvasHeight = null;
  @observable cameraPosition = new THREE.Vector3(-30, 30, 0);
  @observable cameraTarget = new THREE.Vector3(0, 0, 0);
  @observable lightPosition = new THREE.Vector3(0, 20, 20);

  @action setCanvasSize(width, height = width*4/7) {
    this.canvasWidth = width;
    this.canvasHeight = height;
  }

  @action moveCamera(x,z) {
    this.cameraPosition = new THREE.Vector3(
        this.cameraPosition.x + x,
        this.cameraPosition.y,
        this.cameraPosition.z + z
    );
    this.cameraTarget = new THREE.Vector3(
        this.cameraTarget.x + x,
        this.cameraTarget.y,
        this.cameraTarget.z + z
    )
  }
}

const canvasStore = new CanvasStore();

export default canvasStore