import React, { Component } from 'react';
import SingleDaySchedule from './SingleDaySchedule'
import BackendClient from './BackendClient'

const DOMAIN = process.env.REACT_APP_BACKEND_DOMAIN
const SEASON = process.env.REACT_APP_SEASON
const STAGE = process.env.REACT_APP_STAGE || 'dev'

class Schedule extends Component {
  constructor(props) {
    super(props);
    this.client = new BackendClient(DOMAIN, STAGE, SEASON)
    this.state = {schedule: false}
  }

  componentDidMount() {
    this.client.getSchedule()
      .then((schedule) => this.setState({schedule: schedule}))
  }

  buildDaySchedule = (day, key) => {
    return (
      <SingleDaySchedule date={day} key={key} schedule={this.state.schedule[day]} />
    )
  }

  render() {
    if(!this.state.schedule) {
      return <p>Loading Schedule</p>
    }
    const panels = Object.keys(this.state.schedule).map(this.buildDaySchedule)
    return (
      <div className="p-2 mx-auto row schedule">
        <div className="col-sm-12 col-md-8 mx-auto">
          <h3>Schedule</h3>
          {panels}
        </div>
      </div>
    )
  }
}

export default Schedule;
