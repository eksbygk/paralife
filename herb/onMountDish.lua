local herbSet = {
    ["blocktemplates/a21.bmax"] = {
        herbname = "白芍",
        herb = "blocktemplates/白芍.bmax"
    },
    ["blocktemplates/a22.bmax"] = {
        herbname = "黄连",
        herb = "blocktemplates/黄连.bmax"
    },
    ["blocktemplates/a23.bmax"] = {
        herbname = "灵芝",
        herb = "blocktemplates/灵芝.bmax"
    },
    ["blocktemplates/a24.bmax"] = {
        herbname = "枸杞",
        herb = "blocktemplates/枸纪子.bmax"
    }
}

registerBroadcastEvent("onMountDish", function(msg)
    msg = commonlib.totable(msg)
    local entity = GetEntity(msg.name)
    local mountedEntity = GetEntity(msg.mountedEntityName)
    if entity and mountedEntity then
        local entityFile = entity:GetModelFile()
        local mountedEntityFile = mountedEntity:GetModelFile()
        if herbSet[entityFile] and herbSet[entityFile].herb == mountedEntityFile then
            tip("成功收集到药材")
            broadcast("getStar")
            mountedEntity:SetCanDrag(false)
            entity:SetOnClickEvent(nil)
        end
    end
end)

registerBroadcastEvent("onClickDish", function(msg)
    msg = commonlib.totable(msg)
    local entity = GetEntity(msg.name)
    if entity then
        local entityFile = entity:GetModelFile()
        if herbSet[entityFile] then
            tip("请收集药材: " .. herbSet[entityFile].herbname)
            playText("请收集药材: " .. herbSet[entityFile].herbname, nil, 10005)
        end
    end
end)
