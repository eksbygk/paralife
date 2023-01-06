local firewood = "blocktemplates/b51.bmax"
local fire = "character/particles/fire5/fire5.x"
local corn = "blocktemplates/b54.bmax"
local cookedCorn = "blocktemplates/b53.bmax"
local burntCorn = "blocktemplates/b52.bmax"

local hasFire = false
local function setPitch(entity)
    -- for i = 1, 2 do
    for i = 0, 20 do
        entity:SetPitch(i * math.pi / 180)
        wait(0.01)
    end
    for i = 20, -20, -1 do
        entity:SetPitch(i * math.pi / 180)
        wait(0.01)
    end
    for i = -20, 0 do
        entity:SetPitch(i * math.pi / 180)
        wait(0.01)
    end
    -- end
end

registerBroadcastEvent("onHoverFirewood", function(msg)
    msg = commonlib.totable(msg)
    local entity = GetEntity(msg.name)
    local hoverEntity = GameLogic.EntityManager.GetEntity(msg.hoverEntityName)
    run(function()
        if entity and hoverEntity then
            if hoverEntity:GetModelFile() == firewood and not hasFire then
                hasFire = true
                local x, y, z = 19887.5, -127, 19946
                local subEntity = entity:CloneMe()
                subEntity:SetModelFile(fire)
                subEntity:SetScaling(2)
                subEntity:SetPosition(x, y, z)
                subEntity:SetOnHoverEvent(nil)
            elseif hasFire and not hoverEntity.hoverFlag then
                hoverEntity.hoverFlag = true
                local hoverFile = hoverEntity:GetModelFile()
                if hoverFile == corn then
                    setPitch(hoverEntity)
                    hoverEntity:SetModelFile(cookedCorn)
                    tip("烤好了（小心烤糊！）")
                    setPitch(hoverEntity)
                elseif hoverFile == cookedCorn then
                    setPitch(hoverEntity)
                    hoverEntity:SetModelFile(burntCorn)
                    tip("烤糊了")
                    setPitch(hoverEntity)
                end
                hoverEntity.hoverFlag = nil
            end
        end
    end)
end)

registerBroadcastEvent("onBeginDragWood", function(msg)
    msg = commonlib.totable(msg)
    local entity = GetEntity(msg.name)
    if entity then
        for i = 1, 30 do
            entity:SetPitch(-i * math.pi / 180)
            wait(0.01)
        end
    end
end)

registerBroadcastEvent("onEndDragWood", function(msg)
    msg = commonlib.totable(msg)
    local entity = GetEntity(msg.name)
    if entity then
        for i = 30, 1, -1 do
            entity:SetPitch(-i * math.pi / 180)
            wait(0.01)
        end
    end
end)
