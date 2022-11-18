-- 获得星星进度
local starNum = 0
local odd = true
registerCloneEvent(function(msg)
    odd = not odd
    local actor = 2
    if odd then
        actor = 3
    else
        actor = 2
    end
    setActorValue("movieactor", actor)
    starNum = starNum + 1
    tip(starNum)
    setPos(getX() + 1.11 - (starNum - 1) * 0.042, getY(), getZ() + 0.5)
end)

-- 获得星星 发送getStar广播
local flag = true
registerBroadcastEvent("getStar", function(msg)
    if flag then
        flag = false
        clone("myself")
        wait(0.01)
        flag = true
    end
end)

