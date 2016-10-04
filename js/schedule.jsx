require('bootstrap/dist/css/bootstrap.css');
require('../css/bs-callout.css');

var React = require('react');
var ReactDOM = require('react-dom');
var $ = require('jquery')

var Game = React.createClass({
  render: function() {
    return (
      <div className={"col-md-3 col-xs-3 bs-callout bs-callout-" + this.props.grade.toLowerCase()}>
        <h4>{this.props.grade.toUpperCase()}</h4>
        <p>
          {this.props.away.abbreviated_name}
          <br />
          {this.props.home.abbreviated_name}
        </p>
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
    $.ajax({
      url: this.props.url,
      dataType: 'json',
      cache: true,
      success: function(data) {
        this.setState({data: data});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
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
      <section className="col-md-8 col-xs-12">
        <h3>Schedule</h3>
        {dayNodes}
      </section>
    );
  }
});

ReactDOM.render(
  <Schedule url="/data/2016-04-13-schedule.json" />,
  document.getElementById('content')
);
