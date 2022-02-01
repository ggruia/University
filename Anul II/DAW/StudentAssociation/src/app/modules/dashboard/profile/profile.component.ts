import { Component, Input, OnDestroy, OnInit } from '@angular/core';
import { Subscription } from 'rxjs';
import { DataService } from 'src/app/services/data.service';
import { MembersService } from 'src/app/services/members.service';

@Component({
    selector: 'app-profile',
    templateUrl: './profile.component.html',
    styleUrls: ['./profile.component.scss']
})
export class ProfileComponent implements OnInit, OnDestroy {

    constructor(
        private dataService: DataService,
        private membersService: MembersService
    ) { }

    
    user: any;
    
    ngOnInit(): void {
        this.usernameSubscription = this.dataService.username.subscribe(user => this.username = user);

        this.membersService.getMemberById(this.dataService.getUserId()!).subscribe({
            next: (result) => {
                this.user = result;
            },
            error: (error) => {
                console.error(error);
            }
        });
    }

    ngOnDestroy(): void {
        this.usernameSubscription.unsubscribe();
    }

    public usernameSubscription!: Subscription;
    public username!: string;
}
