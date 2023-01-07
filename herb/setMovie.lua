local isPlayedMovie = {}

registerCloneEvent(function(data)
    setPos(data[1] + 0.5, data[2] + 3, data[3] + 0.5)
    setActorValue("facing", data[4])
end)

registerClickEvent(function()
    tip("已收集星星")
end)

registerBroadcastEvent("onClickPlayMovie", function(msg)
    msg = commonlib.totable(msg)
    local entity = GetEntity(msg.name)
    if entity then
        local movieIndex = tonumber(entity.tag)
        setBlock(18939 - movieIndex * 2, 5, 19005, 0)
        wait(0.1)
        setBlock(18939 - movieIndex * 2, 5, 19005, 192)
        if not isPlayedMovie[movieIndex] then
            broadcast("getStar")
            isPlayedMovie[movieIndex] = true
            local x, y, z = entity:GetBlockPos()
            local fac = entity:GetFacing() * 180 / math.pi
            clone("myself", {x, y, z, fac})
        end
    end
end)
