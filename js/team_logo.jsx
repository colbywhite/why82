require('../css/team_logo.css');

const React = require('react');

const Logo = React.createClass({
  render: function() {
    if(this.props.abbreviation) {
      return (
        <img className='logo' src={'img/'+this.props.abbreviation.toLowerCase()+'.png'} />
      )
    }
    else {
      return <div></div>
    }
  }
});

module.exports = Logo;
