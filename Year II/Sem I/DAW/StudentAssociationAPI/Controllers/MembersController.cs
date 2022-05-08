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
    public class MembersController : ControllerBase
    {
        private readonly IMembersManager _manager;
        public MembersController(IMembersManager man)
        {
            _manager = man;
        }

        [HttpGet("all")]
        [Authorize(Policy = "Basic")]
        public async Task<IActionResult> GetAllMembers()
        {
            var members = await _manager.GetAllMembers();

            return Ok(members);
        }

        [HttpGet("{id}")]
        [Authorize(Policy = "Basic")]
        public async Task<IActionResult> GetMemberById([FromRoute] string id)
        {
            var members = await _manager.GetMemberById(id);

            return Ok(members);
        }

        [HttpGet("{id}/associations")]
        [Authorize(Policy = "Basic")]
        public IActionResult GetAllAssociationsOfMember([FromRoute] string id)
        {
            var associations = _manager.GetAllAssociationsOfMember(id);

            return Ok(associations);
        }


        [HttpGet("{id}/events")]
        [Authorize(Policy = "Basic")]
        public IActionResult GetAllEventsOfMember([FromRoute] string id)
        {
            var events = _manager.GetAllEventsOfMember(id);

            return Ok(events);
        }

        [HttpGet("{id}/events/excluded")]
        [Authorize(Policy = "Basic")]
        public IActionResult GetAllExcludedEventsOfMember([FromRoute] string id)
        {
            var events = _manager.GetAllExcludedEventsOfMember(id);

            return Ok(events);
        }

        [HttpPost]
        [Authorize(Policy = "Elevated")]
        public async Task<IActionResult> AddNewMember([FromBody] MemberModel model)
        {
            await _manager.Create(model);

            return Ok();
        }

        [HttpPut]
        [Authorize(Policy = "Basic")]
        public async Task<IActionResult> UpdateMember([FromBody] MemberModel model)
        {
            await _manager.Update(model);

            return Ok();
        }

        [HttpDelete]
        [Authorize(Policy = "Elevated")]
        public async Task<IActionResult> DeleteMember([FromBody] string id)
        {
            await _manager.Delete(id);

            return Ok();
        }
    }
}
