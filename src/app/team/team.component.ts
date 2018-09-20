import { Component, Input } from '@angular/core';
import { Team } from '../game.model';

export const TEAM_COMPONENT_HEIGHT_PX = 50;
export const TEAM_COMPONENT_MARGIN_PX = 5;

@Component({
  selector: 'app-team',
  styles: [
    `:host {margin: ${TEAM_COMPONENT_MARGIN_PX}px; height: ${TEAM_COMPONENT_HEIGHT_PX}px;}`,
    `img.logo {width: ${TEAM_COMPONENT_HEIGHT_PX}px; height: ${TEAM_COMPONENT_HEIGHT_PX}px; margin: 0;}`
  ],
  template: `
    <img class="logo" [src]="iconSrc"/>
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
