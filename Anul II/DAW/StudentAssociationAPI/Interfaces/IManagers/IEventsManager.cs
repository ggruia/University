using StudentAssociationAPI.Entities;
using StudentAssociationAPI.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StudentAssociationAPI.Interfaces.IManagers
{
    public interface IEventsManager
    {
        Task<List<Event>> GetAllEvents();
        Task<Event> GetEventById(string id);
        Task Create(EventCreationModel model);
        Task Update(EventUpdateModel model);
        Task Delete(string id);
    }
}
