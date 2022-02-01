import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { DashboardComponent } from './dashboard/dashboard.component';
import { DashboardRoutingModule } from './dashboard-routing.module';
import { MaterialModule } from '../material/material.module';
import { AssociationsComponent } from './associations/associations.component';
import { ProfileComponent } from './profile/profile.component';
import { EventsComponent } from './events/events.component';
import { ParanthesisPipe } from 'src/app/paranthesis.pipe';


@NgModule({
    declarations: [
        DashboardComponent,
        AssociationsComponent,
        ProfileComponent,
        EventsComponent,
        ParanthesisPipe
    ],
    imports: [
        CommonModule,
        MaterialModule,
        DashboardRoutingModule
    ],
    exports: [
        ParanthesisPipe
    ]
})
export class DashboardModule { }