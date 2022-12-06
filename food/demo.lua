registerBroadcastEvent("onClickEvent", function(msg)
    msg = commonlib.totable(msg)
    local entity = GetEntity(msg.name)
    if entity then
        -- do something
    end
end)

html = [[<div style="width: 1834px;height: 337px;background: url(images/dialog3-0.png);">
        <div style="margin-top: 200px;margin-left: 500px;width:1134px;height:28px;background: url(images/dialog3-3.png);"></div>
    </div>]]

local dialog = window(html, "_ctb", 0, 0, 1834, 337)
dialog:SetDesignResolution(1834, 337)
dialog:registerEvent("onmouseup", function(event)
    if event:button() == "left" then
        dialog:CloseWindow()
    end
end)

local rightBottom = [[
    <div onclick="onClickNav" param="square" style="width:110px;height:60px;background: url(images/navigation/8.png)">
    </div>
]]

window(rightBottom, "_rb", -120, -70, 300, 100)

function onClickNav(i, mcmlNode)
    local nav = mcmlNode:GetAttribute("param")
    print(nav)
end

registerBroadcastEvent("onMountCountingBoard", function(msg)
    msg = commonlib.totable(msg)
    local entity = GetEntity(msg.name)
    local mountedEntity = GetEntity(msg.mountedEntityName)
    if entity and mountedEntity then
    end
end)

registerBroadcastEvent("onHoverEvent", function(msg)
    msg = commonlib.totable(msg)
    local entity = GetEntity(msg.name)
    local hoverEntity = GameLogic.EntityManager.GetEntity(msg.hoverEntityName)
    if entity and hoverEntity then
        -- do something
    end
end)

-- API

registerBroadcastEvent("onMountEvent", function(msg)
    msg = commonlib.totable(msg)
    local entity = GetEntity(msg.name)
    local mountedEntity = GetEntity(msg.mountedEntityName)
    if entity then
        mountedEntity = entity:CloneMe()
        mountedEntity:SetName()
        mountedEntity:SetModelFile()
        mountedEntity:SetOnClickEvent(nil)
        mountedEntity:SetOnMountEvent(nil)
        mountedEntity:SetCanDrag(false)
        mountedEntity:EnablePhysics(false) -- 物理模型
        mountedEntity:SetScaling(1)
        mountedEntity:SetFacing(mountedEntity:GetFacing() + math.pi)
        mountedEntity:SetFacing(95 * 3.14 / 180)
        mountedEntity:SetFacing(95 * math.pi / 180)
        local x, y, z = mountedEntity:GetPosition()
        local x, y, z = mountedEntity:SetBlockPos() -- 方块坐标
        mountedEntity:SetPosition(x, y - 2.6, z - 0.2)
        mountedEntity:FallDown()

        mountedEntity:Destroy()
    end
end)
