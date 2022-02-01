import { Component, OnInit } from '@angular/core';
import { Event } from 'src/app/interfaces/interfaces';
import { DataService } from 'src/app/services/data.service';
import { MembersService } from 'src/app/services/members.service';

@Component({
    selector: 'app-events',
    templateUrl: './events.component.html',
    styleUrls: ['./events.component.scss']
})
export class EventsComponent implements OnInit {

    eventsOfMember: Event[] = [];
    excludedEventsOfMember: Event[] = [];

    constructor(
        private membersService: MembersService,
        private dataService: DataService
    ) { }

    ngOnInit(): void {
        this.membersService.getEventsOfMember(this.dataService.getUserId()!).subscribe({
            next: (result) => {
                this.eventsOfMember = result;
            },
            error: (error) => {
                console.error(error);
            }
        });
        this.membersService.getExcludedEventsOfMember(this.dataService.getUserId()!).subscribe({
            next: (result) => {
                this.excludedEventsOfMember = result;
            },
            error: (error) => {
                console.error(error);
            }
        });
    }
}
