import React, {Component} from 'react';
import {Link} from 'react-router-dom'
import {observer} from 'mobx-react';
import {Row, Col, Panel} from 'react-bootstrap'

import worldStore from 'stores/worldStore'

@observer
class WorldList extends Component {
  render() {
    return (
        <Row>
          <Col sm={6} smOffset={3}>
            <Panel header={<h3>Select world:</h3>}>
              { worldStore.worlds.map((world) =>
                  <Link key={world.id} to={`/world/${world.id}`} className="btn btn-default btn-block">
                    {world.name}
                  </Link>
              )}
            </Panel>
          </Col>
        </Row>
    );
  }
}

export default WorldList;
