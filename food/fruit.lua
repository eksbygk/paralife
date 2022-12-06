local dollMac = GetEntity("20221103T083228.561075-93")
local x, y, z = dollMac.block_container.x, dollMac.block_container.y, dollMac.block_container.z
-- print(dollMac.block_container)

-- setPos(x+1.2, y+2, z+1.6) --zuoshangjiao
-- setPos(x, y+2, z+1.6) --zuo xia
-- setPos(x-0.5, y+2, z-0.1) --youxiajiao
-- setPos(x - 0.5, y + 2, z + 0.9)

local flag = true
registerCloneEvent(function(data)
    local index = data
    show()
    local fx = x + 0.1 * math.random(-5, 12)
    local fy = y + 2
    local fz = z + 0.1 * math.random(-1, 16)
    setPos(fx, fy, fz)
    setActorValue("movieactor", index)
    wait(0.01)
    while (true) do
        setActorValue("physicsHeight", 0.4)
        setActorValue("physicsRadius", 0.1)
        if (flag and isTouching("hand")) then
            flag = false
            wait(1)
            attachTo("hand")
            wait(4)
            attachTo(nil)
            move(0, -2, 0, 0.5)
            delete()
            -- print(index)
            broadcast("getFruit", index)
            flag = true
        end
    end
end)

hide()
for i = 1, 6 do
    clone("myself", i)
end
