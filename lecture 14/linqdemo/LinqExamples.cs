
using System;
using System.Collections.Generic;
using System.Linq;

namespace LinqDemo
{
    public class User
    {
        public int Id { get; set; }
        public required string Name { get; set; }
        public required string LastName { get; set; }
        public int Age { get; set; }
        public int RoleId { get; set; }
    }

    public class Role
    {
        public int Id { get; set; }
        public required string RoleName { get; set; }
    }

    
}
