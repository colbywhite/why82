import { Component, Input } from '@angular/core';
import { Game } from '../game.model';

@Component({
  selector: 'app-game-table',
  styles: [
    'table {width: 100%;}'
  ],
  template: `
    <table mat-table [dataSource]="games">

      <ng-container matColumnDef="time">
        <th mat-header-cell *matHeaderCellDef>Time</th>
        <td mat-cell *matCellDef="let g"> {{g.time | amDateFormat:'h:mm az'}}</td>
      </ng-container>

      <ng-container matColumnDef="away">
        <th mat-header-cell *matHeaderCellDef>Away</th>
        <td mat-cell *matCellDef="let g"> {{g.away.short_name}}</td>
      </ng-container>

      <ng-container matColumnDef="home">
        <th mat-header-cell *matHeaderCellDef>Home</th>
        <td mat-cell *matCellDef="let g"> {{g.home.short_name}}</td>
      </ng-container>

      <tr mat-header-row *matHeaderRowDef="displayedColumns"></tr>
      <tr mat-row *matRowDef="let row; columns: displayedColumns;"></tr>
    </table>
  `
})
export class GameTableComponent {
  public displayedColumns = ['time', 'away', 'home'];
  @Input()
  public games: Game[];

  constructor() {
  }

}
