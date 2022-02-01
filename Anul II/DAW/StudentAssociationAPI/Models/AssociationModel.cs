using StudentAssociationAPI.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StudentAssociationAPI.Models
{
    public class AssociationModel
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }

        public AssociationModel(Association association)
        {
            Id = association.Id;
            Name = association.Name;
            Description = association.Description;
        }

        public AssociationModel() { }
    }
}
