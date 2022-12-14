fx_version 'adamant'

game 'gta5'

ui_page "html/index.html"

files {
    "html/index.html",
    "html/js/*.js",
    "html/css/*.css",
    "html/img/*.png"
}

client_scripts {
    "@NativeUI/NativeUI.lua",
    "config.lua",
    "client/main.lua",
    "client/weaponSelect.lua"
}

server_scripts {
    "config.lua",
    "server/main.lua"
}