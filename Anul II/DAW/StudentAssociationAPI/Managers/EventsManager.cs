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
    public class EventsManager : IEventsManager
    {
        private readonly IEventsRepository _repository;

        public EventsManager(IEventsRepository repo)
        {
            _repository = repo;
        }


        public async Task Create(EventCreationModel model)
        {
            var ev = new Event(model);

            await _repository.Insert(ev);

            await _repository.Save();
        }

        public async Task Delete(string id)
        {
            await _repository.DeleteById(id);

            await _repository.Save();
        }

        public async Task<List<Event>> GetAllEvents()
        {
            return await _repository.GetAll();
        }

        public async Task<Event> GetEventById(string id)
        {
            return await _repository.GetById(id);
        }

        public async Task Update(EventUpdateModel model)
        {
            var ev = await GetEventById(model.Id);

            if (ev != null)
            {
                ev.Name = model.Name;
                ev.Location = model.Location;
                ev.Description = model.Description;
                ev.StartTime = model.StartTime;
                ev.EndTime = model.EndTime;
                ev.IsCanceled = model.IsCanceled;

                await _repository.Update(ev);

                await _repository.Save();
            }

            else
                throw new KeyNotFoundException("No event with that ID!");
        }
    }
}
