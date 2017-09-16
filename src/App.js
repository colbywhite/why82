import React, { Component } from 'react';
import BackendClient from './BackendClient';
import Schedule from './Schedule';
import Nav from './Nav';

class App extends Component {
  constructor(props) {
    super(props);
    this.client = new BackendClient(props.domain, props.stage, props.season)
    this.state = {schedule: false}
  }

  componentDidMount() {
    this.client.getSchedule()
      .then((schedule) => this.setState({schedule: schedule}))
  }

  render() {
    return (
      <div>
        <Nav />
        <Schedule schedule={this.state.schedule} />
      </div>
    );
  }
}

export default App;
