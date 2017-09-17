import React, { Component } from 'react';

class About extends Component {
  // TODO, I'd prefer to have this be a markdown, by create-react-app's markdown support is a bit scarce on first glance.
  render() {
    return (
      <div>
        <h2>About Why82?</h2>
        <p>
          Why82? is aimed at figuring out which of the gazillion NBA games a fan should actually take the time to watch.
        </p>
        <h4>Methodology</h4>
        <p>
          Currently, each team is given a numerical score for the following stats.
          <ul>
            <li>Win Percentage</li>
            <li>Points Per Game</li>
            <li>Points Differential Per Game</li>
          </ul>
          When a team has played less than five games, the score is calculated based on last season's stats.
        </p>
        <p>
          When two teams of high scores are playing against each other, than that game is graded accordingly.
          Any game that features a team with a low score is graded with a <em>D</em>, meaning the stats say you should avoid that game.
        </p>
        <h4>Work in Progress</h4>
        <p>
          The algorithm for grading teams and games is a work in progress. The code is open source and can be found on <a href="https://github.com/colbywhite/why82">GitHub</a>.
        </p>
      </div>
    )
  }
}

export default About;
