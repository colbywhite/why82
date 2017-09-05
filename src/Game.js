import React, { Component } from 'react'
import moment from 'moment-timezone'
import Team from './Team';

class Game extends Component {
  formatTime(dateString) {
    return moment(dateString).tz('America/New_York').format('h:mm a z');
  }

  scoreClass(score) {
    if(score === 'D') {
      return ''
    } else if (score === 'C') {
      return 'bg-primary'
    } else if (score === 'B') {
      return 'bg-info'
    } else if (score === 'A') {
      return 'bg-success'
    }
  }

  render() {
    const game = this.props.game
    return (
      <div className="card">
        <div className={`card-header ${this.scoreClass(game.score)}`}>
          {game.score} rating
        </div>
        <div className="card-body p-2">
          <div className="float-right">
            <small>
              {this.formatTime(game.time)}
            </small>
          </div>
          <Team team={game.away} />
          <Team team={game.home} />
        </div>
      </div>
    )
  }
}

export default Game
