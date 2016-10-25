require('bootstrap/dist/css/bootstrap.css');
require('../css/tier-table.css');

var React = require('react');
var ReactDOM = require('react-dom');
var $ = require('jquery')

var TeamRow = React.createClass({
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
        <td>{this.props.abbreviated_name}</td>

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

var OuterHeaderRow = React.createClass({
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

var InnerHeaderRow = React.createClass({
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

var TiersTable = React.createClass({
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
        var relevant_regex = new RegExp('^'+process.env.SEASON + '\\/\\d{4}-\\d{2}-\\d{2}-tiers.json');
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
    var teamRows = <div />;
    if (!$.isEmptyObject(this.state.data)) {
      teamRows = Object.keys(this.state.data).sort().map(function(name, index) {
        return <TeamRow key={index} data={this.state.data[name]} abbreviated_name={name} />;
      }.bind(this));
    };
    return (
      <div className='table-responsive col-md-8 col-md-offset-2'>
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
  <TiersTable url={process.env.API_DOMAIN} />,
  document.getElementById('content')
);
