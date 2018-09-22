import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { TeamComponent } from './team.component';
import { TeamModule } from './team.module';
import { Team } from '../game.model';

describe('TeamComponent', () => {
  let component: TeamComponent;
  let fixture: ComponentFixture<TeamComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      imports: [TeamModule]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(TeamComponent);
    component = fixture.componentInstance;
    component.team = {
      abbreviated_name: 'SAS',
      full_name: 'blah',
      short_name: 'blah',
      score: 0
    } as Team;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
