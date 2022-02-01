using StudentAssociationAPI.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StudentAssociationAPI.Entities
{
    public class Member
    {
        public string Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Address { get; set; }
        public DateTime RegistrationDate { get; set; }

        // a Member can take part in MANY Associations and ONE Commitee;
        // a Member can review MANY Applications
        public virtual User User { get; set; }
        public virtual ICollection<AssociationMembership> AssociationMemberships { get; set; }
        public virtual ICollection<BoardMembership> BoardMemberships { get; set; }
        public virtual CommiteeMembership CommiteeMembership { get; set; }
        public virtual ICollection<Application> Applications { get; set; }
        public virtual ICollection<EventRegistration> EventRegistrations { get; set; }

        public Member(MemberModel m)
        {
            Id = m.Id;
            FirstName = m.FirstName;
            LastName = m.LastName;
            Address = m.Address;
            RegistrationDate = DateTime.Now;

            User = null;
            AssociationMemberships = null;
            BoardMemberships = null;
            CommiteeMembership = null;
            Applications = null;
            EventRegistrations = null;
        }

        public Member() { }
    }
}