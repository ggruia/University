const uuid = require("uuid");
const dbRepository = require("./dbInOut.js");

// Get ALL Games
module.exports.getAllGames = () => {
    let posts = dbRepository.readJSONFile();
    posts.sort((a, b) => (a.name < b.name) ? -1 : 1)

    return posts;
}

// Get Game by specified ID
module.exports.getGameById = (id) => {
    let posts = dbRepository.readJSONFile();
    let found = null;

    posts.forEach(post => {
        if(post.id === id) {
            found = post;
        }
    });

    return found;
}

// Add new Game in JSON
module.exports.addGame = (newPost) => {
    let posts = dbRepository.readJSONFile();

    newPost.id = uuid.v4.apply();
    posts.push(newPost);

    dbRepository.writeJSONFile(posts);

    return newPost;
}

// Update Game by specified ID
module.exports.updateGame = (id, newPost) => {
    const posts = dbRepository.readJSONFile();

    posts.forEach((post) => {
        if(post.id === id) {
            
            if(newPost.name) {
                post.name = newPost.name;
            }
            if(newPost.img) {
                post.img = newPost.img;
            }
            
            dbRepository.writeJSONFile(posts);
            return post;
        }
    });

    return null;
}

// Delete Game by specified ID
module.exports.deleteGame = (id) => {
    const posts = dbRepository.readJSONFile();

    for(let i = 0; i < posts.length; i++) {
        if(posts[i].id === id) {

            posts.splice(i, 1);
            
            dbRepository.writeJSONFile(posts);
            return true;
        }
    }

    return false;
}