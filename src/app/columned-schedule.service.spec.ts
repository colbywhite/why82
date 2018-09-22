import { TestBed } from '@angular/core/testing';

import { ColumnedScheduleService } from './columned-schedule.service';

describe('ColumnedScheduleService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: ColumnedScheduleService = TestBed.get(ColumnedScheduleService);
    expect(service).toBeTruthy();
  });
});
