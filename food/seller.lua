-- 创建对话框
fruitNum = 8
local needFruit = [[
    <div style="width:888px;height:303px;background: url(images/dialog/k5.png)">
        <span style="margin-top:144;margin-left:276;color:#ffffff;font-size:24;"><%=fruitNum%></span>
    </div>
]]

function getHtml(filename)
    local filename = "images/dialog/" .. filename .. ".png"
    local html = string.format([[
        <div style="width:888px;height:303px;background: url(%s)">
        </div>
    ]], filename)
    return html
end

function createDialog(html)
    local dialog = window(html, "_ctb", 0, -50, 888, 300)
    dialog:SetDesignResolution(1800, 300)
    dialog:hide()
    dialog:registerEvent("onmouseup", function(event)
        if event:button() == "left" then
            dialog:hide()
        end
    end)
    return dialog
end

local clickDialog = createDialog(needFruit)
local rightDialog = createDialog(getHtml("k2"))
local wrongDialog = createDialog(getHtml("k3"))

local fristHtml = getHtml("k6")
local fristDialog = window(fristHtml, "_ctb", 0, -50, 888, 300)
fristDialog:SetDesignResolution(1800, 300)
fristDialog:hide()
fristDialog:registerEvent("onmouseup", function(event)
    if event:button() == "left" then
        fristDialog:CloseWindow()
        clickDialog:show()
    end
end)

local isFristClick = true
registerBroadcastEvent("onClickSeller", function(msg)
    msg = commonlib.totable(msg)
    local entity = GetEntity(msg.name)
    if entity then
        if isFristClick then
            isFristClick = false
            playMovie("fruit4", 1, 500, true)
            fristDialog:show()
            playText("小朋友，看到我头上列出的4种成熟的水果类型了吗", nil, 10005)
        else
            clickDialog:show()
            playText("请帮我收集" .. fruitNum .. "个成熟的水果吧，交给我就可以了", nil, 10005)
        end
    end
end)

local ripeFruits = {
    ["blocktemplates/a3.bmax"] = true,
    ["blocktemplates/a7.bmax"] = true,
    ["blocktemplates/a19.bmax"] = true,
    ["blocktemplates/a30.bmax"] = true
}

registerBroadcastEvent("onMountSeller", function(msg)
    msg = commonlib.totable(msg)
    local entity = GetEntity(msg.name)
    local mountedEntity = GetEntity(msg.mountedEntityName)
    if entity and mountedEntity then
        local boneName = "L_Hand"
        local oldEntity = entity:GetLinkChildAtBone(boneName)
        if (oldEntity) then
            mountedEntity:FallDown()
        else
            local x, y, z = entity:GetPosition()
            local aabb = entity:GetInnerObjectAABB()
            local dx, dy, dz = aabb:GetExtendValues()
            mountedEntity:SetPosition(x, y + dy * 2, z)
            mountedEntity:LinkTo(entity, boneName);
        end
        -- do something
        local file = mountedEntity:GetModelFile()
        if ripeFruits[file] then
            playText("谢谢，这是我想要的水果！能帮我再收集一些么？", nil, 10005)
            clickDialog:hide()
            rightDialog:show()
            wrongDialog:hide()
            wait(0.5)
            mountedEntity:Destroy()
            fruitNum = fruitNum - 1
            if fruitNum <= 0 then
                clickDialog:CloseWindow()
                rightDialog:CloseWindow()
                wrongDialog:CloseWindow()
                entity:SetOnMountEvent(nil)
                broadcast("playGetStar")
                broadcast("getMultipleSatr", 3)
                clickDialog = createDialog(getHtml("k1"))
            else
                clickDialog:CloseWindow()
                clickDialog = createDialog(needFruit)
            end
        else
            playText(
                "这不是我想要的，你试试把两个一样的水果叠在一起，叠着叠着，水果就成熟了",
                nil, 10005)
            clickDialog:hide()
            rightDialog:hide()
            wrongDialog:show()
            local x, y, z = entity:GetPosition()
            wait(0.5)
            mountedEntity:SetPosition(x - 1.5, y + 2, z)
            mountedEntity:FallDown()
        end
    end
end)
