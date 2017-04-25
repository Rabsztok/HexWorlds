import React, {Component} from 'react';
import * as THREE from 'three';
import _map from 'lodash/map';

export default class TileResources extends Component {
  render() {
    return (
        <resources>
          <circleGeometry resourceId="tileGeometry"
                            radius={1} segments={6}/>
          <meshBasicMaterial resourceId="tileMaterial"
                             visible={false}/>
        </resources>
    )
  }
}

