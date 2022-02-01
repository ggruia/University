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
    public class CommiteesController : ControllerBase
    {
        private readonly ICommiteesManager _manager;
        public CommiteesController(ICommiteesManager man)
        {
            _manager = man;
        }

        [HttpGet("all")]
        [Authorize(Policy = "Basic")]
        public async Task<IActionResult> GetAllCommitees()
        {
            var commitees = await _manager.GetAllCommitees();

            return Ok(commitees);
        }

        [HttpGet("{name}/all")]
        [Authorize(Policy = "Basic")]
        public async Task<IActionResult> GetAllCommiteesOfAssociation([FromRoute] string name)
        {
            var commitees = await _manager.GetAllCommiteesOfAssociation(name);

            return Ok(commitees);
        }

        [HttpGet("{id}")]
        [Authorize(Policy = "Basic")]
        public async Task<IActionResult> GetCommiteeById([FromRoute] string id)
        {
            var commitees = await _manager.GetCommiteeById(id);

            return Ok(commitees);
        }

        [HttpPost]
        [Authorize(Policy = "Elevated")]
        public async Task<IActionResult> AddNewCommitee([FromBody] CommiteeCreationModel model)
        {
            await _manager.Create(model);

            return Ok();
        }

        [HttpPut]
        [Authorize(Policy = "Elevated")]
        public async Task<IActionResult> UpdateCommitee([FromBody] CommiteeUpdateModel model)
        {
            await _manager.Update(model);

            return Ok();
        }

        [HttpDelete]
        [Authorize(Policy = "Elevated")]
        public async Task<IActionResult> DeleteCommitee([FromBody] string id)
        {
            await _manager.Delete(id);

            return Ok();
        }
    }
}
