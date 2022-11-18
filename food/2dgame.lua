-- hide()
score = 0

local html = [[
    <div style="color:red;">得分： <%=score%></div>
    <div onclick="exit" style="color:#ffffff;width:100;height:50;background-color:#303030;margin-top:20;font-size:20;line-height:50;text-align:center;">
        退出
    </div>
]]

local wnd = window(html, "_lt", 40, 100, 300, 100)

registerClickEvent(function()
    local name = tonumber(getActorValue("name"))
    if name < 5 then
        score = score + 2
        tip("蔬果肉类 +2分")
    else
        score = score - 1
        tip("零食 -1分")
    end
    wnd:CloseWindow()
    wnd = window(html, "_lt", 40, 100, 300, 100)
    delete()
end)

registerCloneEvent(function(i)
    currentNum = math.random(1, 6)
    setActorValue("movieactor", currentNum)
    setActorValue("name", currentNum)
    move(-134 * math.random(1, 6) - 110, 0, nil, 0)
    move(0, 500, nil, 0)
    move(0, -1000, nil, 5)
    wait(0.5)
    delete()
end)

while true do
    clone()
    wait(0.5)
end
