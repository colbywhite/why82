import { Component } from '@angular/core';
import { GamesService } from './games.service';
import { Game } from './game.model';
import * as moment from 'moment';
import { Moment } from 'moment';


@Component({
  selector: 'app-root',
  template: `
    <div>
      <app-nav></app-nav>
      <app-day [date]="date" [games]="games"></app-day>
    </div>
  `
})
export class AppComponent {
  public games: Game[];
  public date: Moment = moment('2018-04-11');

  constructor(private gameSvc: GamesService) {
    this.games = this.gameSvc.games;
  }

}
