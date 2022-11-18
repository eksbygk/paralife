-- 弹出对话框 播放动画
local moviePosTable = {}

registerCloneEvent(function(params)
    local posText = params.pos[1] .. params.pos[2] .. params.pos[3]
    if not moviePosTable[posText] then
        moviePosTable[posText] = true
        setActorValue("movieactor", 1)
        local x = params.pos[1] + tonumber(params.offset and params.offset.x or 0)
        local y = params.pos[2] + tonumber(params.offset and params.offset.y or 0)
        local z = params.pos[3] + tonumber(params.offset and params.offset.z or 0)
        setPos(x, y + 2, z)
        setActorValue("facing", params.dir or params.facing)
        playLoop(0, 10000)
        registerClickEvent(function()
            say("play movie")
        end)
    end
end)

registerBroadcastEvent("showMessage", function(params)
    clone("myself", params)
end)

-- 物品的点击事件
registerBroadcastEvent("onClickShowMessage", function(msg)
    msg = commonlib.totable(msg)
    local entity = GetEntity(msg.name)
    if entity then
        local tag = commonlib.totable(entity.tag)
        local bx, by, bz = entity:GetBlockPos()
        local params = {
            pos = {bx, by, bz},
            facing = entity:GetFacing() * 180 / math.pi,
            offset = tag.offset,
            dir = tag.dir
            -- moviePos = {bx, by, bz}
        }
        broadcast("showMessage", params)
        local x, y, z = entity:GetPosition()
        local dir = 1
        for i = 1, 4 do
            dir = -dir
            for j = 1, 5 do
                x = x + 0.002 * j * dir
                entity:SetPosition(x, y, z)
                wait(0.01)
            end
        end
    end
end)
