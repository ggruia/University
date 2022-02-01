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
    public class CommiteesManager : ICommiteesManager
    {
        private readonly ICommiteesRepository _repository;

        public CommiteesManager(ICommiteesRepository repo)
        {
            _repository = repo;
        }

        public async Task Create(CommiteeCreationModel model)
        {
            var commitee = new Commitee(model);

            await _repository.Insert(commitee);

            await _repository.Save();
        }

        public async Task Delete(string id)
        {
            await _repository.DeleteById(id);

            await _repository.Save();
        }

        public async Task<List<CommiteeModel>> GetAllCommitees()
        {
            var commitees = (await _repository.GetAll()).Select(x => new CommiteeModel(x)).ToList();

            return commitees;
        }

        public async Task<List<CommiteeModel>> GetAllCommiteesOfAssociation(string id)
        {
            var commitees = (await _repository.GetAllCommiteesOfAssociation(id)).Select(x => new CommiteeModel(x)).ToList();

            return commitees;
        }

        public async Task<CommiteeModel> GetCommiteeById(string id)
        {
            var commitee = new CommiteeModel(await _repository.GetById(id));

            return commitee;
        }

        public async Task<Commitee> GetCommiteeObjById(string id)
        {
            return await _repository.GetById(id);
        }

        public async Task Update(CommiteeUpdateModel model)
        {
            var commitee = await GetCommiteeObjById(model.Id);
            if (commitee != null)
            {
                commitee.Name = model.Name;
                commitee.Description = model.Description;

                await _repository.Update(commitee);
                await _repository.Save();
            }
        }
    }
}
