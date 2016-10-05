require('bootstrap/dist/css/bootstrap.css');
var React = require('react');
var ReactDOM = require('react-dom');
var $ = require('jquery')

var PaceCells = React.createClass({
  render: function() {
    return (
      <section>
        <div>{this.props.data.tier}</div>
        <div>{this.props.data.pace}</div>
      </section>
    )
  }
});

var WinLossCells = React.createClass({
  render: function() {
    return (
      <section>
        <div>{this.props.data.tier}</div>
        <div>{this.props.data.wins}</div>
        <div>{this.props.data.losses}</div>
        <div>{this.props.data.win_loss_pct}</div>
      </section>
    )
  }
});

var RatingCells = React.createClass({
  render: function() {
    return (
      <section>
        <div>{this.props.data.tier}</div>
        <div>{this.props.data.rating_diff}</div>
      </section>
    )
  }
});

var OverallCells = React.createClass({
  render: function() {
    return (
      <section>
        <div>{this.props.data.tier}</div>
        <div>{this.props.data.avg}</div>
      </section>
    )
  }
});

var TeamNameCell = React.createClass({
  render: function() {
    return (
      <div>{this.props.abbreviated_name}</div>
    )
  }
});

var TeamRow = React.createClass({
  render: function() {
    return (
      <section>
        <TeamNameCell abbreviated_name={this.props.abbreviated_name} />
        <OverallCells data={this.props.data.overall} />
        <WinLossCells data={this.props.data.win_loss} />
        <RatingCells data={this.props.data.rating_diff} />
        <PaceCells data={this.props.data.pace} />
      </section>
    );
  }
});

var TiersTable = React.createClass({
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
    var teamNodes = <br />;
    if (!$.isEmptyObject(this.state.data)) {
      teamNodes = Object.keys(this.state.data).sort().map(function(name, index) {
        return <TeamRow key={index} data={this.state.data[name]} abbreviated_name={name} />;
      }.bind(this));
    };
    return (
      <section className="col-md-8 col-xs-12">
        <h3>Tiers</h3>
        {teamNodes}
      </section>
    );
  }
});

ReactDOM.render(
  <TiersTable url="/data/2016-04-13-tiers.json" />,
  document.getElementById('content')
);
