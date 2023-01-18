fx_version 'cerulean'
game 'gta5'

description 'TTC Base Script'
version '1.0.0'

shared_scripts {
    --'@ttc-libs/shared/functions.lua'
}

server_script {
    --'@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}

client_scripts {
    'client/*.lua'
}

dependencies {
    --'ttc-libs'
}

lua54 'yes'
