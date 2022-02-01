using StudentAssociationAPI.Entities;
using StudentAssociationAPI.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StudentAssociationAPI.Interfaces.IManagers
{
    public interface IAssociationsManager
    {
        Task<List<AssociationModel>> GetAllAssociations();
        Task<AssociationModel> GetAssociationById(string id);
        Task Create(AssociationModel model);
        Task Delete(string id);
    }
}
