using Microsoft.AspNetCore.Identity;
using StudentAssociationAPI.Entities;
using StudentAssociationAPI.Interfaces.IManagers;
using StudentAssociationAPI.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StudentAssociationAPI.Managers
{
    public class AuthenticationsManager : IAuthenticationsManager
    {
        private readonly UserManager<User> _userManager;
        private readonly SignInManager<User> _signinManager;
        private readonly ITokenManager _tokenManager;
        private readonly IMembersManager _membersManager;

        public AuthenticationsManager(UserManager<User> uman, SignInManager<User> siman, ITokenManager tknman, IMembersManager meman)
        {
            _userManager = uman;
            _signinManager = siman;
            _tokenManager = tknman;
            _membersManager = meman;
        }


        public User CreateUserFromModel(UserRegisterModel model)
        {
            var user = new User
            {
                UserName = model.Username,
                Email = model.Email
            };
            return user;
        }

        public async Task<int> Validate(UserRegisterModel model)
        {
            if (await _userManager.FindByNameAsync(model.Username) != null)
                return 601;

            if (await _userManager.FindByEmailAsync(model.Email) != null)
                return 602;

            if (model.Password != model.VerifiedPassword)
                return 603;

            if ((model.Password).Length < 6)
                return 604;

            return 0;
        }

        public async Task<string> RegisterUser(UserRegisterModel model)
        {
            var code = await Validate(model);
            if (code != 0)
                return code switch
                {
                    601 => "Username already in-use by another member!",
                    602 => "Email already in-use by another member!",
                    603 => "Passwords do not match!",
                    604 => "Password is too short!",
                    _ => "How ?!"
                };

            var user = CreateUserFromModel(model);

            var result = await _userManager.CreateAsync(user, model.Password);
            if(result.Succeeded)
            {
                await _userManager.AddToRoleAsync(user, "User");

                var memodel = new MemberModel(user);

                await _membersManager.Create(memodel);
            }

            return "OK";
        }

        public async Task<string> RegisterAdmin(UserRegisterModel model)
        {
            var code = await Validate(model);
            if (code != 0)
                return code switch
                {
                    601 => "Username already in-use by another member!",
                    602 => "Email already in-use by another member!",
                    603 => "Passwords do not match!",
                    604 => "Password is too short!",
                    _ => "How ?!"
                };

            var admin = CreateUserFromModel(model);

            var result = await _userManager.CreateAsync(admin, model.Password);
            if (result.Succeeded)
            {
                await _userManager.AddToRoleAsync(admin, "Admin");

                var memodel = new MemberModel(admin);

                await _membersManager.Create(memodel);
            }

            return "OK";
        }

        public async Task<TokenModel> Login(UserLoginModel model)
        {
            var userByName = await _userManager.FindByNameAsync(model.Username);
            var userByEmail = await _userManager.FindByEmailAsync(model.Username);

            if (userByName != null)
            {
                var user = userByName;
                var result = await _signinManager.CheckPasswordSignInAsync(user, model.Password, false);

                if (result.Succeeded)
                {
                    var token = await _tokenManager.GenerateToken(user);

                    return new TokenModel {
                        Token = token,
                        UserId = user.Id,
                        Role = (await _userManager.GetRolesAsync(user)).First()
                    };
                }
            }
            else if (userByEmail != null)
            {
                var user = userByEmail;
                var result = await _signinManager.CheckPasswordSignInAsync(user, model.Password, false);

                if (result.Succeeded)
                {
                    var token = await _tokenManager.GenerateToken(user);

                    return new TokenModel
                    {
                        Token = token,
                        UserId = user.Id,
                        Role = (await _userManager.GetRolesAsync(user)).First()
                    };
                }
            }

            return new TokenModel
            {
                Token = "FAILED",
                UserId = null,
                Role = "Anonymous"
            };
        }
    }
}
