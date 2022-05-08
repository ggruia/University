using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using StudentAssociationAPI.Data;
using StudentAssociationAPI.Entities;
using StudentAssociationAPI.Interfaces.IManagers;
using StudentAssociationAPI.Interfaces.IRepositories;
using StudentAssociationAPI.Managers;
using StudentAssociationAPI.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace StudentAssociationAPI
{
    public class Startup
    {
        public IConfiguration Configuration { get; }
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }
        

        public void ConfigureServices(IServiceCollection services)
        {
            // Controllers and reference loops
            services.AddControllers();
            services.AddControllersWithViews()
                    .AddNewtonsoftJson(options => options.SerializerSettings.ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore);

            // SwaggerAPI
            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc("v1", new OpenApiInfo { Title = "StudentAssociationAPI", Version = "v1" });

                c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
                {
                    Description = @"JWT Authorization header using the Bearer scheme. \r\n\r\n 
                      Enter 'Bearer' [space] and then your token in the text input below.
                      \r\n\r\nExample: 'Bearer 12345abcdef'",
                    Name = "Authorization",
                    In = ParameterLocation.Header,
                    Type = SecuritySchemeType.ApiKey,
                    Scheme = "Bearer"
                });

                c.AddSecurityRequirement(new OpenApiSecurityRequirement
                {
                    {
                        new OpenApiSecurityScheme
                        {
                            Reference = new OpenApiReference
                            {
                                Type = ReferenceType.SecurityScheme,
                                Id = "Bearer"
                            },
                            Scheme = "oauth2",
                            Name = "Bearer",
                            In = ParameterLocation.Header
                        },
                        new List<string>()
                    }
                });
            });

            services.AddDbContext<Context> (options =>
                options
                    .UseLoggerFactory(LoggerFactory.Create(builder => builder.AddConsole()))
                    .UseSqlServer(Configuration.GetConnectionString("ConnString")));


            services.AddIdentity<User, Role> (o =>
            {
               o.Password.RequireDigit = false;
               o.Password.RequireLowercase = false;
               o.Password.RequireUppercase = false;
               o.Password.RequireNonAlphanumeric = false;
               o.Password.RequiredLength = 6;
            })
            .AddEntityFrameworkStores<Context>();

            services.AddAuthentication(options =>
            {

                    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
            })
            .AddJwtBearer("AuthScheme", options =>
            {
                var secret = Configuration.GetSection("Jwt").GetSection("SecretKey").Get<string>();

                options.SaveToken = true;
                options.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuerSigningKey = true,
                    ValidateLifetime = true,
                    RequireExpirationTime = true,
                    IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secret)),
                    ValidateIssuer = false,
                    ValidateAudience = false,
                    ClockSkew = TimeSpan.Zero
                };
            });

            services.AddAuthorization(opt =>
            {
                opt.AddPolicy("Basic", policy => policy.RequireRole("User", "Admin").RequireAuthenticatedUser().AddAuthenticationSchemes("AuthScheme").Build());
                opt.AddPolicy("Elevated", policy => policy.RequireRole("Admin").RequireAuthenticatedUser().AddAuthenticationSchemes("AuthScheme").Build());
                opt.AddPolicy("Admin", policy => policy.RequireRole("Admin").RequireAuthenticatedUser().AddAuthenticationSchemes("AuthScheme").Build());
            });

            services.AddCors(o => o.AddPolicy("SamplePolicy", builder =>
            {
                builder.WithOrigins("http://localhost:4200")
                    .AllowAnyMethod()
                    .AllowAnyHeader();
            }));


            services
            // Authentication Controller
                .AddScoped<IAuthenticationsManager, AuthenticationsManager>()
                .AddScoped<ITokenManager, TokenManager>()
            // Members Controller
                .AddScoped<IMembersRepository, MembersRepository>()
                .AddScoped<IMembersManager, MembersManager>()
            // Events Controller
                .AddScoped<IEventsRepository, EventsRepository>()
                .AddScoped<IEventsManager, EventsManager>()
            // EventRegistrations Controller
                .AddScoped<IEventRegistrationsRepository, EventRegistrationsRepository>()
                .AddScoped<IEventRegistrationsManager, EventRegistrationsManager>()
            // Associations Controller
                .AddScoped<IAssociationsRepository, AssociationsRepository>()
                .AddScoped<IAssociationsManager, AssociationsManager>()
            // Commitees Controller
                .AddScoped<ICommiteesRepository, CommiteesRepository>()
                .AddScoped<ICommiteesManager, CommiteesManager>();
        }


        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
                app.UseSwagger();
                app.UseSwaggerUI(c => c.SwaggerEndpoint("/swagger/v1/swagger.json", "StudentAssociationAPI v1"));
            }

            app.UseCors("SamplePolicy");

            app.UseHttpsRedirection();

            app.UseRouting();

            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}
