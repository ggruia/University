using StudentAssociationAPI.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StudentAssociationAPI.Entities
{
    public class Commitee
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public string AssociationId { get; set; }
        public DateTime InaugurationDate { get; set; }
        public string Description { get; set; }

        public virtual Association Association { get; set; }
        public virtual ICollection<CommiteeMembership> CommiteeMemberships { get; set; }
        public virtual ICollection<Event> Events { get; set; }

        public Commitee(CommiteeCreationModel c)
        {
            Id = Guid.NewGuid().ToString();
            Name = c.Name;
            AssociationId = c.AssociationId;
            Description = c.Description;
            InaugurationDate = DateTime.Now;

            Association = null;
            CommiteeMemberships = null;
            Events = null;
        }

        public Commitee() { }
    }
}
