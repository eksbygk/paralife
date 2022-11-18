local fire = "character/CC/05effect/fire.x"

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
            wait(1)
            fireEntity:Destroy()
        end
    end
end)
