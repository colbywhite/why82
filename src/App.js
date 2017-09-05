import React, { Component } from 'react';
import BackendClient from './BackendClient';
import Schedule from './Schedule';

class App extends Component {
  constructor(props) {
    super(props);
    this.client = new BackendClient(props.domain)
    this.state = {schedule: false}
  }

  componentDidMount() {
    this.client.getSchedule()
      .then((schedule) => this.setState({schedule: schedule}))
  }

  render() {
    return (
      <div>
        <nav className="navbar navbar-light bg-light">
          <a className="navbar-brand" href="/">
            Why 82? <small>v{process.env.REACT_APP_VERSION || 2018}</small>
          </a>
        </nav>
        <Schedule schedule={this.state.schedule} />
      </div>
    );
  }
}

export default App;
