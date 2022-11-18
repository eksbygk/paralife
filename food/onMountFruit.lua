local fruitsTable = {
    -- 樱桃
    ["blocktemplates/a1.bmax"] = {
        file = "blocktemplates/a2.bmax",
        size = 0.89
    },
    ["blocktemplates/a2.bmax"] = {
        file = "blocktemplates/a3.bmax",
        size = 0.77
    },
    -- 香蕉
    ["blocktemplates/a28.bmax"] = {
        file = "blocktemplates/a29.bmax",
        size = 0.77
    },
    ["blocktemplates/a29.bmax"] = {
        file = "blocktemplates/a30.bmax",
        size = 1
    },
    -- 葡萄
    ["blocktemplates/a21.bmax"] = {
        file = "blocktemplates/a20.bmax",
        size = 1
    },
    ["blocktemplates/a20.bmax"] = {
        file = "blocktemplates/a19.bmax",
        size = 1.88
    },
    -- 牛油果
    ["blocktemplates/a9.bmax"] = {
        file = "blocktemplates/a8.bmax",
        size = 1
    },
    ["blocktemplates/a8.bmax"] = {
        file = "blocktemplates/a7.bmax",
        size = 1
    }
}

registerBroadcastEvent("onMountFruit", function(msg)
    msg = commonlib.totable(msg)
    local entity = GetEntity(msg.name)
    local mountedEntity = GetEntity(msg.mountedEntityName)
    if entity and mountedEntity then
        local filename = entity:GetModelFile()
        if mountedEntity:GetModelFile() == filename and fruitsTable[filename] then
            entity:SetModelFile(fruitsTable[filename].file)
            entity:SetScaling(fruitsTable[filename].size)
            entity:EnableDynamicPhysics(false)
            entity:EnablePhysics(true)
            mountedEntity:Destroy()
        end
    end
end)
