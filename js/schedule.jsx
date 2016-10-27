require('bootstrap/dist/css/bootstrap.css');
require('../css/bs-callout.css');
require('../css/team-tiers.css');
require('../css/game.css');

var React = require('react');
var ReactDOM = require('react-dom');
var $ = require('jquery');

var Team = React.createClass({
  render: function() {
    return (
      <p className={'team ' +  this.props.type}>
        <span className='ranking'>{this.props.team.overall.tier}</span>
        {this.props.team.abbreviated_name}
        <span className='record'>
          ({this.props.team.win_loss.wins}-{this.props.team.win_loss.losses})
        </span>
      </p>
    )
  }
});

var Game = React.createClass({
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

var SingleDaySchedule = React.createClass({
  sortByGrade: function(gameOne, gameTwo) {
    if (gameOne.grade > gameTwo.grade) {
      return 1;
    }
    if (gameOne.grade < gameTwo.grade) {
      return -1;
    }
    return 0;
  },
  render: function() {
    var gameNodes = this.props.schedule.sort(this.sortByGrade).map(function(game, index) {
      return (
        <Game home={game.home} away={game.away} grade={game.grade} key={index} />
      );
    });
    return (
      <div className="panel panel-default">
        <div className="panel-heading">{this.props.date}</div>
        <div className="panel-body row">{gameNodes}</div>
      </div>
    );
  }
});

var Schedule = React.createClass({
  getInitialState: function() {
    return {data: {}};
  },
  componentDidMount: function() {
    // TODO refactor into a common method that uses a promise
    $.ajax({
      url: this.props.url,
      dataType: 'xml',
      cache: false,
      success: function(xml) {
        var relevant_regex = new RegExp('^'+process.env.SEASON + '\\/\\d{4}-\\d{2}-\\d{2}-schedule.json');
        var relevant_keys = $(xml).find('Contents')
          .map(function(){
            return $('Key', this).text();
          })
          .filter(function(){
            return relevant_regex.test(this);
          });
        var latest_key = relevant_keys[0];
        relevant_keys.each(function(){
          latest_key = this > latest_key ? this : latest_key;
        })
        var latest_url = this.props.url + '/' + latest_key;
        $.ajax({
          url: latest_url,
          dataType: 'json',
          cache: true,
          success: function(data) {
            this.setState({data: data});
          }.bind(this),
          error: function(xhr, status, err) {
            console.error(latest_url, status, err.toString());
          }
        });
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }
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
  <Schedule url={process.env.API_DOMAIN} />,
  document.getElementById('content')
);
