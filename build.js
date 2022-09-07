const fs = require("fs")

const date = new Date();
const template = `
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>STREPO</title>
</head>
<body>
<h1>Built at ${date.toDateString()} ${date.getHours()}:${date.getMinutes()}:${date.getSeconds()}</h1>
</body>
</html>
`
fs.writeFileSync("./public/index.html", template)