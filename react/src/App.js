import React from 'react'
import { BrowserRouter as Router, Route, Switch } from 'react-router-dom'
import { observer } from 'mobx-react'

import WorldPage from 'pages/WorldPage'
import WorldIndex from 'pages/WorldIndex'
import Navigation from 'components/Navigation';

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
            <Navigation/>

            <div className="container">
              <Switch>
                <Route exact path="/" component={WorldIndex}/>
                <Route path={`/world/:topicId`} component={WorldPage}/>
                <Route component={NotFound}/>
              </Switch>
            </div>
          </div>
        </Router>
    )
  }
}

export default App