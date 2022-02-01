import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatButtonModule } from '@angular/material/button';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatTableModule } from '@angular/material/table';
import { MatTabsModule } from '@angular/material/tabs';
import { MatListModule } from '@angular/material/list';
import { MatExpansionModule } from '@angular/material/expansion';
import { MatIconModule } from '@angular/material/icon';
import { MatCardModule } from '@angular/material/card';
import { MatDividerModule } from '@angular/material/divider';
import { MatToolbarModule } from '@angular/material/toolbar';


@NgModule({
    declarations: [],
    imports: [
        CommonModule,
        MatButtonModule,
        MatFormFieldModule,
        MatInputModule,
        MatTableModule,
        MatTabsModule,
        MatListModule,
        MatExpansionModule,
        MatIconModule,
        MatCardModule,
        MatDividerModule,
        MatToolbarModule
    ],
    exports: [
        MatButtonModule,
        MatFormFieldModule,
        MatInputModule,
        MatTableModule,
        MatTabsModule,
        MatListModule,
        MatExpansionModule,
        MatIconModule,
        MatCardModule,
        MatDividerModule,
        MatToolbarModule
    ]
})
export class MaterialModule { }