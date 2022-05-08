import { Component, OnDestroy, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { Subscription } from 'rxjs';
import { DataService } from 'src/app/services/data.service';


@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.scss']
})
export class DashboardComponent implements OnInit, OnDestroy {
    
    constructor(
        private router: Router,
        private dataService: DataService
    ) { }

    ngOnInit(): void {
        this.usernameSubscription = this.dataService.username.subscribe(user => this.username = user);
    }

    ngOnDestroy(): void {
        this.usernameSubscription.unsubscribe();
    }

    public usernameSubscription!: Subscription;
    public username!: string;

    


    public logout(): void {
        localStorage.setItem('Role', 'Anonymous');
        this.router.navigate(['../auth/login']);
    }

    public tabSelect(event: any): void {
        switch (event.index) {
            case 0:
                this.router.navigate(['/dashboard/profile']);
                break;
            case 1:
                this.router.navigate(['/dashboard/associations']);
                break;
            case 2:
                this.router.navigate(['/dashboard/events']);
                break;
        }
    }
}
