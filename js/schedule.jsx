require('bootstrap/dist/css/bootstrap.css');
require('../css/game.css');

const React = require('react');
const ReactDOM = require('react-dom');
const date_utils = require('./data_utils');
const $ = require('jquery');
const moment = require('moment');
const momentTz = require('moment-timezone/builds/moment-timezone-with-data.min');

const Tier = React.createClass({
  render: function() {
    return <div className='tier'>{this.props.tier}</div>
  }
});

const TeamLogo = React.createClass({
  render: function() {
    return (
      <div className='teamLogo'>
        <img className='teamLogo' src={'img/'+this.props.name.toLowerCase()+'.png'}/>
      </div>
      )
  }
});

const TeamName = React.createClass({
  render: function() {
    return <div className='teamName teamDataEntry'>{this.props.name}</div>
  }
});

const TeamRecord = React.createClass({
  render: function() {
    return <div className='teamRecord teamDataEntry'>({this.props.wins}-{this.props.losses})</div>
  }
});

const Team = React.createClass({
  render: function() {
    return (
      <div className="team">
        <Tier tier={this.props.team.overall.tier}/>
        <TeamLogo name={this.props.team.abbreviated_name}/>
        <div className="teamData">
          <TeamName name={this.props.team.short_name}/>
          <TeamRecord
            wins={this.props.team.win_loss.wins}
            losses={this.props.team.win_loss.losses}
            />
        </div>
      </div>
    )
  }
});

const ViewInfo = React.createClass({
  formatTime: function(dateString) {
    return moment(dateString).tz('America/New_York').format('h:mm a z');
  },
  render: function() {
    return (
      <div className="viewInfo">
        {this.formatTime(this.props.time)}
      </div>
    )
  }
});

const Grade = React.createClass({
  render: function() {
    return (
      <div className={"grade grade" + this.props.grade}>
        {this.props.grade}
      </div>
    )
  }
});

const Game = React.createClass({
  render: function() {
    return (
      <div className="game">
        <Grade grade={this.props.game.grade} />
        <div className="gameBody">
          <ViewInfo time={this.props.game.time} />
          <Team team={this.props.game.away} />
          <Team team={this.props.game.home} />
        </div>
      </div>
    )
  }
});

const SingleDaySchedule = React.createClass({
  sortByGrade: function(gameOne, gameTwo) {
    if (gameOne.grade > gameTwo.grade) {
      return 1;
    }
    if (gameOne.grade < gameTwo.grade) {
      return -1;
    }
    return 0;
  },
  formatDate: function(dateString) {
    return moment(dateString).format('ddd, MMM Do, YYYY');
  },
  splitGamesIntoRowsOfThree: function(games) {
    var gameRows = [];
    for (var i=0; i<games.length; i+=3) {
      const end = Math.min(i+3, games.length);
      gameRows.push(
        <div className="rowsOfThree" key={Math.floor(i/3)}>{games.slice(i, end)}</div>
      );
    };
    return gameRows;
  },
  render: function() {
    const gameNodes = this.props.schedule.sort(this.sortByGrade).map(function(game, index) {
      return (
        <Game game={game} key={index} />
      );
    });
    return (
      <div className="panel panel-default">
        <div className="panel-heading">{this.formatDate(this.props.date)}</div>
        <div className="panel-body row">
          {this.splitGamesIntoRowsOfThree(gameNodes)}
        </div>
      </div>
    );
  }
});

const Schedule = React.createClass({
  getInitialState: function() {
    return {data: {}};
  },
  componentDidMount: function() {
    date_utils.grab_latest_schedule_data(this.props.bucketUrl, process.env.SEASON)
      .then(function(data){
        this.setState({data: data});
      }.bind(this))
      .catch(function(errorMessage){
        console.error(errorMessage);
      });
  },
  render: function() {
    var dayNodes = <br />;
    if (!$.isEmptyObject(this.state.data)) {
      dayNodes = Object.keys(this.state.data).sort().map(function(day, index) {
        return (
          <SingleDaySchedule date={day} key={index} schedule={this.state.data[day]} />
        );
      }.bind(this));
    };
    return (
      <section className="schedule">
        <h3>Schedule</h3>
        {dayNodes}
      </section>
    );
  }
});

ReactDOM.render(
  <Schedule bucketUrl={process.env.BUCKET_URL} />,
  document.getElementById('content')
);
