local currentDollMacIndex = 0

function onClickDir(i, mcmlNode)
    local dir = mcmlNode:GetAttribute("param")
    print("clickDir" .. currentDollMacIndex, dir)
    broadcast("clickDir" .. currentDollMacIndex, dir)
end

local flag = true

registerBroadcastEvent("pressEnd", function(msg)
    flag = true
end)

function onClickPress()
    if flag then
        flag = false
        broadcast("press" .. currentDollMacIndex)
    end
end

local html = [[
    <div>
        <span onclick="onClickDir" param="up"  style="margin-left:100;width: 100;height: 100;background: url(images/up.png);"></span>
        <span onclick="onClickPress" style="width: 100;height: 100;background: url(images/press.png);"></span>
    </div>
    <div>
        <span onclick="onClickDir" param="left"  style="width: 100;height: 100;background: url(images/left.png);"></span>
        <span onclick="onClickDir" param="down"  style="width: 100;height: 100;background: url(images/down.png);"></span>
        <span onclick="onClickDir" param="right"  style="width: 100;height: 100;background: url(images/right.png);"></span>
    </div>
]]

local control = window(html, "_ct", -100, 0, 300, 200)
control:hide()
registerBroadcastEvent("showControl", function(msg)
    -- print(msg)
    currentDollMacIndex = msg
    control:show()
end)
registerBroadcastEvent("hideControl", function(msg)
    currentDollMacIndex = 0
    control:hide()
end)

