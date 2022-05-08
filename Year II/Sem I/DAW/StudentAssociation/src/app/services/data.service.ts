import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';

@Injectable({
    providedIn: 'root'
})
export class DataService {

    private userSource = new BehaviorSubject<string>('');
    public username = this.userSource.asObservable();

    public apiUrl: string = "https://localhost:5001/api/Authentication/";

    constructor() { }

    public getUserId() {
        return localStorage.getItem('UserId');
    }

    public setUsername(username: string) {
        this.userSource.next(username);
    }
}