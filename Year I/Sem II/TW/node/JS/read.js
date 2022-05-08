// script pentru a afisa JOCURILE din baza de date

/* POST TEMPLATE:

<div class="game_description">
    <div class="image_container">
        <img src=${post.img} class="game_img">
        <div class="overlay">
            <div class="overlay_text">${post.name}</div>
        </div>
    </div>
    <p>> ${post.description}</p>
    <div class="game_footer">
        <a class="info_download" href=${post.link}>More info and download..</a>
        <div class="edit_delete">
            <button class="edit"><img src="/Images/edit_img.png"></button>
            <button class="delete"><img src="/Images/delete_img.png"></button>
        </div>
    </div>
</div> */


const container = document.querySelector('.games_info');

function renderGames() {
    fetch ('http://localhost:3000/games', {
        method: 'get'
    }).then(function(response) {
        response.json().then(function(posts) {
            posts.forEach(function(post) {

                let game_description = document.createElement("div");
                game_description.className = "game_description";

                let image_container = document.createElement("div");
                image_container.className = "image_container";

                let game_img = document.createElement("img");
                game_img.className = "game_img";
                game_img.setAttribute("src", post.img);

                let overlay = document.createElement("div");
                overlay.className = "overlay";

                let overlay_text = document.createElement("div");
                overlay_text.className = "overlay_text";
                overlay_text.innerText = post.name;

                overlay.appendChild(overlay_text);
                image_container.appendChild(game_img);
                image_container.appendChild(overlay);

                let post_description = document.createElement("p");
                post_description.innerText = post.description;

                let game_footer = document.createElement("div");
                game_footer.className = "game_footer";

                let info_download = document.createElement("a");
                info_download.className = "info_download";
                info_download.setAttribute("href", post.link)
                info_download.innerText = "‏‏‎More info and download..";

                let edit_delete = document.createElement("div");
                edit_delete.className = "edit_delete";


                let edit_button = document.createElement("div");
                edit_button.className = "edit";
                edit_button.onclick = function(){
                    editPost(post.id);
                };

                let edit_img = document.createElement("img");
                edit_img.setAttribute("src", "../Images/edit_img.png")

                edit_button.appendChild(edit_img);


                let delete_button = document.createElement("div");
                delete_button.className = "delete";
                delete_button.onclick = function(){
                    deletePost(post.id);
                };

                let delete_img = document.createElement("img");
                delete_img.setAttribute("src", "../Images/delete_img.png")

                delete_button.appendChild(delete_img);


                edit_delete.appendChild(edit_button);
                edit_delete.appendChild(delete_button);

                game_footer.appendChild(info_download);
                game_footer.appendChild(edit_delete);

                game_description.appendChild(image_container);
                game_description.appendChild(post_description);
                game_description.appendChild(game_footer);

                container.appendChild(game_description);
            });
        })
    })
}

window.addEventListener('DOMContentLoaded', renderGames);


const collapsible = document.querySelector(".collapsible_button");
collapsible.addEventListener("click", function() {

    collapsible.classList.toggle("collapsible_active");

    const content = collapsible.nextElementSibling;

    if (content.style.maxWidth) {
        content.style.display = "none";
        content.style.maxWidth = null;
    }
    else {
        content.style.display = "block";
        content.style.maxWidth = content.scrollWidth + "px";
    }
});