import { Component, OnInit } from '@angular/core';
import { FormControl, FormGroup } from '@angular/forms';
import { Router } from '@angular/router';
import { AuthService } from 'src/app/services/auth.service';
import { DataService } from 'src/app/services/data.service';

@Component({
    selector: 'app-register',
    templateUrl: './register.component.html',
    styleUrls: ['./register.component.scss']
})
export class RegisterComponent implements OnInit {

    public registerForm: FormGroup = new FormGroup({
        username: new FormControl(''),
        email: new FormControl(''),
        password: new FormControl(''),
        verifiedPassword: new FormControl('')
    });

    constructor(
        private router: Router,
        private dataService: DataService,
        private authService: AuthService
    ) { }

    ngOnInit(): void {
    }

    public register(): void {

        this.authService.register(this.registerForm.value).subscribe({
            next: (result) => {

                localStorage.setItem('Token', result.token);
                localStorage.setItem('UserId', result.userId);
                localStorage.setItem('Role', result.role);

                this.dataService.setUsername(this.registerForm.value.username);
                this.router.navigate(['/dashboard/profile']);
            },
            error: (error) => {
                console.log(error);
            }
        }
        );
    }
}
