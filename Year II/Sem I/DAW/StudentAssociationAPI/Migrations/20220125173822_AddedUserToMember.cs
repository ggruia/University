using Microsoft.EntityFrameworkCore.Migrations;

namespace StudentAssociationAPI.Migrations
{
    public partial class AddedUserOneToOneMember : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddForeignKey(
                name: "FK_Members_AspNetUsers_Id",
                table: "Members",
                column: "Id",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Members_AspNetUsers_Id",
                table: "Members");
        }
    }
}
