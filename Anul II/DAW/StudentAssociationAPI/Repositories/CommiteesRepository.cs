using StudentAssociationAPI.Data;
using StudentAssociationAPI.Entities;
using StudentAssociationAPI.Interfaces.IRepositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StudentAssociationAPI.Repositories
{
    public class CommiteesRepository : BaseRepository<Commitee>, ICommiteesRepository
    {
        // inject Context into Repository
        public CommiteesRepository(Context context) : base(context) { }

        public async Task<List<Commitee>> GetAllCommiteesOfAssociation(string id)
        {
            var commitees = (await GetAll())
                .Where(x => x.AssociationId == id)
                .ToList();

            return commitees;
        }
    }
}
