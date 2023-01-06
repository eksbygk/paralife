registerBroadcastEvent("onClickSetPitch", function(msg)
    msg = commonlib.totable(msg)
    local entity = GetEntity(msg.name)
    if entity then
        -- entity:SetRoll(90 * math.pi / 180)
        entity:SetPitch(90 * math.pi / 180)
    end
end)
