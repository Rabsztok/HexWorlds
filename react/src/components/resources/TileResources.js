import React, {Component} from 'react';
import * as THREE from 'three';
import _map from 'lodash/map';

export default class TileResources extends Component {
  constructor(props, context) {
    super(props, context);

    this.colors = {dirt: 0x007B0C, stone: 0x666666, sand: 0xC2B280, water: 0x40A4DF};
  }

  render() {
    return (
        <resources>
          <cylinderGeometry resourceId="tileGeometry"
                            radiusTop={1} radiusBottom={1} height={1} radialSegments={6}/>
          {_map(this.colors, (code, name) =>
              <meshPhongMaterial key={name} resourceId={`${name}TileMaterial`}
                                 color={code} shading={THREE.FlatShading}/>
          )}
        </resources>
    )
  }
}

