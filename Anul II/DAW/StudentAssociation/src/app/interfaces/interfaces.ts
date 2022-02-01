// Base ENTITIES
export interface Member {
    id: string;
    firstName: string;
    lastName: string;
    address: string;
    registrationDate: string;
}

export interface Association {
    id: string;
    name: string;
    description: string;
}

export interface Commitee {
    id: string;
    name: string;
    associationId: string;
    description: string;
    inaugurationDate: string;
}

export interface Event {
    id: string;
    name: string;
    commiteeId: string;
    description: string;
    location: string;
    startTime: string;
    endTime: string;
    isCanceled: boolean;
}


// Associative ENTITIES
export interface EventRegistration {
    id: string;
    memberId: string;
    eventId: string;
}

export interface AssociationMembership {
    id: string;
    memberId: string;
    associationName: string;
    joinDate: string;
}

export interface CommiteeMembership {
    id: string;
    memberId: string;
    commiteeId: string;
    joinDate: string;
}

export interface BoardMembership {
    id: string;
    memberId: string;
    associationName: string;
    joinDate: string;
}