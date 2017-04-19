import React, {Component} from 'react';
import { Link } from 'react-router-dom';
import { Navbar } from 'react-bootstrap';

export default class Navigation extends Component {
  render() {
    return (
        <Navbar>
          <Navbar.Header>
            <Navbar.Brand>
              <Link to='/'>Hex Worlds</Link>
            </Navbar.Brand>
          </Navbar.Header>
        </Navbar>
    )
  }
}

