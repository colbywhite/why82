import React, { Component } from 'react'
import moment from 'moment-timezone'
import Game from './Game';

class SingleDaySchedule extends Component {
  constructor(props) {
    super(props)
    this.state = {groupSize: 2}
    this.updateGroupSize = this.updateGroupSize.bind(this)
  }

  componentDidMount() {
    this.updateGroupSize();
    window.addEventListener('resize', this.updateGroupSize);
  }

  componentWillUnmount() {
    window.removeEventListener('resize', this.updateGroupSize);
  }

  updateGroupSize() {
    if(window.screen.width>=576) {
      this.setState({groupSize: 2})
    } else {
      this.setState({groupSize: 1})
    }
  }

  formatDate(dateString) {
    return moment(dateString).format('ddd, MMM Do, YYYY');
  }

  sortByGrade(gameOne, gameTwo) {
    if (gameOne.score > gameTwo.score) {
      return 1
    }
    if (gameOne.score < gameTwo.score) {
      return -1
    }
    return 0
  }

  groupCards(cards, n) {
    var cardGroups = []
    for (var i=0; i<cards.length; i+=n) {
      const end = Math.min(i+n, cards.length)
      cardGroups.push(
        <div className="card-deck mb-2" key={Math.floor(i/n)}>
          {cards.slice(i, end)}
        </div>
      )
    }
    return cardGroups
  }

  render() {
    const gameNodes = this.props.schedule
      .sort(this.sortByGrade)
      .map((game, index) => {
        return (
          <Game game={game} key={index} />
        )
    })
    return (
      <div className="card mb-2">
        <div className="card-header">
          {this.formatDate(this.props.date)}
        </div>
        <div className="card-body">
          <div className="card-text">
            {this.groupCards(gameNodes, this.state.groupSize)}
          </div>
        </div>
      </div>
    )
  }
}

export default SingleDaySchedule
