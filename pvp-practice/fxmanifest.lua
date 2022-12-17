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
    "client/tracking.lua",
    "client/gridshot.lua",
    "client/speed.lua",
    "client/classic.lua",
    "client/precision.lua",
    "client/targetswap.lua",
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "config.lua",
    "server/main.lua"
}