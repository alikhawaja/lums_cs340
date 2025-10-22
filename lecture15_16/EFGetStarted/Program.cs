using System;
using System.Linq;


public class Program
{
    static void Main(string[] args)
    {
        var db = new SqlBloggingContext();
        while (true)
        {
            DisplayMenu();
            var choice = Console.ReadLine();

            switch (choice)
            {
                case "1":
                    CreateBlog(db);
                    break;

                case "2":
                    Console.WriteLine("Blog posts:");
                    var posts = db.Blogs.SelectMany(b => b.Posts).ToList();
                    foreach (var post in posts)
                    {
                        Console.WriteLine($"{post.Title}: {post.Content}");
                    }
                    break;

                case "3":
                    var blogs = db.Blogs.ToList();
                    if (blogs.Any())
                    {
                        Console.WriteLine("Available blogs:");
                        for (int i = 0; i < blogs.Count; i++)
                        {
                            Console.WriteLine($"{i + 1}. {blogs[i].Url}");
                        }
                        Console.Write("Select blog number to update: ");
                        if (int.TryParse(Console.ReadLine(), out int blogIndex) && blogIndex > 0 && blogIndex <= blogs.Count)
                        {
                            var selectedBlog = blogs[blogIndex - 1];
                            Console.Write("Enter new URL: ");
                            var newUrl = Console.ReadLine();
                            selectedBlog.Url = newUrl;
                            db.SaveChanges();
                            Console.WriteLine("Blog updated successfully!");
                        }
                        else
                        {
                            Console.WriteLine("Invalid selection.");
                        }
                    }
                    else
                    {
                        Console.WriteLine("No blogs available to update.");
                    }
                    break;

                case "4":
                    return;

                default:
                    Console.WriteLine("Invalid choice. Please try again.");
                    break;
            }
        }
    }

    static void DisplayMenu()
    {
        Console.WriteLine("Menu:");
        Console.WriteLine("1. Create a new blog");
        Console.WriteLine("2. Query blog posts");
        Console.WriteLine("3. Update a blog post");
        Console.WriteLine("4. Exit");
        Console.Write("Enter your choice: ");
    }

    static void CreateBlog(SqlBloggingContext db)
    {
        Console.Write("Enter blog URL: ");
        var url = Console.ReadLine();
        db.Add(new Blog { Url = url });
        db.SaveChanges();
        Console.WriteLine("Blog created successfully!");
    }
}


