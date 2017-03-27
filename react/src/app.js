import React from 'react'
import { BrowserRouter as Router, Route, Switch } from 'react-router-dom'
import { observer } from 'mobx-react'

import worldStore from 'stores/world_store'
import WorldList from 'components/world_list'

const Landing = () => (
    <div>
      <div className="jumbotron">
        <h2>Hello, welcome to BRC app</h2>
        <p>There isn't much here just yet, please come back later!</p>
      </div>

      <WorldList worldStore={worldStore}/>
    </div>
);

const NotFound = () => (
    <div className="jumbotron text-center">
      <h2>Uh oh!</h2>
      <p>We couldn't find what you were looking for!</p>
    </div>
)

@observer
class App extends React.Component {
  render() {
    return (
        <Router>
          <div>
            <div className="container">
              <Switch>
                <Route exact path="/" component={Landing}/>
                <Route component={NotFound}/>
              </Switch>
            </div>
          </div>
        </Router>
    )
  }
}

export default App