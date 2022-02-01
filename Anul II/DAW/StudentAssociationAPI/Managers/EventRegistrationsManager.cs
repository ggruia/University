using StudentAssociationAPI.Entities;
using StudentAssociationAPI.Interfaces.IManagers;
using StudentAssociationAPI.Interfaces.IRepositories;
using StudentAssociationAPI.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StudentAssociationAPI.Managers
{
    public class EventRegistrationsManager : IEventRegistrationsManager
    {
        private readonly IEventRegistrationsRepository _repository;

        public EventRegistrationsManager(IEventRegistrationsRepository repo)
        {
            _repository = repo;
        }


        public async Task<List<EventRegistration>> GetAllEventRegistrations()
        {
            return await _repository.GetAll();
        }
        public async Task<EventRegistration> GetEventRegistrationById(string id)
        {
            return await _repository.GetById(id);
        }

        public async Task Create(EventRegistrationModel model)
        {
            var eventRegistration = new EventRegistration(model);

            await _repository.Insert(eventRegistration);

            await _repository.Save();
        }

        public async Task Delete(string id)
        {
            await _repository.DeleteById(id);

            await _repository.Save();
        }
    }
}
