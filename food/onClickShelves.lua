-- 摇晃货架 掉落初级水果
local fruitsSimple = {
    {
        -- 一个樱桃
        file = "blocktemplates/a1.bmax",
        size = 1
    }, {
        -- 半个牛油果无核
        file = "blocktemplates/a9.bmax",
        size = 1
    }, {
        -- 三颗葡萄
        file = "blocktemplates/a21.bmax",
        size = 1
    }, {
        -- 一个香蕉
        file = "blocktemplates/a28.bmax",
        size = 0.79
    }
}

registerBroadcastEvent("onClickShelves", function(msg)
    msg = commonlib.totable(msg)
    local entity = GetEntity(msg.name)
    if entity then
        -- 掉落次数
        local time = entity.tag or 4
        if time > 0 then
            local x, y, z = entity:GetPosition()
            local dir = 1
            for i = 1, 4 do
                dir = -dir
                for j = 1, 10 do
                    x = x + 0.002 * j * dir
                    entity:SetPosition(x, y, z)
                    wait(0.01)
                end
            end
            for k, v in pairs(fruitsSimple) do
                local fruit = entity:CloneMe()
                fruit:SetModelFile(v.file)
                fruit:SetScaling(v.size)
                fruit:SetCanDrag(true)
                fruit:SetOnClickEvent(nil)
                fruit.tag = nil
                fruit:SetOnMountEvent("onMountFruit")
                fruit:EnableDynamicPhysics(true)
                fruit:SetPosition(x + math.random(0, 1) * 4 - 2, y + 3,
                                  z + math.random(-2, 2))
            end
            time = time - 1
            entity.tag = time
        else
            tip("货架上没有水果了!")
        end

    end
end)
