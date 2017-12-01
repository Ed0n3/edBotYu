--
-- Created by IntelliJ IDEA.
-- User: no0n3
-- Date: 30.11.17
-- Time: 14:43
-- To change this template use File | Settings | File Templates.
--


--card template
local Card = { name = "", type = 0, }
Card.__index = Card


function Card.new(cardName)
    local self = setmetatable({}, Card)
    self.value = init
    return self
end

function Card.set_value(self, newval)
    self.value = newval
end

function Card.get_value(self)
    return self.value
end


