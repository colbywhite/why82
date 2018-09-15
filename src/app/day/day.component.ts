import { Component, Input } from '@angular/core';
import { Game } from '../game.model';
import { Moment } from 'moment';

@Component({
  selector: 'app-day',
  template: `
    <p>{{date | amDateFormat:'ddd MMM Do, YYYY'}}</p>
    <app-game *ngFor="let g of games" [game]="g"></app-game>
  `
})
export class DayComponent {
  @Input()
  public games: Game[];
  @Input()
  public date: Moment;

  constructor() {
  }

}
