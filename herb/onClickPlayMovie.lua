local isPlayedMovie = {}

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
        end
    end
end)
