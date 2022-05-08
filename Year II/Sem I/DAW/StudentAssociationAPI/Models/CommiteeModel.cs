using StudentAssociationAPI.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StudentAssociationAPI.Models
{
    public class CommiteeModel
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public string AssociationId { get; set; }
        public DateTime InaugurationDate { get; set; }
        public string Description { get; set; }

        public CommiteeModel(Commitee c)
        {
            Id = c.Id;
            Name = c.Name;
            AssociationId = c.AssociationId;
            InaugurationDate = c.InaugurationDate;
            Description = c.Description;
        }

        public CommiteeModel() { }
    }
}
