using StudentAssociationAPI.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StudentAssociationAPI.Entities
{
    public class Association
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }

        // Association = Commitees + BoardMembers + Members
        public virtual ICollection<Commitee> Commitees { get; set; }
        public virtual ICollection<BoardMembership> BoardMemberships { get; set; }
        public virtual ICollection<AssociationMembership> AssociationMemberships { get; set; }
        public virtual ICollection<Application> Applications { get; set; }

        public Association (AssociationModel a)
        {
            Id = a.Id;
            Name = a.Name;
            Description = a.Description;

            BoardMemberships = null;
            AssociationMemberships = null;
            Applications = null;
            Commitees = null;
        }

        public Association() { }
    }
}
