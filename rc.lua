local fennel = require("./fennel")
fennel.path = fennel.path .. "/home/pg/.config/awesome/?.fnl"
table.insert(package.loaders or package.searchers, fennel.searcher)

require("cfg")
