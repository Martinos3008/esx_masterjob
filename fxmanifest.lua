fx_version 'bodacious'
game 'gta5'
autor 'Martinos🥤#6522'

client_scripts {
    '@es_extended/locale.lua',
    'modules/jobs/**/client/*.lua',
    'modules/request/**/client/*.lua',
}

server_scripts {
    '@es_extended/locale.lua',
    '@mysql-async/lib/MySQL.lua',
    'modules/jobs/**/server/*.lua',
    'modules/request/**/server/*.lua',
}

shared_scripts {
    'shared/*.lua'
}
