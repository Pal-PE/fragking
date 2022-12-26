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
    "server/shop.lua",
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
    "gamemodes/elim/config.lua",
    "gamemodes/elim/server.lua",
    "gamemodes/sessions.lua"
}

client_scripts {
    "@PolyZone/client.lua",
    "shared/locale.lua",
    "shared/config.lua",
    "shared/items.lua",
    "shared/maps.lua",
    "shared/poly.lua",
    "client/main.lua",
    "client/death.lua",
    "client/util.lua",
    "client/spectate.lua",
    "client/plyData.lua",
    "client/sessions.lua",
    "client/poly.lua",
    "gamemodes/ffa/client.lua",
    "gamemodes/redzone/client.lua",
    "gamemodes/elim/client.lua"
}

shared_scripts {
    "shared.lua"
}