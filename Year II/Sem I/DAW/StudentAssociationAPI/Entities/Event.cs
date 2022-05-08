using StudentAssociationAPI.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StudentAssociationAPI.Entities
{
    public class Event
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public string Location { get; set; }
        public string Description { get; set; }
        public DateTime StartTime { get; set; }
        public DateTime EndTime { get; set; }
        public string CommiteeId { get; set; }
        public bool IsCanceled { get; set; }

        public virtual Commitee Commitee { get; set; }
        public virtual ICollection<EventRegistration> EventRegistrations { get; set; }

        public Event(EventCreationModel ev)
        {
            Id = Guid.NewGuid().ToString();
            Name = ev.Name;
            Location = ev.Location;
            Description = ev.Description;
            StartTime = ev.StartTime;
            EndTime = ev.EndTime;
            CommiteeId = ev.CommiteeId;
            IsCanceled = false;

            Commitee = null;
            EventRegistrations = null;
        }

        public Event() { }
    }
}
