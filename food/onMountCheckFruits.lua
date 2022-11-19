-- 一篮水果换星星
local ripeFruits = {
    ["blocktemplates/a3.bmax"] = true,
    ["blocktemplates/a7.bmax"] = true,
    ["blocktemplates/a19.bmax"] = true,
    ["blocktemplates/a30.bmax"] = true
}

local fruitNum = 0
local basketNum = 0 -- 水果篮数
local nameTable = {}

function getFilenames(childEntity)
    local file = childEntity.filename
    local name = childEntity.name
    table.insert(nameTable, name)
    if ripeFruits[file] then
        fruitNum = fruitNum + 1
        if fruitNum >= 4 then
            tip("一筐成熟的水果")
            basketNum = basketNum + 1
            if basketNum <= 2 then
                -- 集满一篮，删除4个模型
                for k, v in pairs(nameTable) do
                    local fruit = GetEntity(v)
                    fruit:Destroy()
                end
                broadcast("playGetStar")
                broadcast("getMultipleSatr", 3)
            end
        end
    end
    -- print(childEntity.filename)
    if childEntity.childLinks and #childEntity.childLinks > 0 then
        for k, v in pairs(childEntity.childLinks) do
            getFilenames(v)
        end
    end
end

registerBroadcastEvent("onMountCheckFruits", function(msg)
    msg = commonlib.totable(msg)
    -- basket entity name
    local basketEntity = GetEntity("20221026T080452.976539-376")
    local mountedEntity = GetEntity(msg.mountedEntityName)
    if mountedEntity then
        fruitNum = 0
        nameTable = {}
        mountedEntity:SetOnMountEvent("onMountCheckFruits")
        basketEntity:ForEachChildLinkEntity(function(childEntity)
            getFilenames(childEntity)
        end)
    end
end)
