function deletePost(gameID){
    fetch('http://localhost:3000/games/' + gameID, {
        method: 'delete',
        headers:{
            'Content-Type': 'application/json'
        }
    }).then(function() {
        window.location.reload();
    })
}