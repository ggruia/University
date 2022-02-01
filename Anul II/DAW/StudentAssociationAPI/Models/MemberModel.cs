using StudentAssociationAPI.Entities;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace StudentAssociationAPI.Models
{
    public class MemberModel
    {
        [Required]
        public string Id { get; set; }
        [Required]
        public string FirstName { get; set; }
        [Required]
        public string LastName { get; set; }
        [Required]
        public string Address { get; set; }

        public MemberModel(Member m)
        {
            Id = m.Id;
            FirstName = m.FirstName;
            LastName = m.LastName;
            Address = m.Address;
        }

        public MemberModel(User u)
        {
            Id = u.Id;
            FirstName = null;
            LastName = null;
            Address = null;
        }

        public MemberModel() { }
    }
}
