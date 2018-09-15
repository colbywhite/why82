import { Injectable } from '@angular/core';
import { default_games, Game } from './game.model';

@Injectable({
  providedIn: 'root'
})
export class GamesService {

  constructor() {
  }

  public get games(): Game[] {
    return default_games;
  }
}
