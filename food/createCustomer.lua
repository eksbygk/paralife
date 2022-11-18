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
        file = "blocktemplates/b31.bmax"
    }, {
        index = 2,
        name = "煎蛋",
        file = "blocktemplates/b26.bmax"
    }, {
        index = 3,
        name = "蔬果沙拉",
        file = "blocktemplates/c20.bmax"
    }, {
        index = 4,
        name = "牛奶",
        file = "blocktemplates/f9.bmax"
    }
}

local checkFoodTable = {
    ["blocktemplates/b31.bmax"] = {
        index = 1
    },
    ["blocktemplates/b26.bmax"] = {
        index = 2
    },
    ["blocktemplates/c20.bmax"] = {
        index = 3
    },
    ["blocktemplates/f9.bmax"] = {
        index = 4
    }
}

function createCustomer()
    local customer = GetEntity(customerFiles[math.random(1, #customerFiles)])
    local posIndex = math.random(1, #customerPos)
    local foodIndex = math.random(1, #foodTable)
    local newCustomer = customer:CloneMe()
    -- broadcast("createFood", customerPos[posIndex])
    newCustomer:SetPosition(x, y, z - 1.5 * customerPos[posIndex])
    newCustomer.tag = {
        pos = customerPos[posIndex],
        food = foodIndex
    }
    newCustomer:Say(foodTable[foodIndex].name, 9999)
    newCustomer:SetOnClickEvent("onClickCustomer") -- 上线前删掉这句！
    newCustomer:SetOnMountEvent("onMountCustomer")
    table.remove(customerPos, posIndex)
end

for i = 1, 3 do
    createCustomer()
    -- 手动延迟，广播接收有问题
    -- wait(0.1)
end

-- 上线前删掉这个方法！
registerBroadcastEvent("onClickCustomer", function(msg)
    msg = commonlib.totable(msg)
    local entity = GetEntity(msg.name)
    if entity then
        -- table.insert(customerPos, entity.tag.pos)
        -- entity.tag = nil
        entity:Destroy()
        -- wait(1)
        -- createCustomer()
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
            -- broadcast("deleteFood", entity.tag)
            entity.tag = nil
            entity:Say("正确", 1)
        else
            entity:Say("错误，不会再光顾", 1)

        end
        wait(1.5)
        entity:Destroy()
        mountedEntity:Destroy()
        wait(1)
        createCustomer()
    end
end)
