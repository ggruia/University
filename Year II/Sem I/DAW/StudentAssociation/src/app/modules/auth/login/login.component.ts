import { Component, OnInit } from '@angular/core';
import { FormControl, FormGroup } from '@angular/forms';
import { Router } from '@angular/router';
import { AuthService } from 'src/app/services/auth.service';
import { DataService } from 'src/app/services/data.service';

@Component({
    selector: 'app-login',
    templateUrl: './login.component.html',
    styleUrls: ['./login.component.scss']
})
export class LoginComponent implements OnInit {

    public loginForm: FormGroup = new FormGroup({
        username: new FormControl(''),
        password: new FormControl('')
    });

    constructor(
        private router: Router,
        private dataService: DataService,
        private authService: AuthService
    ) { }

    ngOnInit(): void {
    }

    public login(): void {
        
        this.authService.login(this.loginForm.value).subscribe({
            next: (result) => {
                console.log(result);
                    localStorage.setItem('Token', result.token);
                    localStorage.setItem('UserId', result.userId);
                    localStorage.setItem('Role', result.role);

                    this.dataService.setUsername(this.loginForm.value.username);
                    this.router.navigate(['/dashboard/profile']);
                },
                error: (error) => {
                    console.log(error);
                }
            }
        );
    }
}
