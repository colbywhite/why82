import { Component, Input } from '@angular/core';
import { Team } from '../game.model';

@Component({
  selector: 'app-team',
  styles: [
    ':host {margin: 0.25em}',
    'img.logo {width: 50px; height: 50px; margin: 0;}'
  ],
  template: `
    <div class="wrapper">
      <img class="logo" [src]="iconSrc"/>
    </div>
  `
})
export class TeamComponent {
  @Input()
  public team: Team;

  constructor() {
  }

  public get iconSrc() {
    return `/assets/icons/${this.team.abbreviated_name.toLowerCase()}.svg`;
  }
}
