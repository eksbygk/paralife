local waterContainers = {
    ["blocktemplates/b29.bmax"] = {
        ["blocktemplates/f8.bmax"] = {
            filename = "blocktemplates/f9.bmax"
        }
    }

}

registerBroadcastEvent("__entity_onhover", function(msg)
    msg = commonlib.LoadTableFromString(msg)

    local entity = GameLogic.EntityManager.GetEntity(msg.name)
    local hoverEntity = GameLogic.EntityManager.GetEntity(msg.hoverEntityName)
    run(function()
        if (entity and hoverEntity) then
            local filenameTop = hoverEntity:GetModelFile() or ""
            local filenameBottom = entity:GetModelFile() or ""

            -- pour water into another cup
            local waterItem = waterContainers[filenameTop]
            if (waterItem and not hoverEntity.isPouring) then
                local result = waterItem[filenameBottom]
                if (result) then
                    hoverEntity.isPouring = true
                    if (hoverEntity:IsAutoTurningDuringDragging()) then
                        hoverEntity:SetFacing(entity:GetFacing())
                    end
                    if (waterItem.playSpawnEffect) then
                        local x, y, z = entity:GetPosition()
                        mygame.PlaySpawnEffect(x, y, z)
                    end
                    broadcast("playEntityClickSound", waterItem.poursound or "pourwater")
                    local x, y, z = hoverEntity:GetPosition()
                    hoverEntity:SetPosition(x, y, z - 1)
                    for i = 1, 10 do
                        hoverEntity:SetRoll(i / 10 * math.pi / 2)
                        wait(0.05)
                    end
                    entity:SetModelFile(result.filename)
                    for i = 10, 0, -1 do
                        hoverEntity:SetRoll(i / 10 * math.pi / 2)
                        wait(0.05)
                    end
                    hoverEntity:SetPosition(x, y, z)
                    hoverEntity.isPouring = nil;
                    return
                end
            end
        end
    end)
end)
