This folder contains two options to run your back-end:

### `./node.js-express`

This is a REST API written in Node.js with Express middleware. It does not
serve a front-end app or HTML pages, so you'll need to run `client/angular` or
`client/react` to have a web UI.

### `./asp.net-core`

This project was created with .NET Command Line Tools (2.2.105),
`dotnet new mvc --name Ziwi --language C# --auth Individual`.

It's the same REST API as `node.js-express`, but also serves a web UI using the
ASP.NET MVC pattern. If you run this back-end, there's no need to run a
separate front-end SPA like `client/angular` or `client/react` unless you want.
The Angular and React apps can consume this back-end as easily as
`node.js-express`, but if you are running this back-end, a web UI is already
running too.
