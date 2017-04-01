require('styles/world.scss');

import React, {Component} from 'react';
import {observer} from 'mobx-react';
import worldStore from 'stores/worldStore';
import {Panel} from 'react-bootstrap';
import Art from '@ecliptic/react-art';
import canvasStore from 'stores/canvasStore';
import Hex from 'components/shapes/Hex';

@observer
export default class WorldPage extends Component {
  componentDidUpdate() {
    let width = this.$surfaceContainer.width();
    canvasStore.setCanvasSize(width)
  }

  render() {
    let id = this.props.match.params.topicId;
    let world = worldStore.world(id);

    if (world)
      return (
          <Panel header={<h3>{world.name}</h3>}>
            <div className="surface-container" ref={(e) => this.$surfaceContainer = $(e)}>
              <Art.Surface width={canvasStore.canvasWidth} height={canvasStore.canvasHeight} className='world-canvas'>
                <Hex size={10} coordinates={{x: 0, y: 0, z: 0}}/>
              </Art.Surface>
            </div>
          </Panel>
      );
    else
      return null
  }
}
