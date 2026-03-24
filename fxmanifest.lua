fx_version 'cerulean'
game 'gta5'

name 'nordic_bridge'
description 'Universal bridge for frameworks, inventories, notifications, clothing and more'
author 'Nordic'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'shared/main.lua',
}

client_scripts {
    'client/main.lua',
    'client/framework/*.lua',
    'client/inventory/*.lua',
    'client/notifications/*.lua',
    'client/clothing/*.lua',
    'client/textui/*.lua',
    'client/interact/registry.lua',
    'client/interact/ox_target.lua',
    'client/interact/qb-target.lua',
    'client/interact/nordic_interact.lua',
    'client/interact/ox_lib.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/keys/registry.lua',
    'server/keys/backends/*.lua',
    'server/keys/init.lua',
    'server/main.lua',
    'server/framework/*.lua',
    'server/inventory/*.lua',
    'server/notifications/*.lua',
    'server/clothing/*.lua',
}

dependencies {
    'oxmysql',
    'ox_lib',
}

lua54 'yes'
