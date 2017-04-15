import React, {Component} from 'react';
import {observer} from 'mobx-react';
import Tile from 'components/meshes/Tile';
import playerStore from 'stores/playerStore';

@observer
export default class Grid extends Component {
  render() {
    return (
        <group>
          {playerStore.tiles.map((tile) =>
            <Tile key={tile.id} {...tile}/>
          )}
        </group>
    )
  }
}
