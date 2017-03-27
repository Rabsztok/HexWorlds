import React, { Component } from 'react';
import _bindAll from 'lodash/bindAll';
import { observer } from 'mobx-react';

@observer
class WorldList extends Component {
  constructor(props, context) {
    super(props, context);

    _bindAll(this, 'handleSelect');
  }

  handleSelect() {
    debugger;
  }

  render() {
    const worldStore = this.props.worldStore;

    return (
      <ul className="worlds">
        { worldStore.worlds.map((world) =>
          <li>
            <a data-id={world.id} onClick={this.handleSelect}>
              {world.name}
            </a>
          </li>
        )}
      </ul>
    );
  }
}

export default WorldList;
