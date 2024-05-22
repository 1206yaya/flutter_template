import * as ModuleAlias from "module-alias";

console.log("__dirname in fixTsPaths.ts", __dirname);
ModuleAlias.addAliases({
  "@trigger": __dirname + "/trigger",
  "@services": __dirname + "/services",
  "@callable": __dirname + "/callable",
  "@models": __dirname + "/models",
  "@": __dirname + "/",
});
