fx_version 'adamant'

game 'gta5'

ui_page "html/index.html#"

files {
    "html/index.html",
    "html/js/*.js",
    "html/css/*.css",
    "html/img/*.png",
    "html/img/masks/*.png"
}

client_scripts {
    "client/main.lua",
    "client/clothing.lua"
}

server_scripts {
    "server/main.lua"
}