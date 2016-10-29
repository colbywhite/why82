require('../css/team_logo.css');

const React = require('react');

const Logo = React.createClass({
  render: function() {
    return (
      <img className='logo' src={'img/'+this.props.abbreviation.toLowerCase()+'.png'} />
    )
  }
});

module.exports = Logo;
