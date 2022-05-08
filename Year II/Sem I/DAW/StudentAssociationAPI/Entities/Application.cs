using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StudentAssociationAPI.Entities
{
    // a Member can fill out an Application to join an Association;
    // the Application is reviewed by another Member of the Association chosen in the Application form;
    public class Application
    {
        public string Id { get; set; }
        public string MemberId { get; set; }
        public string AssociationId { get; set; }
        public DateTime SubmissionDate { get; set; }
        public string Answer { get; set; }
        public string ReviewerId { get; set; }

        public virtual Member Member { get; set; }
        public virtual Association Association { get; set; }

        public Application() { }
    }
}
