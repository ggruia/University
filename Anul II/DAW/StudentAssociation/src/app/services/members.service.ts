import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable, of } from 'rxjs';
import { AuthService } from './auth.service';
import { EventsService } from './events.service';

@Injectable({
    providedIn: 'root'
})
export class MembersService {

    public url = 'https://localhost:5001/api/Members';
    constructor(
        public http: HttpClient,
        public authService: AuthService,
        public eventsService: EventsService
    ) { }

    public getEventsOfMember(id: string): Observable<any> {
        return this.http.get(`${this.url}/${id}/events`, { headers: this.authService.getAuthHeaders() });
    }

    public getExcludedEventsOfMember(id: string): Observable<any> {
        return this.http.get(`${this.url}/${id}/events/excluded`, { headers: this.authService.getAuthHeaders() });
    }

    public getAssociationsOfMember(id: string): Observable<any> {
        return this.http.get(`${this.url}/${id}/associations`, { headers: this.authService.getAuthHeaders() });
    }

    public getMemberById(id: string): Observable<any> {
        return this.http.get(`${this.url}/${id}`, { headers: this.authService.getAuthHeaders() });
    }
}
