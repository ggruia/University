using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace StudentAssociationAPI.Models
{
    public class EventRegistrationModel
    {
        [Required]
        public string MemberId { get; set; }
        [Required]
        public string EventId { get; set; }
    }
}
