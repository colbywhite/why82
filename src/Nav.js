import React, { Component } from 'react';
import {Link} from 'react-router-dom'

class Nav extends Component {
  render() {
    return (
      <nav className="navbar navbar-expand-lg navbar-light bg-light">
        <Link className="navbar-brand" to="/">
          Why 82? <small>v{process.env.REACT_APP_VERSION || 2018}</small>
        </Link>
        <div className="navbar-collapse">
          <div className="navbar-nav">
           <div className="nav-item">
             <Link className="nav-link" to="/about">
               <small>About</small>
             </Link>
           </div>
         </div>
        </div>
      </nav>
    )
  }
}

export default Nav
