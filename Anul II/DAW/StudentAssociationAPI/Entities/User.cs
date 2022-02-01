using Microsoft.AspNetCore.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StudentAssociationAPI.Entities
{
    public class User : IdentityUser
    {
        public virtual Member Member { get; set; }
    }
}
