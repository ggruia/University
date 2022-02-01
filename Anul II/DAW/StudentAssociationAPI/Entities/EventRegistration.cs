using StudentAssociationAPI.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StudentAssociationAPI.Entities
{
    public class EventRegistration
    {
        public string Id { get; set; }
        public string MemberId { get; set; }
        public string EventId { get; set; }

        public virtual Member Member { get; set; }
        public virtual Event Event { get; set; }

        public EventRegistration (EventRegistrationModel er)
        {
            Id = Guid.NewGuid().ToString();
            MemberId = er.MemberId;
            EventId = er.EventId;

            Member = null;
            Event = null;
        }

        public EventRegistration() { }
    }
}
