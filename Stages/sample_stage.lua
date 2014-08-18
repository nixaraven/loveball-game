--Table
-- NameState es el nombre de la Stage
NameState = {}

-- New
-- No lo toquen
function NameState:new()
   local gs = {}

   gs = setmetatable(gs, self)
   self.__index = self
   _gs = gs
   
   return gs
end

--Load
function NameState:load()
end

--Close
function NameState:close()
end

--Enable
function NameState:enable()
end

--Disable
function NameState:disable()
end

--Update
function NameState:update(dt)
end

--Draw
function NameState:draw()
end

--KeyPressed
function NameState:keypressed(key, unicode)
end

--KeyReleased
function NameState:keyreleased(key, unicode)
end

--MousePressed
function NameState:mousepressed(x, y, button)
end

--MouseReleased
function NameState:mousereleased(x, y, button)
end