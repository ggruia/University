import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { AuthService } from './auth.service';

@Injectable({
    providedIn: 'root'
})
export class EventsService {

    public url = 'https://localhost:5001/api/Events';
    constructor(
        public http: HttpClient,
        public authService: AuthService
    ) { }

    public getEvents(): Observable<any> {
        return this.http.get(`${this.url}/all`, { headers: this.authService.getAuthHeaders() });
    }
}
