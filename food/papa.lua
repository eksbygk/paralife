anim(4)
local dialogHtml = [[
    <div style="width:888px;height:303px;background: url(images/dialog/e4.png)">
    </div>
]]

local text = "找到25颗以上的星星再来找我吧,万分感谢"

local dialog = window(dialogHtml, "_ctb", 0, -50, 888, 300)
dialog:SetDesignResolution(1800, 300)

dialog:registerEvent("onmouseup", function(event)
    if event:button() == "left" then
        dialog:hide()
    end
end)

local isPlayMovie = true
local movieX, movieY, movieZ = 19160, 3, 19185

registerBroadcastEvent("levelChange", function(level)
    local currentLevel = tonumber(level)
    if currentLevel == 2 then
        isPlayMovie = true
        movieX, movieY, movieZ = 19156, 3, 19178
        dialogHtml = [[<div style="width:888px;height:303px;background: url(images/dialog/p1.png)"></div>]]
        text = "要不要试着帮我找到剩下的星星？"
    elseif currentLevel == 3 then
        isPlayMovie = true
        movieX, movieY, movieZ = 19156, 3, 19182
        dialogHtml = [[<div style="width:888px;height:303px;background: url(images/dialog/p2.png)"></div>]]
        text = "太感谢你了，你真厉害，我现在充满了能量"
    end
    dialog:CloseWindow()
    dialog = window(dialogHtml, "_ctb", 0, -50, 888, 300)
    dialog:SetDesignResolution(1800, 300)
    dialog:registerEvent("onmouseup", function(event)
        if event:button() == "left" then
            dialog:hide()
        end
    end)
    dialog:hide()
end)

dialog:hide()

function playLevelMovie(x, y, z)
    setBlock(x, y, z, 0)
    wait(0.1)
    setBlock(x, y, z, 192)
end

registerClickEvent(function()
    if isPlayMovie then
        isPlayMovie = false
        playLevelMovie(movieX, movieY, movieZ)
    else
        dialog:show()
        playText(text, nil, 10005)
    end
end)
