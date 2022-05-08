using Microsoft.EntityFrameworkCore;
using StudentAssociationAPI.Data;
using StudentAssociationAPI.Entities;
using StudentAssociationAPI.Interfaces.IRepositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StudentAssociationAPI.Repositories
{
    public class MembersRepository : BaseRepository<Member>, IMembersRepository
    {
        // inject Context into Repository
        public MembersRepository(Context context) : base(context) {}


        public Member GetAllAssociationsOfMember(string memberId)
        {
            var memberWithAssociations = _table
                .Include(m => m.AssociationMemberships)
                .ThenInclude(m => m.Association)
                .FirstOrDefault(m => m.Id == memberId);

            return memberWithAssociations;
        }

        public Member GetAllEventsOfMember(string memberId)
        {
            var memberWithEvents = _table
                .Include(m => m.EventRegistrations)
                .ThenInclude(m => m.Event)
                .FirstOrDefault(m => m.Id == memberId);

            return memberWithEvents;
        }
    }
}
