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
    public class EventRegistrationsController : ControllerBase
    {
        private readonly IEventRegistrationsManager _manager;
        public EventRegistrationsController(IEventRegistrationsManager man)
        {
            _manager = man;
        }

        [HttpGet("all")]
        [Authorize(Policy = "Basic")]
        public async Task<IActionResult> GetAllEventRegistrations()
        {
            var eventRegistrations = await _manager.GetAllEventRegistrations();

            return Ok(eventRegistrations);
        }

        [HttpGet("{id}")]
        [Authorize(Policy = "Basic")]
        public async Task<IActionResult> GetEventRegistrationById([FromRoute] string id)
        {
            var eventRegistrationById = await _manager.GetEventRegistrationById(id);

            return Ok(eventRegistrationById);
        }

        [HttpPost]
        [Authorize(Policy = "Basic")]
        public async Task<IActionResult> AddNewEventRegistration([FromBody] EventRegistrationModel model)
        {
            await _manager.Create(model);

            return Ok();
        }

        [HttpDelete]
        [Authorize(Policy = "Basic")]
        public async Task<IActionResult> DeleteEventRegistration([FromBody] string id)
        {
            await _manager.Delete(id);

            return Ok();
        }
    }
}
