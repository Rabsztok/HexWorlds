import React, {Component} from 'react';
import * as THREE from 'three';
import TileGeometry from 'components/geometries/TileGeometry';
import _map from 'lodash/map';

export default class TileResources extends Component {
  constructor(props, context) {
    super(props, context);

    this.colors = {dirt: 0x007B0C, stone: 0xCCCCCC, sand: 0xC2B280, water: 0x40A4DF};
  }

  render() {
    return (
        <resources>
          <TileGeometry/>
          {_map(this.colors, (code, name) =>
              <meshPhongMaterial key={name} resourceId={`${name}TileMaterial`}
                                 color={code} shading={THREE.FlatShading}/>
          )}
        </resources>
    )
  }
}

