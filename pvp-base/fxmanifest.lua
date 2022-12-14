fx_version 'adamant'

game 'gta5'

ui_page "html/index.html"

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "locale.lua",
    "config.lua",
    "maps.lua",
    "server/main.lua",
    "server/util.lua",
    "server/logging.lua",
    "server/account.lua",
    "server/gamemodes.lua",
    "server/sessions.lua",
    "server/menu.lua",
    "gamemodes/ffa/config.lua",
    "gamemodes/ffa/server.lua"
}

client_scripts {
    "locale.lua",
    "config.lua",
    "maps.lua",
    "client/main.lua",
    "client/util.lua",
    "client/account.lua",
    "client/sessions.lua",
    "client/menu.lua",
    "client/death.lua",
    "gamemodes/ffa/client.lua"
}

shared_scripts {
    "shared.lua"
}