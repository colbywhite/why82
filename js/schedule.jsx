require('bootstrap/dist/css/bootstrap.css');
require('../css/bs-callout.css');
require('../css/team-tiers.css');
require('../css/game.css');

const React = require('react');
const ReactDOM = require('react-dom');
const date_utils = require('./data_utils');
const Logo = require('./team_logo');
const $ = require('jquery');
const moment = require('moment');

const Team = React.createClass({
  render: function() {
    return (
      <div className={'team container-fluid ' +  this.props.type}>
        <div className='row'>
          <div className='col-md-4 col-xs-4 ranking'>
            {this.props.team.overall.tier}
            <Logo abbreviation={this.props.team.abbreviated_name} />
          </div>
          <div className='col-md-8 col-xs-8 team-info'>
            <div className='row'>
              <div className='col-md-12 col-xs-12'>
                {this.props.team.short_name}
              </div>
              <div className='col-md-12 col-xs-12 record'>
                ({this.props.team.win_loss.wins}-{this.props.team.win_loss.losses})
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  }
});

const Game = React.createClass({
  render: function() {
    return (
      <div className={"col-md-4 col-xs-12 game"}>
        <div className={"bs-callout bs-callout-" + this.props.grade.toLowerCase()}>
          <h4>{this.props.grade.toUpperCase()}</h4>
          <Team type='away' team={this.props.away} />
          <Team type='home' team={this.props.home} />
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
  render: function() {
    const gameNodes = this.props.schedule.sort(this.sortByGrade).map(function(game, index) {
      return (
        <Game home={game.home} away={game.away} grade={game.grade} key={index} />
      );
    });
    return (
      <div className="panel panel-default">
        <div className="panel-heading">{this.formatDate(this.props.date)}</div>
        <div className="panel-body row">{gameNodes}</div>
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
      <section className="col-md-8 col-md-offset-2 col-xs-12">
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
