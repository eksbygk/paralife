local foodTable = {
    ["blocktemplates/f20.bmax"] = "blocktemplates/f25.bmax"
}

function ovenAmin(entity)
    local x, y, z = entity:GetPosition()
    for i = 0, 1, 0.1 do
        entity:SetPosition(x, y, z + dirZ * i)
        wait(0.01)
    end
end

registerBroadcastEvent("onClickInnerOven", function(msg)
    msg = commonlib.totable(msg)
    local entity = GetEntity(msg.name)
    if (entity) then
        local facing = entity:GetFacing()
        local dirZ = 0.5
        if (entity.tag == "open") then
            dirZ = -dirZ
            entity.tag = "close"
            -- local door_x, door_y, door_z = entity:GetPosition()
        else
            entity.tag = "open"
            local OvenEntity = GetEntity("20221114T081354.972231-217")
            OvenEntity:ForEachChildLinkEntity(function(childEntity)
                print(childEntity:GetModelFile())
                local file = childEntity:GetModelFile()
                if foodTable[file] then
                    childEntity:SetModelFile(foodTable[file])
                end
            end)
        end
        ovenAmin(entity)
    end
end)
