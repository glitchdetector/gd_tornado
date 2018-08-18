resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_scripts {
    'helpers/GameSound.lua',
    'helpers/Helpers.lua',
    'helpers/LoopedParticle.lua',
    'helpers/MathEx.lua',

    'tornado/TEntity.lua',
    'tornado/TFactory.lua',
    'tornado/TParticle.lua',
    'tornado/TScript.lua',
    'tornado/TVortex.lua',

    'client.lua'
}

server_script 'server.lua'
