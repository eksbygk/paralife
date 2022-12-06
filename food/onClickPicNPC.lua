local finishHtml = [[
    <div style="width:888px;height:303px;background: url(images/dialog/f9-0.png)"></div>
]]
local finishDialog = window(finishHtml, "_ctb", 0, -50, 888, 300)
finishDialog:SetDesignResolution(1800, 300)
finishDialog:registerEvent("onmouseup", function(event)
    if event:button() == "left" then
        finishDialog:hide()
    end
end)
finishDialog:hide()

local html = [[
    <div style="width:888px;height:303px;background: url(images/dialog/f9-1.png)">
        <div style="margin-top:170;margin-left:130;">
            <span onclick="onClickItem" param="rule" style="width:158;height:40;background: url(images/dialog/f9-1a.png)"></span>
            <span onclick="onClickItem" param="yes" style="margin-left:10;width:208;height:40;background: url(images/dialog/f9-1b.png)"></span>
            <span onclick="onClickItem" param="no" style="margin-top:8;margin-left:15;width:223;height:30;background: url(images/dialog/f9-1c.png)"></span>
        </div>
    </div>
]]
local dialog = window(html, "_ctb", 0, -50, 888, 300)
dialog:SetDesignResolution(1800, 300)
dialog:hide()

local isFinsh = {false, false}
local currentIndex = 0

function onClickItem(i, mcmlNode)
    local param = mcmlNode:GetAttribute("param")
    if param == "yes" then
        broadcast("starPicGame", currentIndex)
    elseif param == "rule" then
        setBlock(19156, 3, 19183, 0)
        wait(0.1)
        setBlock(19156, 3, 19183, 192)
    end
    dialog:hide()
end

registerBroadcastEvent("onClickPicNPC", function(msg)
    msg = commonlib.totable(msg)
    local entity = GetEntity(msg.name)
    if entity then
        local index = entity.tag
        if index then
            currentIndex = tonumber(index)
            if isFinsh[currentIndex] then
                finishDialog:show()
                playText("拼图已经修复好了，真是太谢谢你了", nil, 10005)
            else
                dialog:show()
                playText("小朋友，这幅拼图被我不小心打乱了，你可以帮我复原么", nil, 10005)
            end
        end
    end
end)

registerBroadcastEvent("finishPic", function(style)
    local index = tonumber(style)
    isFinsh[index] = true
end)

