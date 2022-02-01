using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StudentAssociationAPI.Models
{
    public class TokenModel
    {
        public string Token { get; set; }
        public string UserId { get; set; }
        public string Role { get; set; }
    }
}
