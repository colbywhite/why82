import React, { Component } from 'react';
import { BrowserRouter, Route } from 'react-router-dom';
import Schedule from './Schedule';
import About from './About';
import Nav from './Nav';

class App extends Component {
  render() {
    return (
      <BrowserRouter>
        <div>
          <Nav />
          <Route exact path="/" component={Schedule} />
          <Route path="/about" component={About} />
        </div>
      </BrowserRouter>
    );
  }
}

export default App;
