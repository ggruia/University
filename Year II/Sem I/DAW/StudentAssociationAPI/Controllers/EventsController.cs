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
    public class EventsController : ControllerBase
    {
        private readonly IEventsManager _manager;
        public EventsController(IEventsManager man)
        {
            _manager = man;
        }

        [HttpGet("all")]
        [Authorize(Policy = "Basic")]
        public async Task<IActionResult> GetAllEvents()
        {
            var events = await _manager.GetAllEvents();

            return Ok(events);
        }

        [HttpGet("{id}")]
        [Authorize(Policy = "Basic")]
        public async Task<IActionResult> GetEventById([FromRoute] string id)
        {
            var members = await _manager.GetEventById(id);

            return Ok(members);
        }

        [HttpPost]
        [Authorize(Policy = "Elevated")]
        public async Task<IActionResult> AddNewEvent([FromBody] EventCreationModel model)
        {
            await _manager.Create(model);

            return Ok();
        }

        [HttpPut]
        [Authorize(Policy = "Elevated")]
        public async Task<IActionResult> UpdateEvent([FromBody] EventUpdateModel model)
        {
            await _manager.Update(model);

            return Ok();
        }

        [HttpDelete]
        [Authorize(Policy = "Elevated")]
        public async Task<IActionResult> DeleteEvent([FromBody] string id)
        {
            await _manager.Delete(id);

            return Ok();
        }
    }
}
