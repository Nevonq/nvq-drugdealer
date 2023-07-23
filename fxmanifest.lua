fx_version 'cerulean'
game 'gta5'
Author 'Nevonq'
Description 'Simple drug dealer system that allows you to buy and sell items from the dealer.'
Version '1.0'
client_scripts {
    'configs/*.lua',
    '@es_extended/locale.lua',    
    'client/*.lua',
    'locales/*.lua',
}

server_scripts {
    'server/*.lua',
    '@es_extended/locale.lua',    
    'configs/*.lua',
    'locales/*.lua',
}
