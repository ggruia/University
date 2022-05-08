import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
    name: 'paranthesis'
})
export class ParanthesisPipe implements PipeTransform {

    transform(value: unknown, ...args: unknown[]): any {
        return "(" + value + ")";
    }
}
