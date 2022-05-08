using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using StudentAssociationAPI.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StudentAssociationAPI.Data
{
    public class Context : IdentityDbContext <User, Role, string, IdentityUserClaim<string>, UserRole, IdentityUserLogin<string>, IdentityRoleClaim<string>, IdentityUserToken<string>>
    {
        public Context(DbContextOptions<Context> options) : base(options) { }
        
        public DbSet<Application> Applications { get; set; }
        public DbSet<Association> Associations { get; set; }
        public DbSet<Commitee> Commitees { get; set; }
        public DbSet<Member> Members { get; set; }
        public DbSet<AssociationMembership> AssociationMemberships { get; set; }
        public DbSet<BoardMembership> BoardMemberships { get; set; }
        public DbSet<CommiteeMembership> CommiteeMemberships { get; set; }
        public DbSet<Event> Events { get; set; }
        public DbSet<EventRegistration> EventRegistrations { get; set; }


        protected override void OnModelCreating(ModelBuilder builder)
        {
            // Base
            base.OnModelCreating(builder);


            // Association - PK
            builder.Entity<Association>()
                .HasKey(a => a.Id);


            // Commitee (M) --- (1) Association
            builder.Entity<Commitee>()
                .HasOne(c => c.Association)
                .WithMany(a => a.Commitees)
                .HasForeignKey(c => c.AssociationId)
                .OnDelete(DeleteBehavior.Cascade);


            // Event (M) --- (1) Commitee
            builder.Entity<Event>()
                .HasOne(e => e.Commitee)
                .WithMany(c => c.Events)
                .OnDelete(DeleteBehavior.Cascade);


            // CommiteeMembership (1) --- (1) Member
            builder.Entity<CommiteeMembership>()
                .HasOne(cm => cm.Member)
                .WithOne(m => m.CommiteeMembership)
                .OnDelete(DeleteBehavior.Cascade);

            // CommiteeMembership (M) --- (1) Commitee
            builder.Entity<CommiteeMembership>()
                .HasOne(cm => cm.Commitee)
                .WithMany(c => c.CommiteeMemberships)
                .HasForeignKey(cm => cm.CommiteeId)
                .OnDelete(DeleteBehavior.Cascade);



            // (M) --- (M)
            // BoardMembership (M) --- (1) Association
            builder.Entity<BoardMembership>()
                .HasOne(bm => bm.Association)
                .WithMany(a => a.BoardMemberships)
                .HasForeignKey(bm => bm.AssociationId)
                .OnDelete(DeleteBehavior.Cascade);

            // BoardMembership (M) --- (1) Member
            builder.Entity<BoardMembership>()
                .HasOne(bm => bm.Member)
                .WithMany(m => m.BoardMemberships)
                .HasForeignKey(bm => bm.MemberId)
                .OnDelete(DeleteBehavior.Cascade);



            // (M) --- (M)
            // AssociationMembership (M) --- (1) Association
            builder.Entity<AssociationMembership>()
                .HasOne(am => am.Association)
                .WithMany(a => a.AssociationMemberships)
                .HasForeignKey(am => am.AssociationId)
                .OnDelete(DeleteBehavior.Cascade);

            // AssociationMembership (M) --- (1) Member
            builder.Entity<AssociationMembership>()
                .HasOne(am => am.Member)
                .WithMany(m => m.AssociationMemberships)
                .HasForeignKey(am => am.MemberId)
                .OnDelete(DeleteBehavior.Cascade);



            // (M) --- (M)
            // Application (M) --- (1) Member
            builder.Entity<Application>()
                .HasOne(app => app.Member)
                .WithMany(m => m.Applications)
                .HasForeignKey(app => app.MemberId)
                .OnDelete(DeleteBehavior.Cascade);

            // Application (M) --- (1) Association
            builder.Entity<Application>()
                .HasOne(app => app.Association)
                .WithMany(a => a.Applications)
                .HasForeignKey(app => app.AssociationId)
                .OnDelete(DeleteBehavior.Cascade);



            // (M) --- (M)
            // EventRegistration (M) --- (1) Member
            builder.Entity<EventRegistration>()
                .HasOne(er => er.Member)
                .WithMany(m => m.EventRegistrations)
                .HasForeignKey(er => er.MemberId)
                .OnDelete(DeleteBehavior.Cascade);

            // EventRegistration (M) --- (1) Event
            builder.Entity<EventRegistration>()
                .HasOne(er => er.Event)
                .WithMany(e => e.EventRegistrations)
                .HasForeignKey(er => er.EventId)
                .OnDelete(DeleteBehavior.Cascade);



            // User (1) --- (1) Member
            builder.Entity<User>()
                .HasOne(m => m.Member)
                .WithOne(u => u.User)
                .HasForeignKey<Member>(u => u.Id)
                .OnDelete(DeleteBehavior.Cascade);
        }
    }
}
