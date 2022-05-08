using StudentAssociationAPI.Entities;
using StudentAssociationAPI.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StudentAssociationAPI.Interfaces.IManagers
{
    public interface IMembersManager
    {
        Task<List<Member>> GetAllMembers();
        Task<Member> GetMemberById(string id);
        List<AssociationModel> GetAllAssociationsOfMember(string id);
        List<EventModel> GetAllEventsOfMember(string id);
        List<EventModel> GetAllExcludedEventsOfMember(string id);
        Task Create(MemberModel member);
        Task Update(MemberModel member);
        Task Delete(string id);
    }
}
