import { Component } from '@angular/core';
import { environment } from '../../environments/environment';

@Component({
  selector: 'app-nav',
  styles: [
    '.spacer { flex: 1 1 auto; }'
  ],
  template: `
    <mat-toolbar>
      <mat-toolbar-row>
        <span>Why82?</span>
        <span class="spacer"></span>
        <span>v{{version}}</span>
      </mat-toolbar-row>
    </mat-toolbar>
  `,
})
export class NavComponent {
  public version: string = environment.VERSION;

  constructor() {
  }

}
