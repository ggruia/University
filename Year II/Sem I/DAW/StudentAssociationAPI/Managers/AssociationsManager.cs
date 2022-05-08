using StudentAssociationAPI.Entities;
using StudentAssociationAPI.Interfaces.IManagers;
using StudentAssociationAPI.Interfaces.IRepositories;
using StudentAssociationAPI.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StudentAssociationAPI.Managers
{
    public class AssociationsManager : IAssociationsManager
    {
        private readonly IAssociationsRepository _repository;
        public AssociationsManager(IAssociationsRepository repo)
        {
            _repository = repo;
        }

        public async Task<List<AssociationModel>> GetAllAssociations()
        {
            var associations = (await _repository.GetAll()).Select(x => new AssociationModel(x)).ToList();

            return associations;
        }

        public async Task<AssociationModel> GetAssociationById(string id)
        {
            var association = new AssociationModel(await _repository.GetById(id));

            return association;
        }

        public async Task Create(AssociationModel model)
        {
            var association = new Association(model);

            await _repository.Insert(association);

            await _repository.Save();
        }

        public async Task Delete(string id)
        {
            await _repository.DeleteById(id);

            await _repository.Save();
        }
    }
}
