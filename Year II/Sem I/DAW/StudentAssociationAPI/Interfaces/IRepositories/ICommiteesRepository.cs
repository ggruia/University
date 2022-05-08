using StudentAssociationAPI.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StudentAssociationAPI.Interfaces.IRepositories
{
    public interface ICommiteesRepository: IBaseRepository<Commitee>
    {
        Task<List<Commitee>> GetAllCommiteesOfAssociation(string id);
    }
}
