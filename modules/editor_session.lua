--temporary solution
local preBuild = require("quickedit:build/preBuild")

local editorSession = {}

-- function editorSession.fill(pos1, pos2, filled, container, session) preBuild.preCuboid(pos1, pos2, true, container, session) end

function editorSession.cuboid(pos1, pos2, filled, container, session) preBuild.preCuboid(pos1, pos2, filled, container, session) end

function editorSession.line(pos1, pos2, filled, container, session) preBuild.preLinespace(pos1, pos2, filled, container, session) end

function editorSession.circle(pos1, pos2, filled, container, session) preBuild.preCircle(pos1, pos2, filled, container, session) end

function editorSession.serp(pos1, pos2, filled, container, session) preBuild.preSerp(pos1, pos2, filled, container, session) end

function editorSession.ball(pos1, pos2, filled, container, session) preBuild.preSphere(pos1, pos2, filled, container, session) end

function editorSession.cyl(pos1, pos2, filled, container, session) preBuild.preCylinder(pos1, pos2, filled, container, session) end

function editorSession.replace(pos1, pos2, filled, container, session) preBuild.preReplace(pos1, pos2, filled, container, session) end

function editorSession.undo(session) preBuild.undo(session) end

function editorSession.build(session, replaceQ) preBuild.build(session, replaceQ) end

return editorSession

