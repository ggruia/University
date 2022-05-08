import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { DataService } from './data.service';

@Injectable({
    providedIn: 'root'
})
export class AuthService {

    private apiUrl: string = 'https://localhost:5001/api/Authentication/';
    private username: string = '';

    constructor(private http: HttpClient) { }
    
    public login(loginForm: any): Observable<any> {
        return this.http.post(this.apiUrl + 'login', loginForm);
    }

    public register(registerForm: any): Observable<any> {
        console.log(registerForm);
        return this.http.post(this.apiUrl + 'signup-user', registerForm);
    }

    public deleteStorage() {
        localStorage.removeItem('Role');
        localStorage.removeItem('Token');
        localStorage.removeItem('UserId');
    }

    public getUsername(): string {
        return this.username;
    }

    public getAuthHeaders(): HttpHeaders {
        const token = localStorage.getItem('Token');
        var headers = new HttpHeaders().set('Authorization', 'Bearer ' + token);
        return headers;
    }
}
