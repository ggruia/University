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
    public class AssociationsController : ControllerBase
    {
        private readonly IAssociationsManager _manager;
        public AssociationsController(IAssociationsManager man)
        {
            _manager = man;
        }

        [HttpGet("all")]
        [Authorize(Policy = "Basic")]
        public async Task<IActionResult> GetAllAssociations()
        {
            var members = await _manager.GetAllAssociations();

            return Ok(members);
        }

        [HttpGet("{id}")]
        [Authorize(Policy = "Basic")]
        public async Task<IActionResult> GetAssociationByName([FromRoute] string id)
        {
            var members = await _manager.GetAssociationById(id);

            return Ok(members);
        }

        [HttpPost]
        [Authorize(Policy = "Elevated")]
        public async Task<IActionResult> AddNewAssociation([FromBody] AssociationModel model)
        {
            await _manager.Create(model);

            return Ok();
        }

        [HttpDelete("{id}")]
        [Authorize(Policy = "Elevated")]
        public async Task<IActionResult> DeleteAssociation([FromRoute] string id)
        {
            await _manager.Delete(id);

            return Ok();
        }
    }
}
