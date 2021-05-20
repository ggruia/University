const fs = require("fs");

// READ from db.json
module.exports.readJSONFile = () => {
    return JSON.parse(fs.readFileSync("db.json"))["games"];
}
  
// WRITE in db.json
module.exports.writeJSONFile = (content) => {
    fs.writeFileSync("db.json", JSON.stringify({games: content}), "utf8");
}