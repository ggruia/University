using StudentAssociationAPI.Entities;
using StudentAssociationAPI.Interfaces.IRepositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StudentAssociationAPI.Interfaces.IRepositories
{
    public interface IEventRegistrationsRepository : IBaseRepository<EventRegistration>
    {
    }
}
