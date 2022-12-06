local customerFiles = {
    "20221116T070825.161275-96", "20221116T070823.417199-95", "20221116T070815.691918-94", "20221115T094050.036108-95",
    "20221115T094230.825009-98"
}

local x, y, z = 19954.69, -128.12, 19894.97
local customerPos = {0, 1, 2, 3, 4}

local foodTable = {
    {
        index = 1,
        name = "煎肉",
        dialog = "blocktemplates/f32.bmax",
        file = "blocktemplates/b31.bmax",
        text = "我想要一盘烤牛排"
    }, {
        index = 2,
        name = "煎蛋",
        dialog = "blocktemplates/f33.bmax",
        file = "blocktemplates/b26.bmax",
        text = "我想要一盘香煎荷包蛋"
    }, {
        index = 3,
        name = "蔬果沙拉",
        dialog = "blocktemplates/f30.bmax",
        file = "blocktemplates/f23.bmax",
        text = "我想要一盘蔬菜沙拉"
    }, {
        index = 4,
        name = "牛奶",
        dialog = "blocktemplates/f31.bmax",
        file = "blocktemplates/f9.bmax",
        text = "我想要一杯牛奶"
    }
}

local checkFoodTable = {
    ["blocktemplates/b31.bmax"] = {
        index = 1,
        price = 20
    },
    ["blocktemplates/b26.bmax"] = {
        index = 2,
        price = 15
    },
    ["blocktemplates/f23.bmax"] = {
        index = 3,
        price = 17
    },
    ["blocktemplates/f9.bmax"] = {
        index = 4,
        price = 13
    }
}

-- 每次打开世界清除上一次的顾客与对话框
for i = 0, 4 do
    local customer = GetEntity("food_customer_" .. i)
    if customer then
        customer:Destroy()
    end
    local dialog = GetEntity("food_customer_" .. i .. "_dialog")
    if dialog then
        dialog:Destroy()
    end
    wait(0.01)
end

function createCustomer()
    local customer = GetEntity(customerFiles[math.random(1, #customerFiles)])
    local posIndex = math.random(1, #customerPos)
    local foodIndex = math.random(1, #foodTable)

    local newCustomerName = "food_customer_" .. customerPos[posIndex]
    local newCustomer = GetEntity(newCustomerName)
    if not newCustomer then
        newCustomer = customer:CloneMe()
        newCustomer:SetName(newCustomerName)
        newCustomer:SetPosition(x, y, z - 1.5 * customerPos[posIndex])
        newCustomer.tag = {
            pos = customerPos[posIndex],
            food = foodIndex
        }
        -- 创建人物头顶气泡 (dialog)
        local dialog = GetEntity(newCustomerName .. "_dialog")
        if dialog then
            dialog:Destroy()
        end
        dialog = newCustomer:CloneMe()
        dialog:SetName(newCustomerName .. "_dialog")
        dialog:SetModelFile(foodTable[foodIndex].dialog)
        dialog:SetOnClickEvent(nil)
        dialog:SetOnMountEvent(nil)
        dialog:SetFacing(90 * math.pi / 180)
        dialog:SetScaling(1.4)
        dialog:SetPitch(1.5 * math.pi)
        dialog:SetPosition(x, y + 3, z - 1.5 * customerPos[posIndex])

        newCustomer:SetOnClickEvent("onClickCustomer")
        newCustomer:SetOnMountEvent("onMountCustomer")
        table.remove(customerPos, posIndex)
    end
end

for i = 1, 3 do
    createCustomer()
end

registerBroadcastEvent("onClickCustomer", function(msg)
    msg = commonlib.totable(msg)
    local entity = GetEntity(msg.name)
    if entity then
        local foodIndex = entity.tag.food
        playText(foodTable[foodIndex].text, nil, 10005)
    end
end)

registerBroadcastEvent("onMountCustomer", function(msg)
    msg = commonlib.totable(msg)
    local entity = GetEntity(msg.name)
    local mountedEntity = GetEntity(msg.mountedEntityName)
    if entity and mountedEntity then
        if (msg.mountname == "" and entity:HasCustomGeosets()) then
            local mountedEntity = GameLogic.EntityManager.GetEntity(msg.mountedEntityName)
            if (mountedEntity) then
                local category = mountedEntity:GetCategory()
                if (category == "customCharItem") then
                    local itemId = mountedEntity:GetStaticTag();
                    local replacedItemId = entity:PutOnCustomCharItem(itemId)
                    if (replacedItemId) then
                        mountedEntity:BecomeCustomCharacterItem(replacedItemId)
                        mountedEntity:SetStaticTag(replacedItemId)

                        local facing = entity:GetFacing()
                        local x, y, z = entity:GetPosition()
                        x = x + math.cos(facing)
                        z = z - math.sin(facing)
                        local x1, y1, z1 = mountedEntity:GetPosition()
                        mountedEntity:SetPosition(x, y1, z)
                        mountedEntity:SetBootHeight(0)
                        mountedEntity:SetPitch(-1.57)
                        mountedEntity:FallDown()
                    else
                        mountedEntity:Destroy()
                    end
                elseif (mountedEntity:GetCanDrag()) then
                    -- take the entity in left hand
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
                end
            end
        end
        local file = mountedEntity:GetModelFile()
        if checkFoodTable[file] and checkFoodTable[file].index == entity.tag.food then
            table.insert(customerPos, entity.tag.pos)
            broadcast("getMoney", checkFoodTable[file].price)
            tip("收入 " .. checkFoodTable[file].price .. "元")
            entity.tag = nil
            entity:Say("正确", 1)
        else
            entity:Say("错误，不会再光顾", 1)

        end
        local dialog = GetEntity(msg.name .. "_dialog")
        wait(1)
        entity:Destroy()
        dialog:Destroy()
        mountedEntity:Destroy()
        wait(0.5)
        createCustomer()
    end
end)
