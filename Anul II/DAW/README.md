# Student Association

Web Application that implements the flow of operations behind a University Forum, developed using **ASP.NET** and **Angular**.

An Association comprises 3 main components:
- Board
- Commitees
- Members
each with their own policies and roles.
Each Commitee can create and alter Events, that every Member of that 


## Implementation

- Back-end:
  - **REST API**, complying with the *repository pattern*
  - Built a *Code-First Database* and managed it using **ASP.NET Core Entity Framework** and **LINQ** methods
  - User Authentication using **ASP.NET Core Identity** and **JSON Web Tokens (JWT)**
  - Used *.NET Interfaces* and *Models* to facilitate the data flow between back-end and front-end
  - [Source code](https://github.com/ggruia/University-Projects/tree/main/Anul%20II/DAW/StudentAssociationAPI)
- Front-end:
  - UI implemented with Angular **Material Module**, **Theming** and SCSS
  - Managed the data transfer to-and-from the database with Angular **Services**, **Directives** and **Pipes**
  - Secured user-access using **Guards**
