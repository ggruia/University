const form = document.querySelector('.form');

// ???
// const but = document.querySelector('.add_game');
// but.addEventListener('click', alert(1), false);
// but.onclick = () => {alert(1)};

const submitButton = document.querySelector(".add_game");
submitButton.addEventListener('click', createPost);

function createPost() {

    let newPost = {
        name: document.querySelector(".title").value,
        description: document.querySelector(".desc").value,
        img: document.querySelector(".image").value,
        link: document.querySelector(".href").value
    }

    fetch('http://localhost:3000/games', {
        method: 'post',
        body: JSON.stringify(newPost),
        headers: {
            'Content-Type': 'application/json'
        }
    }).then(document.location.reload());
}
