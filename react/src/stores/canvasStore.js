import { observable, action } from 'mobx';

class CanvasStore {
  @observable canvasWidth = null;
  @observable canvasHeight = null;

  @action setCanvasSize(width, height = width*4/7) {
    this.canvasWidth = width;
    this.canvasHeight = height;
  }
}

const canvasStore = new CanvasStore();

export default canvasStore