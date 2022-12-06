hide()
local dollMacNames = {"20221103T083228.561075-93", "20221122T092044.220812-85", "20221122T092100.435167-86"}
local dollMacPositions = {}
local dollMacOffsets = {}

registerCloneEvent(function(index)
    setActorValue("index", index)
    setActorValue("name", "hand" .. index)
    local dollMac = GetEntity(dollMacNames[index])
    local dollMacX, dollMacY, dollMacZ = dollMac.block_container.x, dollMac.block_container.y, dollMac.block_container.z
    local x, y, z = dollMacX + 1.4, dollMacY + 4.3, dollMacZ + 1.5
    dollMacPositions[index] = {x, y, z}

    setPos(x, y, z)

    dollMacOffsets[index] = {
        flag = true,
        offsetX = 0,
        offsetZ = 0
    }
    registerBroadcastEvent("clickDir", function(msg)
        -- print("register", msg)
        local handIndex = getActorValue("index", index)
        local dollMacOffset = dollMacOffsets[handIndex]
        if msg[2] == handIndex then
            if dollMacOffset.flag then
                -- 收到了三则信息？offset扩大为三倍
                local dir = msg[1]
                if dir == "up" and dollMacOffset.offsetX < 3 then
                    dollMacOffset.offsetX = dollMacOffset.offsetX + 1
                    move(0.2, 0, 0, 0.2)
                end
                if dir == "left" and dollMacOffset.offsetZ < 6 then
                    dollMacOffset.offsetZ = dollMacOffset.offsetZ + 1
                    move(0, 0, 0.2, 0.2)
                end
                if dir == "down" and dollMacOffset.offsetX > -33 then
                    dollMacOffset.offsetX = dollMacOffset.offsetX - 1
                    move(-0.2, 0, 0, 0.2)
                end
                if dir == "right" and dollMacOffset.offsetZ > -27 then
                    dollMacOffset.offsetZ = dollMacOffset.offsetZ - 1
                    move(0, 0, -0.2, 0.2)
                end
            end
        end
    end)

    registerBroadcastEvent("press", function(msg)
        local handIndex = getActorValue("index", index)
        local dollMacOffset = dollMacOffsets[handIndex]
        if msg == handIndex then
            flag = false
            setActorValue("movieactor", 2)
            move(0, -2.2, 0, 1)
            play(0, 500)
            wait(0.5)
            play(500, 0)
            wait(1)
            move(0, 2.2, 0, 1)
            setActorValue("movieactor", 1)
            -- move(endX - getX(), 0, endZ - getZ(), 2)
            move(dollMacPositions[handIndex][1] - 2.4 - getX(), 0, dollMacPositions[handIndex][3] - 0.5 - getZ(), 2)
            play(0, 500)
            wait(0.5)
            play(500, 0)
            wait(0.5)
            move(1.5, 0, 0, 1)
            broadcast("pressEnd")
            dollMacOffset.offsetX = 0
            dollMacOffset.offsetZ = 0
            flag = true
        end

    end)
end)

for k, v in pairs(dollMacNames) do
    clone("myself", k)
end
