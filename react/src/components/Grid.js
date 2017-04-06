import React, {Component} from 'react';
import {observer} from 'mobx-react';
import Hex from 'components/meshes/Hex';
import playerStore from 'stores/playerStore';

@observer
export default class Grid extends Component {
  render() {
    return (
        <group>
          {playerStore.tiles.map((tile) =>
            <Hex key={tile.id} tile={{x: tile.q, y: -tile.q-tile.r, z: tile.r, height: tile.height/2}}/>
          )}
        </group>
    )
  }
}
