require('bootstrap/dist/css/bootstrap.css');
require('../css/tier-table.css');

const React = require('react');
const ReactDOM = require('react-dom');
const $ = require('jquery')
const date_utils = require('./data_utils');
const Logo = require('./team_logo');

const TeamRow = React.createClass({
  getClass: function(tier) {
    if(tier == 1) {
      return 'success'
    }
    else {
      return ''
    }
  },
  render: function() {
    return (
      <tr>
        <td>
          <Logo abbreviation={this.props.abbreviated_name} />
          {this.props.abbreviated_name}
        </td>

        <td className={this.getClass(this.props.data.overall.tier)}>{this.props.data.overall.tier}</td>
        <td className={this.getClass(this.props.data.overall.tier)}>{this.props.data.overall.avg}</td>

        <td className={this.getClass(this.props.data.win_loss.tier)}>{this.props.data.win_loss.tier}</td>
        <td className={this.getClass(this.props.data.win_loss.tier)}>{this.props.data.win_loss.wins}</td>
        <td className={this.getClass(this.props.data.win_loss.tier)}>{this.props.data.win_loss.losses}</td>
        <td className={this.getClass(this.props.data.win_loss.tier)}>{this.props.data.win_loss.win_loss_pct}</td>

        <td className={this.getClass(this.props.data.rating_diff.tier)}>{this.props.data.rating_diff.tier}</td>
        <td className={this.getClass(this.props.data.rating_diff.tier)}>{this.props.data.rating_diff.rating_diff}</td>

        <td className={this.getClass(this.props.data.pace.tier)}>{this.props.data.pace.tier}</td>
        <td className={this.getClass(this.props.data.pace.tier)}>{this.props.data.pace.pace}</td>
      </tr>
    );
  }
});

const OuterHeaderRow = React.createClass({
  render: function() {
    return (
      <tr>
        <th></th>
        <th colSpan='2'>Overall</th>
        <th colSpan='4'>Win-Loss</th>
        <th colSpan='2'>Rating</th>
        <th colSpan='2'>Pace</th>
      </tr>
    );
  }
});

const InnerHeaderRow = React.createClass({
  render: function() {
    return (
      <tr>
        <th className='col-md-2'></th>
        <th className='col-md-1'>Tier</th>
        <th className='col-md-1'>Tier Avg.</th>
        <th className='col-md-1'>Tier</th>
        <th className='col-md-1'>Wins</th>
        <th className='col-md-1'>Losses</th>
        <th className='col-md-1'>Pct</th>
        <th className='col-md-1'>Tier</th>
        <th className='col-md-1'>R. Diff.</th>
        <th className='col-md-1'>Tier</th>
        <th className='col-md-1'>Pace</th>
      </tr>
    );
  }
});

const TiersTable = React.createClass({
  getInitialState: function() {
    return {data: {}};
  },
  componentDidMount: function() {
    date_utils.grab_latest_tiers_data(this.props.bucketUrl, process.env.SEASON)
      .then(function(data){
        this.setState({data: data});
      }.bind(this))
      .catch(function(errorMessage){
        console.error(errorMessage);
      });
  },
  render: function() {
    var teamRows = <div />;
    if (!$.isEmptyObject(this.state.data)) {
      teamRows = Object.keys(this.state.data).sort().map(function(name, index) {
        return <TeamRow key={index} data={this.state.data[name]} abbreviated_name={name} />;
      }.bind(this));
    };
    return (
      <div className='table-responsive col-md-8 col-md-offset-2 col-xs-12'>
        <h3>Tier Information</h3>
        <table className="table table-hover table-bordered table-striped tiers-table text-center">
          <thead>
            <OuterHeaderRow />
            <InnerHeaderRow />
          </thead>
          <tbody>
            {teamRows}
          </tbody>
        </table>
      </div>
    );
  }
});

ReactDOM.render(
  <TiersTable bucketUrl={process.env.BUCKET_URL} />,
  document.getElementById('content')
);
