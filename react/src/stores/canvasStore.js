import { observable } from 'mobx';

class CanvasStore {
  @observable canvasWidth = null;
  @observable canvasHeight = null;

  setCanvasSize(width, height = width*3/7) {
    this.canvasWidth = width;
    this.canvasHeight = height;
  }
}

const canvasStore = new CanvasStore();

export default canvasStore