fx_version 'cerulean'
game 'gta5'

description 'TTC Logger'
version '1.0.0'

shared_scripts {
    --"@ttc-libs/shared/functions.lua"
}

server_script {
    --"@oxmysql/lib/MySQL.lua",
    "server/*.lua"
}

client_scripts {
    "client/*.lua"
}

lua54 'yes'
