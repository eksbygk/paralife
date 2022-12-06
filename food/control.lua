local currentIndex = 0

function onClickDir(i, mcmlNode)
    local dir = mcmlNode:GetAttribute("param")
    broadcast("clickDir", {dir, currentIndex})
end

local flag = true

registerBroadcastEvent("pressEnd", function(msg)
    flag = true
end)

function onClickPress()
    if flag then
        flag = false
        broadcast("press", currentIndex)
    end
end

local html = [[
    <span>
        <div>
            <span onclick="onClickDir" param="up" style="margin-left:100;width: 100;height: 100;background: url(images/up.png);"></span>
        </div>
        <div>
            <span onclick="onClickDir" param="left"  style="width: 100;height: 100;background: url(images/left.png);"></span>
            <span onclick="onClickDir" param="down"  style="width: 100;height: 100;background: url(images/down.png);"></span>
            <span onclick="onClickDir" param="right"  style="width: 100;height: 100;background: url(images/right.png);"></span>
        </div>
    </span>
    <span>
        <span onclick="onClickPress" style="margin-top:100;margin-left:100;width: 100;height: 100;background: url(images/press.png);"></span>
    </span>
]]

local control = window(html, "_ct", -250, 0, 500, 200)
control:hide()
registerBroadcastEvent("showControl", function(index)
    currentIndex = index
    print(index)
    control:show()
end)
registerBroadcastEvent("hideControl", function(msg)
    control:hide()
end)

