import { Component, OnInit } from '@angular/core';
import { Association } from 'src/app/interfaces/interfaces';
import { AssociationsService } from 'src/app/services/associations.service';

@Component({
    selector: 'app-associations',
    templateUrl: './associations.component.html',
    styleUrls: ['./associations.component.scss']
})
export class AssociationsComponent implements OnInit {

    associations: Association[] = [];

    constructor(
        private associationsService: AssociationsService
    ) { }

    ngOnInit(): void {
        this.associationsService.getAssociations().subscribe({
            next: (result) => {
                this.associations = result;
            },
            error: (error) => {
                console.error(error);
            }
        });
    }
}
