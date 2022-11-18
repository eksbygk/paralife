local fruitsSimple = {
    {
        -- 樱桃
        file = "blocktemplates/a1.bmax",
        size = 1
    }, {
        -- 芒果
        file = "blocktemplates/a5.bmax",
        size = 0.8
    }, {
        -- 牛油果
        file = "blocktemplates/a8.bmax",
        size = 1.2
    }, {
        -- 葡萄
        file = "blocktemplates/a19.bmax",
        size = 1.6
    }, {
        -- 菠萝
        file = "blocktemplates/a24.bmax",
        size = 1.2
    }, {
        -- 香蕉
        file = "blocktemplates/a28.bmax",
        size = 0.8
    }
}

local dollMac = GetEntity("20221103T083228.561075-93")
local x, y, z = dollMac:GetPosition()

registerBroadcastEvent("getFruit", function(msg)
    local fruit = dollMac:CloneMe()
    fruit:SetModelFile(fruitsSimple[msg].file)
    fruit:SetScaling(fruitsSimple[msg].size)
    fruit:SetPosition(x - 1.4, y + 1, z + 0.9)
    fruit:EnableDynamicPhysics(true)
end)

