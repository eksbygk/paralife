local clickTime = 0
local fristEntity = {}

local picToDark = {
    -- 拼图1
    ["blocktemplates/d9.bmax"] = "blocktemplates/d1.bmax",
    ["blocktemplates/d10.bmax"] = "blocktemplates/d2.bmax",
    ["blocktemplates/d11.bmax"] = "blocktemplates/d3.bmax",
    ["blocktemplates/d12.bmax"] = "blocktemplates/d4.bmax",
    ["blocktemplates/d13.bmax"] = "blocktemplates/d5.bmax",
    ["blocktemplates/d14.bmax"] = "blocktemplates/d6.bmax",
    ["blocktemplates/d15.bmax"] = "blocktemplates/d7.bmax",
    ["blocktemplates/d16.bmax"] = "blocktemplates/d8.bmax",
    -- 拼图2
    ["blocktemplates/d25.bmax"] = "blocktemplates/d17.bmax",
    ["blocktemplates/d26.bmax"] = "blocktemplates/d18.bmax",
    ["blocktemplates/d27.bmax"] = "blocktemplates/d19.bmax",
    ["blocktemplates/d28.bmax"] = "blocktemplates/d20.bmax",
    ["blocktemplates/d29.bmax"] = "blocktemplates/d21.bmax",
    ["blocktemplates/d30.bmax"] = "blocktemplates/d22.bmax",
    ["blocktemplates/d31.bmax"] = "blocktemplates/d23.bmax",
    ["blocktemplates/d32.bmax"] = "blocktemplates/d24.bmax"
}

local picToLight = {
    -- 拼图1
    ["blocktemplates/d1.bmax"] = "blocktemplates/d9.bmax",
    ["blocktemplates/d2.bmax"] = "blocktemplates/d10.bmax",
    ["blocktemplates/d3.bmax"] = "blocktemplates/d11.bmax",
    ["blocktemplates/d4.bmax"] = "blocktemplates/d12.bmax",
    ["blocktemplates/d5.bmax"] = "blocktemplates/d13.bmax",
    ["blocktemplates/d6.bmax"] = "blocktemplates/d14.bmax",
    ["blocktemplates/d7.bmax"] = "blocktemplates/d15.bmax",
    ["blocktemplates/d8.bmax"] = "blocktemplates/d16.bmax",
    -- 拼图2
    ["blocktemplates/d17.bmax"] = "blocktemplates/d25.bmax",
    ["blocktemplates/d18.bmax"] = "blocktemplates/d26.bmax",
    ["blocktemplates/d19.bmax"] = "blocktemplates/d27.bmax",
    ["blocktemplates/d20.bmax"] = "blocktemplates/d28.bmax",
    ["blocktemplates/d21.bmax"] = "blocktemplates/d29.bmax",
    ["blocktemplates/d22.bmax"] = "blocktemplates/d30.bmax",
    ["blocktemplates/d23.bmax"] = "blocktemplates/d31.bmax",
    ["blocktemplates/d24.bmax"] = "blocktemplates/d32.bmax"
}

-- function changePicTag(entity)

-- end

function checkPic(entity)
    local pincNameHead = string.sub(entity:GetName(), 1, 5)
    for i = 1, 8 do
        local picEntity = GetEntity(pincNameHead .. i)
        if picEntity.tag ~= i then
            return false
        end
    end
    return true
end

registerBroadcastEvent("onClickPic", function(msg)
    msg = commonlib.totable(msg)
    local entity = GetEntity(msg.name)
    if entity then
        local file = entity:GetModelFile()
        if picToDark[file] then
            entity:SetModelFile(picToDark[file])
        end
        wait(0.05)
        if clickTime >= 2 then
            clickTime = 1
        else
            clickTime = clickTime + 1
        end
        if clickTime == 1 then
            fristEntity = entity
        elseif clickTime == 2 then
            -- 交换tag，使用tag来判断是否复原拼图
            entity.tag, fristEntity.tag = fristEntity.tag, entity.tag

            local file = entity:GetModelFile()
            if picToLight[file] then
                entity:SetModelFile(picToLight[file])
            end
            local fristFile = fristEntity:GetModelFile()
            if picToLight[fristFile] then
                fristEntity:SetModelFile(picToLight[fristFile])
            end
            wait(0.05)
            local x1, y1, z1 = fristEntity:GetPosition()
            local x2, y2, z2 = entity:GetPosition()
            for i = 1, 10 do
                fristEntity:SetPosition(x1 + (x2 - x1) / 10 * i, y2, z1 + (z2 - z1) / 10 * i)
                entity:SetPosition(x2 + (x1 - x2) / 10 * i, y1, z2 + (z1 - z2) / 10 * i)
                wait(0.01)
            end
        end
        -- print(checkPic(entity))
        if checkPic(entity) then
            local style = string.sub(msg.name, 4, 4)
            broadcast("finishPic", style)
            tip("成功复原")
            wait(1)
            broadcast("playGetStar")
            broadcast("getMultipleSatr", 2)
            setBlock(19158, 3, 19167, 0)
            camera(8, 20, 90)
            wait(3)
            setBlock(19158, 3, 19167, 192)
        end
    end
end)
