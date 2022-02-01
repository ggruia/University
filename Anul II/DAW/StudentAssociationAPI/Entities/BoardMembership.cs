using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StudentAssociationAPI.Entities
{
    public class BoardMembership
    {
        public string Id { get; set; }
        public string MemberId { get; set; }
        public string AssociationId { get; set; }
        public DateTime JoinDate { get; set; }

        public virtual Member Member { get; set; }
        public virtual Association Association { get; set; }

        public BoardMembership() { }
    }
}
