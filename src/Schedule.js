import React, { Component } from 'react';
import SingleDaySchedule from './SingleDaySchedule'

class Schedule extends Component {
  buildDaySchedule = (day, key) => {
    return (
      <SingleDaySchedule date={day} key={key} schedule={this.props.schedule[day]} />
    )
  }

  render() {
    if(!this.props.schedule) {
      return <p>Loading</p>
    }
    const panels = Object.keys(this.props.schedule).map(this.buildDaySchedule)
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
