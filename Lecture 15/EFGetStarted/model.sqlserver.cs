using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;

public class Blog
{
    public int BlogId { get; set; }
    public string Url { get; set; }

    public List<Post> Posts { get; } = new();
}

   public class Post
    {
        public int PostId { get; set; }
        public string Title { get; set; }
        public string Content { get; set; }

        public int BlogId { get; set; }
        public Blog Blog { get; set; }
    } 
public class SqlBloggingContext : DbContext
{
    public DbSet<Blog> Blogs { get; set; }
    public DbSet<Post> Posts { get; set; }

    public string DbPath { get; }

    protected override void OnConfiguring(DbContextOptionsBuilder options)
        => options.UseSqlServer("Data Source=localhost;Initial Catalog=Blogging;User ID=sa;Password=YourStrongPassword123;Connect Timeout=30;Encrypt=False;TrustServerCertificate=True");
}

