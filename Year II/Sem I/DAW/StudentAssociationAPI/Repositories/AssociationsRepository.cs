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
    public class AssociationsRepository : BaseRepository<Association>, IAssociationsRepository
    {
        // inject Context into Repository
        public AssociationsRepository(Context context) : base(context) { }
    }
}
