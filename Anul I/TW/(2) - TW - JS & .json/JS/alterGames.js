// script pentru a modifica JOCURILE din baza de date

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
const form = document.querySelector('form');
form.addEventListener('submit', function(){createPost()});

function renderGames() {
    fetch ('http://localhost:3000/games?_sort=name&_order_asc', {
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
                edit_button.onclick = function(){editPost(post.id)};

                let edit_img = document.createElement("img");
                edit_img.setAttribute("src", "/Images/edit_img.png")

                edit_button.appendChild(edit_img);


                let delete_button = document.createElement("div");
                delete_button.className = "delete";
                delete_button.onclick = function(){deletePost(post.id)};

                let delete_img = document.createElement("img");
                delete_img.setAttribute("src", "/Images/delete_img.png")

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

window.addEventListener('DOMContentLoaded', function(){renderGames()});


function createPost() {

    let post = {
        name: form.title.value,
        description: form.desc.value,
        img: form.image.value,
        link: form.href.value
    }

    fetch('http://localhost:3000/games', {
        method: 'post',
        body: JSON.stringify(post),
        headers: {
            'Content-Type': 'application/json'
        }
    }).then(function() {
        window.location.replace('/HTML/games.html');
    })
}


async function editPost(gameID) {

    let
    new_name = form.title.value,
    new_description = form.desc.value,
    new_img = form.image.value,
    new_link = form.href.value;

    //kinda-synchronized fetch request
    const response = await fetch('http://localhost:3000/games', {method: 'get'});
    const posts = await response.json();

    posts.forEach(function(post) {
        if(post.id == gameID) {
            if (new_name.length == 0) {
                new_name = post.name;
            }
            if (new_description.length == 0) {
                new_description = post.description;
            }
            if (new_img.length == 0) {
                new_img = post.img;
            }
            if (new_link.length == 0) {
                new_link = post.link;
            }
        }
    })

    let post = {
        name: new_name,
        description: new_description,
        img: new_img,
        link: new_link
    }
    fetch('http://localhost:3000/games/' + gameID, {
        method: 'put',
        body: JSON.stringify(post),
        headers: {
            'Content-Type': 'application/json'
        }
    }).then(function() {
        window.location.replace('/HTML/games.html');
    })
}


function deletePost(gameID){
    fetch('http://localhost:3000/games/' + gameID, {
        method: 'delete',
        headers:{
            'Content-Type': 'application/json'
        }
    }).then(function() {
        window.location.replace('/HTML/games.html');
    })
}



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

//var submit = document.querySelector(".add_game");
//submit.addEventListener('click', alert(1));