fx_version 'adamant'

game 'gta5'

ui_page "html/index.html#"

files {
    "html/index.html",
    "html/js/*.js",
    "html/css/*.css"
}

client_scripts {
    "config.lua",
    "client/main.lua",
    "client/object.lua",
    "client/loop.lua",
    "client/menu.lua",
    "client/activites/tracking.lua",
    "client/activites/gridshot.lua",
    "client/activites/speed.lua",
    "client/activites/classic.lua",
    "client/activites/precision.lua",
    "client/activites/targetswap.lua",
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "config.lua",
    "server/main.lua"
}