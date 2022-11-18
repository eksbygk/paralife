-- 一篮水果换星星
local ripeFruits = {
    ["blocktemplates/a3.bmax"] = true,
    ["blocktemplates/a7.bmax"] = true,
    ["blocktemplates/a19.bmax"] = true,
    ["blocktemplates/a30.bmax"] = true
}

local fruitNum = 0

function getFilenames(childEntity)
    local file = childEntity.filename
    if ripeFruits[file] then
        fruitNum = fruitNum + 1
        -- print(fruitNum)
        if fruitNum >= 4 then
            tip("一筐成熟的水果")
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
        mountedEntity:SetOnMountEvent("onMountCheckFruits")
        basketEntity:ForEachChildLinkEntity(
            function(childEntity)
                getFilenames(childEntity)
            end)
    end
end)
