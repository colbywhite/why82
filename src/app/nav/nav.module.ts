import { NgModule } from '@angular/core';
import { MatToolbarModule } from '@angular/material/toolbar';

import { NavComponent } from './nav.component';

@NgModule({
  declarations: [NavComponent],
  exports: [NavComponent],
  imports: [MatToolbarModule]
})
export class NavModule {
}
