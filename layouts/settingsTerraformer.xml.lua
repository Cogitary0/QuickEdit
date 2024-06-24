local const = require 'quickedit:constants'
local cont = require 'quickedit:utils/container'

function radius(text)
    document.radius_lb.text = "radius:" .. text
end


function mode(text)
    document.mode_lb.text = "mode:" .. text .. ' (' .. const.MODES[tonumber(text)] .. ')'
    cont:get().ter_mode = tonumber(text)
end

function filled(state)
    cont:get().filled = state
end
