function getHtml(filename)
    local filename = "images/" .. filename .. ".png"
    local html = string.format([[
        <div style="width: 658;height: 163;background: url(%s);">
        </div>
    ]], filename)
    return html
end

function createDialog(html)
    local dialog = window(html, "_ct", -329, 100, 658, 163)
    dialog:SetDesignResolution(1800, 300)
    dialog:hide()
    dialog:registerEvent("onmouseup", function(event)
        if event:button() == "left" then
            dialog:hide()
        end
    end)
    return dialog
end

local herbDialogs = {}
for i = 1, 9, 1 do
    local html = getHtml("a" .. i)
    local dialog = createDialog(html)
    herbDialogs[i] = dialog
end

registerBroadcastEvent("onClickHerb", function(msg)
    msg = commonlib.totable(msg)
    local entity = GetEntity(msg.name)
    if entity then
        local herbIndex = tonumber(entity.tag)
        herbDialogs[herbIndex]:show()
        wait(5)
        herbDialogs[herbIndex]:hide()
    end
end)
