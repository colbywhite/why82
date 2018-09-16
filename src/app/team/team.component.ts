import { Component, Input } from '@angular/core';
import { Team } from '../game.model';

@Component({
  selector: 'app-team',
  styles: [
    'div.fab {width: 1em; height: 100%; border: aqua 1px solid;}'
  ],
  template: `
    <div>
      {{team.short_name}}
      <div class="fab">{{team.abbreviated_name}}</div>
    </div>
  `
})
export class TeamComponent {
  @Input()
  public team: Team;

  constructor() {
  }

}
