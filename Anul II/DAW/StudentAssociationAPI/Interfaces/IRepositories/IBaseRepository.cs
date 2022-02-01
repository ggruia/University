using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StudentAssociationAPI.Interfaces.IRepositories
{
    public interface IBaseRepository<TEntity> where TEntity : class
    {
        // Read
        Task<List<TEntity>> GetAll();
        Task<TEntity> GetById(object id);

        // Create
        Task Insert(TEntity newEntry);

        // Update
        Task Update(TEntity targetEntry);

        // Delete
        Task Delete(TEntity targetEntry);
        Task DeleteById(object id);
        
        // Save
        Task Save();
    }
}
