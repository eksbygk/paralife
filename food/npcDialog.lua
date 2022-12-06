local talkedNpc = 0
local isGetStar = false
local isFristTalk = {}

for i = 1, 7 do
    isFristTalk[i] = false
end

function getHtml(index)
    local filename = "images/dialog/d" .. index .. ".png"
    local html = string.format([[
        <div style="width:888px;height:303px;background: url(%s)">
        </div>
    ]], filename)
    return html
end

local dialogWnds = {}

for i = 1, 7 do
    dialogWnds[i] = window(getHtml(i), "_ct", -444, 100, 888, 300)
    dialogWnds[i]:SetDesignResolution(1600, 300)
    dialogWnds[i]:hide()
    dialogWnds[i]:registerEvent("onmouseup", function(event)
        if event:button() == "left" then
            dialogWnds[i]:hide()
            if not isFristTalk[i] then
                talkedNpc = talkedNpc + 1
            end
            isFristTalk[i] = true
            if not isGetStar and talkedNpc >= 7 then
                isGetStar = true
                broadcast("playGetStar")
                -- 7位npc全部对话完毕 获得三颗星星
                broadcast("getMultipleSatr", 3)
            end
        end
    end)
end

registerBroadcastEvent("showDialog", function(index)
    dialogWnds[index]:show()
end)

