import { Injectable } from '@angular/core';
import { default_games, Game, Schedule } from './game.model';

@Injectable({
  providedIn: 'root'
})
export class GamesService {

  constructor() {
  }

  public get games(): Game[] {
    return default_games;
  }

  public get schedule(): Schedule {
    return {'2018-04-11': this.games, '2018-04-12': this.games};
  }
}
