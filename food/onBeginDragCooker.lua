local plateFoods = {
    ["blocktemplates/b28.bmax"] = true, -- 餐盘
    ["blocktemplates/f22.bmax"] = true, -- 餐盘（装了生菜片）
    ["blocktemplates/f24.bmax"] = true, -- 餐盘（装了番茄片）
    ["blocktemplates/b26.bmax"] = true, -- 餐盘（装了煎蛋）
    ["blocktemplates/b31.bmax"] = true, -- 餐盘（装了熟肉）
    ["blocktemplates/f23.bmax"] = true -- 餐盘（装了沙拉）
}
local cupFoods = {
    ["blocktemplates/f8.bmax"] = true, -- 空杯子
    ["blocktemplates/f9.bmax"] = true -- 一杯牛奶
}

local foods = {
    ["blocktemplates/c23.bmax"] = true, -- 番茄片
    ["blocktemplates/c20.bmax"] = true, -- 生菜片
    ["blocktemplates/f21.bmax"] = true, -- 蛋
    ["blocktemplates/f20.bmax"] = true -- 肉（生）
}

registerBroadcastEvent("onBeginDragCooker", function(msg)
    msg = commonlib.totable(msg)
    local entity = GetEntity(msg.name)
    if entity then
        local file = entity:GetModelFile()
        if plateFoods[file] or cupFoods[file] or foods[file] then
            local x, y, z = entity:GetPosition()
            local subEntity = entity:CloneMe()
            if plateFoods[file] then
                subEntity:SetModelFile("blocktemplates/b28.bmax") -- 餐盘
            elseif cupFoods[file] then
                subEntity:SetModelFile("blocktemplates/f8.bmax") -- 空杯子
            end
            subEntity:EnablePhysics(true)
            subEntity:SetCanDrag(true)
        end
        entity:SetOnBeginDragEvent(nil)
    end
end)
