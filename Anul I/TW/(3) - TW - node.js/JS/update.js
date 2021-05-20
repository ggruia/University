

async function editPost(gameID) {

    let
    new_name = document.querySelector(".title").value,
    new_description = document.querySelector(".desc").value,
    new_img = document.querySelector(".image").value,
    new_link = document.querySelector(".href").value;

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