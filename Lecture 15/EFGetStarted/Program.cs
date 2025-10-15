using System;
using System.Linq;


public class Program
{
    static void Main(string[] args)
    {
        var db = new SqlBloggingContext();

        // Create a new blog post
        Console.WriteLine("Inserting a new blog");
        db.Add(new Blog { Url = "http://blogs.msdn.com/adonet" });
        db.SaveChanges();

        // Read
        Console.WriteLine("Querying for a blog");
        var blog = (from b in db.Blogs
                    orderby b.BlogId
                    select b).First();

        // Update
        Console.WriteLine("Updating the blog and adding a post");
        blog.Url = "https://devblogs.microsoft.com/dotnet";
        blog.Posts.Add(
            new Post { Title = "Hello World", Content = "I wrote an app using EF Core!" });
        db.SaveChanges();
    }
}


