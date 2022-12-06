-- 弹出对话框 播放动画
local moviePosTable = {}
local movieTable = {
    "19169,3,19175", -- 第1段动画
    "19169,3,19180", -- 第2段动画
    "19166,3,19175", -- 第3段动画
    "19166,3,19178", -- 第4段动画
    "19166,3,19181", -- 第5段动画
    "19160,3,19181", -- 第6段动画
    "19163,3,19184", -- 第7段动画
    "19156,3,19174" -- 第8段动画
}

local finishMovies = {}

registerCloneEvent(function(params)
    local posText = params.pos[1] .. params.pos[2] .. params.pos[3]
    if not moviePosTable[posText] then
        moviePosTable[posText] = true
        setActorValue("movieactor", 1)
        setActorValue("index", params.movieIndex)
        local x = params.pos[1] + tonumber(params.offset and params.offset.x or 0)
        local y = params.pos[2] + tonumber(params.offset and params.offset.y or 0)
        local z = params.pos[3] + tonumber(params.offset and params.offset.z or 0)
        setPos(x, y + 2, z)
        setActorValue("facing", params.dir or params.facing)
        playLoop(0, 10000)
        registerClickEvent(function()
            local index = getActorValue("index")
            local moviePos = movieTable[index]
            if not finishMovies[moviePos] then
                finishMovies[moviePos] = true
                broadcast("playGetStar")
                broadcast("getStar")
                wait(3)
                setActorValue("movieactor", 2)
            end
            if moviePos then
                cmd("setblock " .. moviePos .. " 0")
                wait(0.1)
                cmd("setblock " .. moviePos .. " 192")
            end
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
            dir = tag.dir,
            movieIndex = tag.index
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
