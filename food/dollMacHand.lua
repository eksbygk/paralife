setActorValue("name", "hand")

local dollMac = GetEntity("20221103T083228.561075-93")
local dollMacX, dollMacY, dollMacZ = dollMac.block_container.x,
                                     dollMac.block_container.y,
                                     dollMac.block_container.z
local x = dollMacX + 1.4
local y = dollMacY + 4.3
local z = dollMacZ + 1.5
local endX = x - 2.4
local endZ = z - 0.5

setPos(x, y, z)

local offsetX = 0
local offsetZ = 0
local flag = true
registerBroadcastEvent("clickDir", function(msg)
    if flag then
        local dir = msg
        if dir == "up" and offsetX < 1 then
            offsetX = offsetX + 1
            move(0.2, 0, 0, 0.2)
        end
        if dir == "left" and offsetZ < 0 then
            offsetZ = offsetZ + 1
            move(0, 0, 0.2, 0.2)
        end
        if dir == "down" and offsetX > -11 then
            offsetX = offsetX - 1
            move(-0.2, 0, 0, 0.2)
        end
        if dir == "right" and offsetZ > -11 then
            offsetZ = offsetZ - 1
            move(0, 0, -0.2, 0.2)
        end
    end
end)

registerBroadcastEvent("press", function(msg)
    flag = false
    setActorValue("movieactor", 2)
    move(0, -2.2, 0, 1)
    play(0, 500)
    wait(0.5)
    play(500, 0)
    wait(1)
    move(0, 2.2, 0, 1)
    setActorValue("movieactor", 1)
    move(endX - getX(), 0, endZ - getZ(), 2)
    play(0, 500)
    wait(0.5)
    play(500, 0)
    wait(0.5)
    move(1.5, 0, 0, 1)
    broadcast("pressEnd")
    offsetX = 0
    offsetZ = 0
    flag = true
end)
