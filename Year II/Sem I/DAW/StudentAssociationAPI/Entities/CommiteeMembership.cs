using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StudentAssociationAPI.Entities
{
    public class CommiteeMembership
    {
        public string Id { get; set; }
        public string MemberId { get; set; }
        public string CommiteeId { get; set; }
        public DateTime JoinDate { get; set; }

        public virtual Member Member { get; set; }
        public virtual Commitee Commitee { get; set; }

        public CommiteeMembership() { }
    }
}
