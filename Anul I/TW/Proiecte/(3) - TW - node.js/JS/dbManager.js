var express = require("express");
var router = express.Router();

const dbService = require("./dbFunctions.js");
const dbRepository = require("./dbInOut.js");

// Get ALL Games
router.get("/games", (req, res) => {
    let posts = dbService.getAllGames();

    if (posts != undefined && posts.length != 0){
        res.status(200).send(posts);
    }
    else {
        res.status(404).send("No games in DataBase!");
    }
});

// Get Game by ID
router.get("/games/:id", (req, res) => {
    let posts = dbService.getAllGames();
    let id = req.params.id;
    let found = false;

    posts.forEach(post => {
       console.log(post.id);

        if(post.id == id){
            found = true;
            res.status(200).send(post);
        }
    })

    if(found == false) {
        res.status(404).send("No game matches the id!");
    }
});

// Create new Game
router.post("/games", (req, res) => {
    let post = dbService.addGame(req.body);

    res.status(200).send(post);
});

// Update Game by ID
router.put("/games/:id", (req, res) => {
    const posts = dbService.getAllGames();
    let id = req.params.id;
    let found= false;

    posts.forEach(post => {
        if(post.id == id) {
            if(req.body.name){
                post.name = req.body.name;
            }

            if(req.body.description){
                post.description = req.body.description;
            }

            if(req.body.img){
                post.img = req.body.img;
            }

            if(req.body.link){
                post.link = req.body.link;
            }

            found = true;
        }
    })

    if(found == true) {
        dbRepository.writeJSONFile(posts);
        res.status(200).send("Game successfully updated!");
    }
    
    else {
        res.status(404).send("No game matches the id!");
    }
})

// Delete Game by ID
router.delete("/games/:id", (req, res) => {
    const posts = dbService.getAllGames();
    let id = req.params.id;
    let found= false;

    for(let i = 0; i< posts.length; i++){
        if(posts[i].id == id) {
            posts.splice(i, 1);

            found = true;
        }
    }
  
    if(found == true) {
        dbRepository.writeJSONFile(posts);
        res.status(200).send("Game deleted!");
    } else {
        res.status(404).send("Game not found!");
    }
  });


module.exports = router;