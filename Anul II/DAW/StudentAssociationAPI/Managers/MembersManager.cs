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
    public class MembersManager : IMembersManager
    {
        private readonly IMembersRepository _repository;
        private readonly IEventsRepository _eventsRepository;

        public MembersManager(IMembersRepository repo, IEventsRepository evrepo)
        {
            _repository = repo;
            _eventsRepository = evrepo;
        }


        public async Task<List<Member>> GetAllMembers()
        {
            return await _repository.GetAll();
        }

        public async Task<Member> GetMemberById(string id)
        {
            return await _repository.GetById(id);
        }

        public List<AssociationModel> GetAllAssociationsOfMember(string id)
        {
            var member = _repository.GetAllAssociationsOfMember(id);
            var result = new List<AssociationModel>();

            foreach (var membership in member.AssociationMemberships)
            {
                result.Add(new AssociationModel(membership.Association));
            }

            return result;
        }

        public List<EventModel> GetAllEventsOfMember(string id)
        {
            var member = _repository.GetAllEventsOfMember(id);
            var result = new List<EventModel>();

            foreach (var ev in member.EventRegistrations)
            {
                result.Add(new EventModel(ev.Event));
            }

            return result;
        }

        public List<EventModel> GetAllExcludedEventsOfMember(string id)
        {
            var member = _repository.GetAllEventsOfMember(id);
            var events = _eventsRepository.GetAll().Result;

            var idsOfEventsOfMember = new List<string>();
            foreach(var e in member.EventRegistrations)
            {
                idsOfEventsOfMember.Add(e.EventId);
            }

            var result = new List<EventModel>();

            foreach (var e in events)
            {
                if(!idsOfEventsOfMember.Contains(e.Id))
                {
                    result.Add(new EventModel(e));
                }
            }

            return result;
        }

        public async Task Create(MemberModel model)
        {
            var member = new Member(model);

            await _repository.Insert(member);

            await _repository.Save();
        }

        public async Task Update(MemberModel model)
        {
            var member = (await _repository.GetAll()).FirstOrDefault(x => x.Id == model.Id);
            if (member != null)
            {
                member.FirstName = model.FirstName;
                member.LastName = model.LastName;
                member.Address = model.Address;

                await _repository.Update(member);

                await _repository.Save();
            }
        }
        public async Task Delete(string id)
        {
            await _repository.DeleteById(id);

            await _repository.Save();
        }
    }
}
