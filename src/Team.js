import React, { Component } from 'react'
import './TeamLogo.css'

class Team extends Component {
  render() {
    const team = this.props.team
    return (
      <div className="row mx-0 my-2 team">
        <div className="p0 mx-0 row">
          <img className='img-fluid logo my-auto' alt={team.abbreviated_name} src={`${process.env.PUBLIC_URL}/img/${team.abbreviated_name.toLowerCase()}.png`} />
        </div>
        <div className="ml-2 my-0">
          <div className='p0 m0'>{team.short_name}</div>
          <div className='p0 m0'>
            <small>
              {team.metrics.win_loss.Wins}-{team.metrics.win_loss.Losses} record, {team.score} ENT
            </small>
          </div>
        </div>
      </div>
    )
  }
}

export default Team
