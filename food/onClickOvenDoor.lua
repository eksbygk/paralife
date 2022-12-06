local foodTable = {
    ["blocktemplates/f20.bmax"] = "blocktemplates/f25.bmax"
}

-- character/CC/05effect/V5/wu/WU.x

registerBroadcastEvent("onclickOvenDoor", function(msg)
    msg = commonlib.totable(msg)
    local entity = GetEntity(msg.name)
    if (entity) then
        broadcastAndWait("onclick_DoorAxisX", msg)
        if (entity.tag == "close") then
            local door_x, door_y, door_z = entity:GetPosition()
            local OvenEntity = GetEntity("20221114T081616.969942-221")
            if (OvenEntity) then
                OvenEntity:ForEachChildLinkEntity(function(childEntity)
                    local childEntityName = commonlib.LoadTableFromString(childEntity).name
                    local filename = childEntity:GetModelFile()
                    local toFilename = foodTable[filename]
                    if (toFilename) then
                        local x, y, z = childEntity:GetPosition()
                        if (math.abs(y - door_y) < 0.5 and math.abs(door_z - z) < 1.1) then
                            childEntity:SetModelFile(toFilename)
                        end
                    end
                end)
            end
        end
    end
end)
