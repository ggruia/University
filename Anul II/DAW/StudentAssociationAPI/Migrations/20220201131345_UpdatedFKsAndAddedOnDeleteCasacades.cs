using Microsoft.EntityFrameworkCore.Migrations;

namespace StudentAssociationAPI.Migrations
{
    public partial class FixedFKs : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Applications_Associations_AssociationName",
                table: "Applications");

            migrationBuilder.DropForeignKey(
                name: "FK_AssociationMemberships_Associations_AssociationName",
                table: "AssociationMemberships");

            migrationBuilder.DropForeignKey(
                name: "FK_BoardMemberships_Associations_AssociationName",
                table: "BoardMemberships");

            migrationBuilder.DropForeignKey(
                name: "FK_Commitees_Associations_AssociationName",
                table: "Commitees");

            migrationBuilder.DropPrimaryKey(
                name: "PK_Associations",
                table: "Associations");

            migrationBuilder.RenameColumn(
                name: "Name",
                table: "Members",
                newName: "LastName");

            migrationBuilder.RenameColumn(
                name: "AssociationName",
                table: "Commitees",
                newName: "AssociationId");

            migrationBuilder.RenameIndex(
                name: "IX_Commitees_AssociationName",
                table: "Commitees",
                newName: "IX_Commitees_AssociationId");

            migrationBuilder.RenameColumn(
                name: "AssociationName",
                table: "BoardMemberships",
                newName: "AssociationId");

            migrationBuilder.RenameIndex(
                name: "IX_BoardMemberships_AssociationName",
                table: "BoardMemberships",
                newName: "IX_BoardMemberships_AssociationId");

            migrationBuilder.RenameColumn(
                name: "AssociationName",
                table: "AssociationMemberships",
                newName: "AssociationId");

            migrationBuilder.RenameIndex(
                name: "IX_AssociationMemberships_AssociationName",
                table: "AssociationMemberships",
                newName: "IX_AssociationMemberships_AssociationId");

            migrationBuilder.RenameColumn(
                name: "AssociationName",
                table: "Applications",
                newName: "AssociationId");

            migrationBuilder.RenameIndex(
                name: "IX_Applications_AssociationName",
                table: "Applications",
                newName: "IX_Applications_AssociationId");

            migrationBuilder.AddColumn<string>(
                name: "FirstName",
                table: "Members",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "Name",
                table: "Associations",
                type: "nvarchar(max)",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(450)");

            migrationBuilder.AddColumn<string>(
                name: "Id",
                table: "Associations",
                type: "nvarchar(450)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddPrimaryKey(
                name: "PK_Associations",
                table: "Associations",
                column: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Applications_Associations_AssociationId",
                table: "Applications",
                column: "AssociationId",
                principalTable: "Associations",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_AssociationMemberships_Associations_AssociationId",
                table: "AssociationMemberships",
                column: "AssociationId",
                principalTable: "Associations",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_BoardMemberships_Associations_AssociationId",
                table: "BoardMemberships",
                column: "AssociationId",
                principalTable: "Associations",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Commitees_Associations_AssociationId",
                table: "Commitees",
                column: "AssociationId",
                principalTable: "Associations",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Applications_Associations_AssociationId",
                table: "Applications");

            migrationBuilder.DropForeignKey(
                name: "FK_AssociationMemberships_Associations_AssociationId",
                table: "AssociationMemberships");

            migrationBuilder.DropForeignKey(
                name: "FK_BoardMemberships_Associations_AssociationId",
                table: "BoardMemberships");

            migrationBuilder.DropForeignKey(
                name: "FK_Commitees_Associations_AssociationId",
                table: "Commitees");

            migrationBuilder.DropPrimaryKey(
                name: "PK_Associations",
                table: "Associations");

            migrationBuilder.DropColumn(
                name: "FirstName",
                table: "Members");

            migrationBuilder.DropColumn(
                name: "Id",
                table: "Associations");

            migrationBuilder.RenameColumn(
                name: "LastName",
                table: "Members",
                newName: "Name");

            migrationBuilder.RenameColumn(
                name: "AssociationId",
                table: "Commitees",
                newName: "AssociationName");

            migrationBuilder.RenameIndex(
                name: "IX_Commitees_AssociationId",
                table: "Commitees",
                newName: "IX_Commitees_AssociationName");

            migrationBuilder.RenameColumn(
                name: "AssociationId",
                table: "BoardMemberships",
                newName: "AssociationName");

            migrationBuilder.RenameIndex(
                name: "IX_BoardMemberships_AssociationId",
                table: "BoardMemberships",
                newName: "IX_BoardMemberships_AssociationName");

            migrationBuilder.RenameColumn(
                name: "AssociationId",
                table: "AssociationMemberships",
                newName: "AssociationName");

            migrationBuilder.RenameIndex(
                name: "IX_AssociationMemberships_AssociationId",
                table: "AssociationMemberships",
                newName: "IX_AssociationMemberships_AssociationName");

            migrationBuilder.RenameColumn(
                name: "AssociationId",
                table: "Applications",
                newName: "AssociationName");

            migrationBuilder.RenameIndex(
                name: "IX_Applications_AssociationId",
                table: "Applications",
                newName: "IX_Applications_AssociationName");

            migrationBuilder.AlterColumn<string>(
                name: "Name",
                table: "Associations",
                type: "nvarchar(450)",
                nullable: false,
                defaultValue: "",
                oldClrType: typeof(string),
                oldType: "nvarchar(max)",
                oldNullable: true);

            migrationBuilder.AddPrimaryKey(
                name: "PK_Associations",
                table: "Associations",
                column: "Name");

            migrationBuilder.AddForeignKey(
                name: "FK_Applications_Associations_AssociationName",
                table: "Applications",
                column: "AssociationName",
                principalTable: "Associations",
                principalColumn: "Name",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_AssociationMemberships_Associations_AssociationName",
                table: "AssociationMemberships",
                column: "AssociationName",
                principalTable: "Associations",
                principalColumn: "Name",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_BoardMemberships_Associations_AssociationName",
                table: "BoardMemberships",
                column: "AssociationName",
                principalTable: "Associations",
                principalColumn: "Name",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Commitees_Associations_AssociationName",
                table: "Commitees",
                column: "AssociationName",
                principalTable: "Associations",
                principalColumn: "Name",
                onDelete: ReferentialAction.Restrict);
        }
    }
}
