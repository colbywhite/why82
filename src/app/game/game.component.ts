import { Component, Input } from '@angular/core';
import { Game } from '../game.model';

@Component({
  selector: 'app-game',
  template: `
    <p>{{game.away.short_name}} @ {{game.home.short_name}}</p>
  `
})
export class GameComponent {
  @Input()
  public game: Game;

  constructor() {
  }

}
