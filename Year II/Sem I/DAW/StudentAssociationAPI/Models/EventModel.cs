using StudentAssociationAPI.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StudentAssociationAPI.Models
{
    public class EventModel
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public string Location { get; set; }
        public string Description { get; set; }
        public DateTime StartTime { get; set; }
        public DateTime EndTime { get; set; }
        public string CommiteeId { get; set; }
        public bool IsCanceled { get; set; }

        public EventModel(Event ev)
        {
            Id = ev.Id;
            Name = ev.Name;
            Location = ev.Location;
            Description = ev.Description;
            StartTime = ev.StartTime;
            EndTime = ev.EndTime;
            CommiteeId = ev.CommiteeId;
            IsCanceled = ev.IsCanceled;
        }

        public EventModel() { }
    }
}
