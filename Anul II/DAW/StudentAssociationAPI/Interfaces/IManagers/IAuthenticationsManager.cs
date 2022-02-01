using StudentAssociationAPI.Entities;
using StudentAssociationAPI.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StudentAssociationAPI.Interfaces.IManagers
{
    public interface IAuthenticationsManager
    {
        User CreateUserFromModel(UserRegisterModel model);
        Task<int> Validate(UserRegisterModel model);
        Task<string> RegisterUser(UserRegisterModel model);
        Task<string> RegisterAdmin(UserRegisterModel model);
        Task<TokenModel> Login(UserLoginModel model);
    }
}
