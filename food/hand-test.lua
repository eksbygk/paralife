hide()
local dollMacNames = {"20221103T083228.561075-93", "20221104T080019.978549-150"}

registerCloneEvent(function(index)
    local dollMac = GetEntity(dollMacNames[index])
    local dollMacX, dollMacY, dollMacZ = dollMac.block_container.x,
                                         dollMac.block_container.y,
                                         dollMac.block_container.z
    local x, y, z = dollMacX + 1.4, dollMacY + 4.3, dollMacZ + 1.5
    local endX, endZ = x - 2.4, z - 0.5

    setPos(x, y, z)

    local offsetX = 0
    local offsetZ = 0
    local flag = true
    registerBroadcastEvent("clickDir", function(msg)
        if msg[2] == index then
            if flag then
                local dir = msg[1]
                if dir == "up" and offsetX < 1 then
                    offsetX = offsetX + 1
                    move(0.2, 0, 0, 0.2)
                end
                if dir == "left" and offsetZ < 2 then
                    offsetZ = offsetZ + 1
                    move(0, 0, 0.2, 0.2)
                end
                if dir == "down" and offsetX > -11 then
                    offsetX = offsetX - 1
                    move(-0.2, 0, 0, 0.2)
                end
                if dir == "right" and offsetZ > -9 then
                    offsetZ = offsetZ - 1
                    move(0, 0, -0.2, 0.2)
                end
            end
        end
    end)

    registerBroadcastEvent("press", function(msg)
        if msg == index then
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
        end

    end)
end)

for k, v in pairs(dollMacNames) do
    clone("myself", k)
end

--------------------------------------------------------------------------------------------------
