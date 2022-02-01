using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using StudentAssociationAPI.Entities;
using StudentAssociationAPI.Interfaces.IManagers;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace StudentAssociationAPI.Managers
{
    public class TokenManager : ITokenManager
    {
        private readonly IConfiguration _config;
        private readonly UserManager<User> _userManager;

        public TokenManager(IConfiguration cfg, UserManager<User> usrman)
        {
            _config = cfg;
            _userManager = usrman;
        }
        public async Task<string> GenerateToken(User user)
        {
            // fetches the SecreKey as <string> from appsettings.json
            var secretKey = _config.GetSection("Jwt").GetSection("SecretKey").Get<string>();

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secretKey));
            var credentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha512Signature);


            var roles = await _userManager.GetRolesAsync(user);
            var claims = new List<Claim>();
            foreach(var role in roles)
            {
                claims.Add(new Claim(ClaimTypes.Role, role));
            }

            var tokenDescription = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(claims),
                Expires = DateTime.Now.AddHours(6),
                SigningCredentials = credentials
            };

            var tokenHandler = new JwtSecurityTokenHandler();
            var token = tokenHandler.CreateToken(tokenDescription);

            return tokenHandler.WriteToken(token);
        }
    }
}
