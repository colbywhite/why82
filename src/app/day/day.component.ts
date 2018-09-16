import { Component, Input } from '@angular/core';
import { Game } from '../game.model';
import { Moment } from 'moment';

@Component({
  selector: 'app-day',
  template: `
    <mat-card>
      <mat-card-header>
        <mat-card-title>{{date | amDateFormat:'ddd MMM Do, YYYY'}}</mat-card-title>
      </mat-card-header>
      <mat-card-content>
        <app-game-table [games]="games"></app-game-table>
      </mat-card-content>
    </mat-card>
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
