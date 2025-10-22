using System;
using System.Collections.Generic;
using LinqDemo;

namespace linqdemo
{
    class Program
    {
        static void Main(string[] args)
        {
            var users = new List<User>
            {
                new User { Id = 1, Name = "Alice", LastName = "Smith", Age = 25, RoleId = 1 },
                new User { Id = 2, Name = "Bob", LastName = "Jones", Age = 17, RoleId = 2 },
                new User { Id = 3, Name = "Charlie", LastName = "Brown", Age = 35, RoleId = 1 },
                new User { Id = 4, Name = "Diana", LastName = "Prince", Age = 30, RoleId = 3 }
            };

            var roles = new List<Role>
            {
                new Role { Id = 1, RoleName = "Admin" },
                new Role { Id = 2, RoleName = "User" },
                new Role { Id = 3, RoleName = "Guest" }
            };

            // Filtering
            var adults = users.Where(u => u.Age >= 18);
            Console.WriteLine("LINQ Where Example: ");
            foreach (var adult in adults)
            {
                Console.WriteLine($"{adult.Name} {adult.LastName} is an adult.");
            }
            // Projection
            var names = users.Select(u => u.Name);
            Console.WriteLine("LINQ Select Example: ");
            foreach (var name in names)
            {
                Console.WriteLine(name);
            }

            // Ordering
            var sortedUsers = users.OrderBy(u => u.LastName).ThenBy(u => u.Name);

            // Grouping
            var groupedByAge = users.GroupBy(u => u.Age);

            // Joining
            var userRoles = users.Join(
                roles,
                user => user.RoleId,
                role => role.Id,
                (user, role) => new { user.Name, role.RoleName }
            );

            Console.WriteLine("LINQ Join Example: ");
            foreach (var ur in userRoles)
            {
                Console.WriteLine($"{ur.Name} has role {ur.RoleName}");
            }

            // Aggregation
            var totalAge = users.Sum(u => u.Age);
            var averageAge = users.Average(u => u.Age);
            var count = users.Count();

            // Any / All
            bool hasTeenagers = users.Any(u => u.Age >= 13 && u.Age <= 19);
            bool allAdults = users.All(u => u.Age >= 18);

            // Distinct
            var uniqueAges = users.Select(u => u.Age).Distinct();

            // Pagination
            var pageSize = 2;
            var pageNumber = 1;
            var pageData = users.Skip((pageNumber - 1) * pageSize).Take(pageSize);

            // ToDictionary
            var userDict = users.ToDictionary(u => u.Id, u => u.Name);
        }
    }
}