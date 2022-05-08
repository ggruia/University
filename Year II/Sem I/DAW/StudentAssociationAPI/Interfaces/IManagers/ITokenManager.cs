using StudentAssociationAPI.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StudentAssociationAPI.Interfaces.IManagers
{
    public interface ITokenManager
    {
        Task<string> GenerateToken(User user);
    }
}
