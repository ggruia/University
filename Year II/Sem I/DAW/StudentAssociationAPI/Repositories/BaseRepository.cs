using StudentAssociationAPI.Data;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using StudentAssociationAPI.Interfaces.IRepositories;

namespace StudentAssociationAPI.Repositories
{
    public class BaseRepository<TEntity> : IBaseRepository<TEntity> where TEntity : class
    {
        protected readonly Context _context;
        protected DbSet<TEntity> _table;

        public BaseRepository(Context data)
        {
            _context = data;
            _table = _context.Set<TEntity>();
        }


        public async Task<List<TEntity>> GetAll()
        {
            return await _table.ToListAsync();
        }
        public async Task<TEntity> GetById(object id)
        {
            return await _table.FindAsync(id);
        }

        public async Task Insert(TEntity newEntry)
        {
            await _table.AddAsync(newEntry);

            await Save();
        }

        public async Task Delete(TEntity targetEntry)
        {
            _table.Remove(targetEntry);

            await Save();
        }
        public async Task DeleteById(object id)
        {
            _table.Remove(await GetById(id));

            await Save();
        }

        public async Task Update(TEntity targetEntry)
        {
            _table.Update(targetEntry);

            await Save();
        }

        public async Task Save()
        {
            await _context.SaveChangesAsync();
        }
    }
}
