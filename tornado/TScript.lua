MainScript = {
    _factory = {}
}

function MainScript:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function MainScript:MainScript()
    self:RegisterVars()
    self:SetupAssets()
    self._factory = TornadoFactory:new()
end

function MainScript:SetupAssets()
    if VORTEX_PARTICLE_MOD then
        -- MemoryAccess.Initialize()
        -- MemoryAccess.PatchPtfx()
    end
    GameSound.Load("FBI_HEIST_ELEVATOR_SHAFT_DEBRIS_SOUNDS")
    GameSound.Load("FBI_HEIST_ELEVATOR_DEBRIS_01")
    GameSound.Load("FBI_HEIST_ELEVATOR_DEBRIS_02")
    GameSound.Load("FBI_HEIST_ELEVATOR_DEBRIS_03")
    GameSound.Load("FBI_HEIST_ELEVATOR_DEBRIS_04")
    GameSound.Load("FBI_HEIST_ELEVATOR_DEBRIS_05")
    GameSound.Load("BASEJUMPS_SOUNDS")
    print("Sounds Loaded")
end

function MainScript:RegisterVars()
    TOGGLE_CONSOLE = true
    ENABLE_CONSOLE = false
    NOTIFICATIONS = true
    SPAWN_IN_STORM = true
    TOGGLE_SCRIPT = true
    ENABLE_KEYBINDS = true
    MULTI_VORTEX = true
    VORTEX_MOVEMENT_ENABLED = true
    VORTEX_MOVE_SPEED_SCALE = 1.0
    VORTEX_TOP_ENTITY_SPEED = 120.0
    VORTEX_MAX_ENTITY_DIST = 50.0
    VORTEX_HORIZONTAL_PULL_FORCE = 1.7
    VORTEX_VERTICAL_PULL_FORCE = 2.29
    VORTEX_ROTATION_SPEED = 2.4
    VORTEX_RADIUS = 9.40
    VORTEX_REVERSE_ROTATION = false
    VORTEX_MAX_PARTICLE_LAYERS = 24
    VORTEX_PARTICLE_COUNT = 3
    VORTEX_LAYER_SEPERATION_SCALE = 22.0
    VORTEX_PARTICLE_NAME = "ent_amb_smoke_foundry"
    VORTEX_PARTICLE_ASSET = "core"
    VORTEX_PARTICLE_MOD = true
    VORTEX_GIRTH_MOD = 8.0
    GAME_LAST_FRAME_TIME = 0.1
    VORTEX_THROW_PEDS = true
    VORTEX_THROW_VEHICLES = true
end

function MainScript:KeyPressed(sender, e)
    -- TODO: Controls
end

function MainScript:ReleaseAssets()
    GameSound.Release("FBI_HEIST_ELEVATOR_SHAFT_DEBRIS_SOUNDS")
    GameSound.Release("BASEJUMPS_SOUNDS")
end

function MainScript:OnUpdate(gameTime)
    self._factory:OnUpdate(gameTime)
end
