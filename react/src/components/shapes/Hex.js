import React, {Component} from 'react';
import Art from '@ecliptic/react-art';
import {observer} from 'mobx-react';
import canvasStore from 'stores/canvasStore';

@observer
export default class Hex extends Component {
  path(size, coordinates) {
    let path = new Art.Path();
    let point = 0;
    let x = null;
    let y = null;
    let angle = null;
    let offset = {
      x: (coordinates.x * Math.sqrt(3)/2) - (coordinates.y * Math.sqrt(3)/2),
      y: (coordinates.z/2) - (coordinates.x) - (coordinates.y)
    };

    while (point < 6) {
      angle = 2 * Math.PI / 6 * (point + 0.5);
      x = (offset.x * size) + size * Math.cos(angle) + (canvasStore.canvasWidth / 2);
      y = (offset.y * size) + size * Math.sin(angle) + (canvasStore.canvasHeight / 2);


      if (point === 0) {
        path.moveTo(x, y);
      }
      else {
        path.lineTo(x, y);
      }

      point = point + 1;
    }

    return path;
  }

  render() {
    let {size, coordinates} = this.props;
    let path = this.path(size, coordinates);
    return (
        <Art.Shape d={path} fill="#CCCCCC"/>
    )
  }
}

