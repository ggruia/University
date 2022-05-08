using StudentAssociationAPI.Data;
using StudentAssociationAPI.Entities;
using StudentAssociationAPI.Interfaces.IRepositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StudentAssociationAPI.Repositories
{
    public class EventRegistrationsRepository : BaseRepository<EventRegistration>, IEventRegistrationsRepository
    {
        // inject Context into Repository
        public EventRegistrationsRepository(Context context) : base(context) { }
    }
}
