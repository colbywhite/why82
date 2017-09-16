import React, { Component } from 'react';

class Nav extends Component {
  render() {
    return (
      <nav className="navbar navbar-light bg-light">
        <a className="navbar-brand" href="/">
          Why 82? <small>v{process.env.REACT_APP_VERSION || 2018}</small>
        </a>
      </nav>
    )
  }
}

export default Nav
