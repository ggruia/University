using StudentAssociationAPI.Entities;
using StudentAssociationAPI.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StudentAssociationAPI.Interfaces.IManagers
{
    public interface ICommiteesManager
    {
        Task<List<CommiteeModel>> GetAllCommitees();
        Task<List<CommiteeModel>> GetAllCommiteesOfAssociation(string id);
        Task<CommiteeModel> GetCommiteeById(string id);
        Task<Commitee> GetCommiteeObjById(string id);
        Task Create(CommiteeCreationModel model);
        Task Update(CommiteeUpdateModel model);
        Task Delete(string id);
    }
}
