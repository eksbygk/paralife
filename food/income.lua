-- 设置自动开关范围，不需要开启
income = 0
local isGetStar = false
local incomeHtml = [[
    <div style="color:red;">当前收入： <%=income%></div>
]]
local incomeWnd = window(incomeHtml, "_lt", 40, 100, 100, 10)
incomeWnd:SetDesignResolution(1600, 300)

registerBroadcastEvent("getMoney", function(num)
    income = income + num
    incomeWnd:CloseWindow()
    incomeWnd = window(incomeHtml, "_lt", 40, 100, 100, 10)
    incomeWnd:SetDesignResolution(1600, 300)
    if not isGetStar and income >= 200 then
        -- 收入满200元，获得5颗星星
        isGetStar = not isGetStar
        broadcast("playGetStar")
        broadcast("getMultipleSatr", 5)
    end
end)
