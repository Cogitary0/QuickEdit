--temporary solution
local mainBuild = require("quickedit:build/main/mainBuild")

local editorSession = {}

function editorSession.delete(pos1, pos2) mainBuild.delete(pos1, pos2) end

function editorSession.fill(pos1, pos2, use) mainBuild.fill(pos1, pos2, use, true) end

function editorSession.linespace(pos1, pos2, use) mainBuild.linespace(pos1, pos2, use) end

function editorSession.cuboid(pos1, pos2, use) mainBuild.cuboid(pos1, pos2, use, false) end

function editorSession.circle(pos1, pos2, use) mainBuild.circle(pos1, pos2, use) end

function editorSession.serp(pos1, pos2, use) mainBuild.serp(pos1, pos2, use) end

function editorSession.sphere(pos1, pos2, use) mainBuild.sphere(pos1, pos2, use) end

function editorSession.cylinder(pos1, pos2, use) mainBuild.cylinder(pos1, pos2, use, true) end

function editorSession.replace(pos1, pos2, use, replace) mainBuild.replace(pos1, pos2, use, replace) end

return editorSession

