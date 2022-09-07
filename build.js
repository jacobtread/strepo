const fs = require("fs/promises");
const path = require("path");

generateSite().then().catch()

async function generateSite() {

    const contents = await collectContents("public");

    let body = "<ul>"

    const appendItem = (item) => {
        body += "<li>"
        if (item.isDir) {
            body += item.name;
        } else {
            body += `<a href="/${item.path}">${item.name}</a>`
        }


        if (item.children.length > 0) {
            body += "<ul>"
            for (let child of item.children) {
                appendItem(child)
            }
            body += "</ul>"
        }
        body += "</li>"
    }

    for (let content of contents) {
        appendItem(content)
    }

    body += "</ul>"

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
<h1>Updated at ${date.toDateString()} ${date.getHours()}:${date.getMinutes()}:${date.getSeconds()}</h1>
${body}
</body>
</html>
`
    await fs.writeFile("./public/index.html", template)
}

async function collectContents(dir) {
    let items = await fs.readdir(dir);
    return await Promise.all(items
        .filter(item => item !== "index.html")
        .map(async (item) => {
        let itemPath = path.join(dir, item);
        let stat = await fs.lstat(itemPath);

        let children;
        let isDir = stat.isDirectory()

        if (isDir) {
            children = await collectContents(itemPath)

        } else {
            children = []
        }

        return {
            name: item,
            isDir,
            path: itemPath.replace(/\\/g, '/'),
            children
        }
    }));
}