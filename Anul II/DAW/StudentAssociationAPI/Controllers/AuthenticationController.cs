using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using StudentAssociationAPI.Interfaces.IManagers;
using StudentAssociationAPI.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StudentAssociationAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthenticationController : ControllerBase
    {
        private readonly IAuthenticationsManager _manager;

        public AuthenticationController(IAuthenticationsManager man)
        {
            _manager = man;
        }

        [HttpPost("signup-user")]
        public async Task<IActionResult> SignUpUser([FromBody] UserRegisterModel model)
        {
            var message = await _manager.RegisterUser(model);

            return message == "OK" ?
                Ok($"User '{model.Username}' created SUCCESSFULLY!"):
                BadRequest(message);
        }

        [HttpPost("signup-admin")]
        [Authorize(Policy = "Admin")]
        public async Task<IActionResult> SignUpAdmin([FromBody] UserRegisterModel model)
        {
            var message = await _manager.RegisterAdmin(model);

            return message == "OK"?
                Ok($"Admin '{model.Username}' created SUCCESSFULLY!"):
                BadRequest(message);
        }

        [HttpPost("login")]
        public async Task<IActionResult> LogIn([FromBody] UserLoginModel model)
        {
            var token = await _manager.Login(model);

            return token.Token == "FAILED"?
                BadRequest("Username or password do not match!\n\nLogin FAILED!"):
                Ok(token);
        }
    }
}
