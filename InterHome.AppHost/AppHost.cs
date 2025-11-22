var builder = DistributedApplication.CreateBuilder(args);

builder.AddProject<Projects.InterHome>("interhome");

builder.Build().Run();
