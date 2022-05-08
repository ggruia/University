import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { AuthService } from './auth.service';

@Injectable({
    providedIn: 'root'
})
export class AssociationsService {

    public url = 'https://localhost:5001/api/Associations';
    constructor(
        public http: HttpClient,
        public authService: AuthService
    ) { }

    public getAssociations(): Observable<any> {
        return this.http.get(`${this.url}/all`, { headers: this.authService.getAuthHeaders() });
    }
}
