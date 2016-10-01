var React = require('react');
var ReactDOM = require('react-dom');
var $ = require('jquery')

var Game = React.createClass({
  render: function() {
    return (
      <div>
        <b>{this.props.grade}</b>:&nbsp;
        {this.props.away.abbreviated_name} @ {this.props.home.abbreviated_name}
      </div>
    )
  }
});

var SingleDaySchedule = React.createClass({
  render: function() {
    var gameNodes = this.props.schedule.map(function(game, index) {
      return (
        <Game home={game.home} away={game.away} grade={game.grade} key={index} />
      );
    });
    return (
      <div>
        <h2>{this.props.date}</h2>
        {gameNodes}
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
      <div>
        <h1>Schedule</h1>
        {dayNodes}
      </div>
    );
  }
});

ReactDOM.render(
  <Schedule url="/data/2016-04-13-schedule.json" />,
  document.getElementById('content')
);
