using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace StudentAssociationAPI.Models
{
    public class CommiteeCreationModel
    {
        [Required]
        public string Name { get; set; }
        [Required]
        public string AssociationId { get; set; }
        public string Description { get; set; }
    }
}
