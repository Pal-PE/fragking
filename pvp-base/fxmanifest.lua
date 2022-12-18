fx_version 'adamant'

game 'gta5'

ui_page "html/index.html"

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "shared/locale.lua",
    "shared/config.lua",
    "shared/maps.lua",
    "server/main.lua",
    "shared/items.lua",
    "server/stash.lua",
    "server/util.lua",
    "server/logging.lua",
    "server/account.lua",
    "server/gamemodes.lua",
    "server/sessions.lua",
    "server/menu.lua",
    "server/commands.lua",
    "server/tebex.lua",
    "gamemodes/ffa/config.lua",
    "gamemodes/ffa/server.lua",
    "gamemodes/gungame/config.lua",
    "gamemodes/gungame/server.lua",
    "gamemodes/redzone/server.lua",
    "gamemodes/training/server.lua",
    "gamemodes/sessions.lua"
}

client_scripts {
    "shared/locale.lua",
    "shared/config.lua",
    "shared/items.lua",
    "shared/maps.lua",
    "client/main.lua",
    "client/util.lua",
    "client/plyData.lua",
    "client/sessions.lua",
    "client/menu.lua",
    "client/death.lua",
    "gamemodes/ffa/client.lua",
    "gamemodes/gungame/client.lua",
    "gamemodes/redzone/client.lua"
}

shared_scripts {
    "shared.lua"
}