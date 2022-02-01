using StudentAssociationAPI.Entities;
using StudentAssociationAPI.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StudentAssociationAPI.Interfaces.IManagers
{
    public interface IEventRegistrationsManager
    {
        Task<List<EventRegistration>> GetAllEventRegistrations();
        Task<EventRegistration> GetEventRegistrationById(string id);
        Task Create(EventRegistrationModel eventRegistration);
        Task Delete(string id);
    }
}
