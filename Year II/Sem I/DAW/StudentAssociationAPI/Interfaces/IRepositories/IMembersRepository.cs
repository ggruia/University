using StudentAssociationAPI.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StudentAssociationAPI.Interfaces.IRepositories
{
    public interface IMembersRepository : IBaseRepository<Member>
    {
        Member GetAllAssociationsOfMember(string memberId);

        Member GetAllEventsOfMember(string memberId);
    }
}
