local dollMacNames = {"20221103T083228.561075-93", "20221122T092044.220812-85", "20221122T092100.435167-86"}

local fruitsSimple = {
    {
        -- 樱桃
        file = "blocktemplates/a1.bmax",
        size = 1
    }, {
        -- 牛油果
        file = "blocktemplates/a9.bmax",
        size = 1
    }, {
        -- 葡萄
        file = "blocktemplates/a21.bmax",
        size = 1
    }, {
        -- 香蕉
        file = "blocktemplates/a28.bmax",
        size = 0.79
    }, {
        -- 菠萝
        file = "blocktemplates/a24.bmax",
        size = 1.2
    }, {
        -- 芒果
        file = "blocktemplates/a5.bmax",
        size = 0.8
    }
}

registerBroadcastEvent("getFruit", function(data)
    local dollMacIndex = data[1]
    local index = data[2]

    local dollMac = GetEntity(dollMacNames[dollMacIndex])
    local x, y, z = dollMac:GetPosition()

    local fruit = dollMac:CloneMe()
    fruit:SetModelFile(fruitsSimple[index].file)
    fruit:SetScaling(fruitsSimple[index].size)
    fruit:SetOnMountEvent("onMountFruit")
    fruit:SetPosition(x - 1.4, y + 1, z + 0.9)
    fruit:EnableDynamicPhysics(true)
end)

