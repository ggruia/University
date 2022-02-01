import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

import { DashboardComponent } from './dashboard/dashboard.component';
import { AssociationsComponent } from './associations/associations.component';
import { ProfileComponent } from './profile/profile.component';
import { EventsComponent } from './events/events.component';

const routes: Routes = [
    {
        path: 'dashboard',
        component: DashboardComponent,
        children: [
            {
                path: 'profile',
                component: ProfileComponent
            },
            {
                path: 'associations',
                component: AssociationsComponent
            },
            {
                path: 'events',
                component: EventsComponent
            }
        ]
    }
];

@NgModule({
    imports: [RouterModule.forChild(routes)],
    exports: [RouterModule]
})
export class DashboardRoutingModule { }