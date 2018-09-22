import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { DayComponent } from './day.component';
import { DayModule } from './day.module';

describe('DayComponent', () => {
  let component: DayComponent;
  let fixture: ComponentFixture<DayComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      imports: [DayModule]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(DayComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
