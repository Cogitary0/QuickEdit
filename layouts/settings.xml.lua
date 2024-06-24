function on_open()
    set_page("stgTerra", "settingsTerraformer")
end

function set_page(btn, page)
    document.stgTerra.enabled = true
    document.stgLaser.enabled = true
    document.stgBuild.enabled = true
    document[btn].enabled = false
    document.menu.page = page
end
