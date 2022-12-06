local fire = "character/CC/05effect/fire.x"
local egg = "blocktemplates/f21.bmax"
local friedEgg = "blocktemplates/b27.bmax"

registerBroadcastEvent("onClickPot", function(msg)
    msg = commonlib.totable(msg)
    local entity = GetEntity(msg.name)
    if entity then
        local fireEntity = GetEntity(msg.name .. "fire")
        if not fireEntity then
            fireEntity = entity:CloneMe()
            fireEntity:SetName(msg.name .. "fire")
            fireEntity:SetModelFile(fire)
            fireEntity:SetScaling(1)
            local x, y, z = entity:GetPosition()
            fireEntity:SetPosition(x + 0.9, y - 0.5, z)
        else
            fireEntity:Destroy()
            entity:ForEachChildLinkEntity(function(childEntity)
                local file = childEntity:GetModelFile()
                if file == egg then
                    childEntity:SetModelFile(friedEgg)
                    childEntity:SetScaling(1.5)
                end
            end)
        end
    end
end)
