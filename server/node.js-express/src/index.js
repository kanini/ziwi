import http from "http";
import express from "express";
import cors from "cors";
import morgan from "morgan";
import connectDb from "./db";
import api from "./api";
import config from "./config.json";

let app = express();
app.server = http.createServer(app);

// Place the middleware for OPTIONS before other middlewares.
app.options("*", cors());

// Log all HTTP requests
app.use(morgan("dev"));

// Access-Control-Allow-Origin can be *, null, or a single origin.
// Multiple origins or origins with a wildcard are not allowed,
// so we build a whitelist to match against incoming requests.
// https://stackoverflow.com/questions/1653308/access-control-allow-origin-multiple-origin-domains
const whitelist = [
  "http://localhost:8000",
  "http://localhost:8080",
  "http://localhost:4200", // default port for Angular CLI projects
  "http://localhost:3000" // default port for Create React App projects
];
const isWhitelisted = function(origin) {
  return whitelist.indexOf(origin) !== -1 || !origin;
};
const corsOptions = {
  origin(origin, callback) {
    // https://gist.github.com/robert-claypool/3ca14a17e90a5580699556e09502db89
    if (isWhitelisted(origin)) {
      callback(null, true);
    } else {
      callback(null, false);
      console.log(
        `Origin '${origin}' is not trusted, so CORS was disabled for this request.`
      );
    }
  }
};
// Now apply our CORS rules to all routes
app.use(cors(corsOptions));

// 3rd party middleware
app.use(
  cors({
    exposedHeaders: config.corsHeaders
  })
);

connectDb(db => {
  // API router
  app.use("/api", api({ config, db }));

  app.server.listen(process.env.PORT || config.port, () => {
    console.log(`Ziwi API started on port ${app.server.address().port}`);
    console.log(`NODE_ENV is set to "${process.env.NODE_ENV}"`);
  });
});

export default app;
