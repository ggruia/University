import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AuthGuard } from './auth.guard';

const routes: Routes = [
    {
        path: 'auth',
        loadChildren: () => import('src/app/modules/auth/auth.module').then(m => m.AuthModule)
    },
    {
        path: '',
        canActivate: [AuthGuard],
        children: [
        {
            path: '',
            loadChildren: () => import('src/app/modules/dashboard/dashboard.module').then(m => m.DashboardModule)
        }]
    }
];

@NgModule({
    imports: [RouterModule.forRoot(routes)],
    exports: [RouterModule]
})
export class AppRoutingModule { }