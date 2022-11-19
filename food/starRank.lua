starNum = 0

local starhtml = [[
    <div style="width:234px;height:92px;background: url(images/f8.png)">
    </div>
]]

local rankHtml = [[
    <div style="margin-top:38;margin-left:120;width:100;font-size:24; color:#fff">
        <span><%=starNum%></span>
        <span style="margin-left:10">/ 30</span>
    <div>
]]

local star = window(starhtml, "_lt", 20, 10, 10, 10)
local rank = window(rankHtml, "_lt", 20, 10, 10, 10)
star:SetDesignResolution(1800, 300)
rank:SetDesignResolution(1800, 300)

registerBroadcastEvent("getStar", function(msg)
    starNum = starNum + 1
    rank:CloseWindow()
    rank = window(rankHtml, "_lt", 20, 10, 10, 10)
end)
