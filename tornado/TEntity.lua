TEntity = {
    parent = nil,
}

function TEntity:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function TEntity:TEntity(baseRef, parent)
    self.parent = parent
end

function TEntity:OnUpdate(gameTime)
    local parentPos = self.parent._position
    
end
