import { version } from "../../package.json";
import { Router } from "express";

export default ({ config, db }) => {
  let api = Router();

  api.get("/version", (req, res) => {
    res.json({ version });
  });

  return api;
};
