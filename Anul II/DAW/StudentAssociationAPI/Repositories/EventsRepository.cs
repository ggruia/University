using StudentAssociationAPI.Data;
using StudentAssociationAPI.Entities;
using StudentAssociationAPI.Interfaces.IRepositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StudentAssociationAPI.Repositories
{
    public class EventsRepository : BaseRepository<Event>, IEventsRepository
    {
        // inject Context into Repository
        public EventsRepository(Context context) : base(context) { }
    }
}
