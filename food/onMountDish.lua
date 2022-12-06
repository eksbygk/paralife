local foodFile = {
    ["tomato"] = "blocktemplates/c23.bmax", -- 番茄片
    ["lettuce"] = "blocktemplates/c20.bmax", -- 生菜片
    ["friedEgg"] = "blocktemplates/b27.bmax", -- 煎蛋
    ["roast"] = "blocktemplates/f25.bmax", -- 烤肉（熟）
    ["meat"] = "blocktemplates/f20.bmax", -- 肉（生）
    ["dish"] = "blocktemplates/b28.bmax", -- 餐盘
    ["dishWithLettuce"] = "blocktemplates/f22.bmax", -- 餐盘（装了生菜片）
    ["dishWithTomato"] = "blocktemplates/f24.bmax", -- 餐盘（装了番茄片）
    ["dishWithFriedEgg"] = "blocktemplates/b26.bmax", -- 餐盘（装了煎蛋）
    ["dishWithRoast"] = "blocktemplates/b31.bmax", -- 餐盘（装了熟肉）
    ["dishWithSalad"] = "blocktemplates/f23.bmax" -- 餐盘（装了沙拉）
}

local foodTable = {
    -- 餐盘
    [foodFile["dish"]] = {
        -- 番茄片
        [foodFile["tomato"]] = {
            file = foodFile["dishWithTomato"],
            size = 1.8
        },
        -- 生菜片
        [foodFile["lettuce"]] = {
            file = foodFile["dishWithLettuce"],
            size = 1.8
        },
        -- 煎蛋
        [foodFile["friedEgg"]] = {
            file = foodFile["dishWithFriedEgg"],
            size = 1.8
        },
        -- 烤肉 熟
        [foodFile["roast"]] = {
            file = foodFile["dishWithRoast"],
            size = 1.8
        }
    },
    -- 有番茄片的餐盘
    [foodFile["dishWithTomato"]] = {
        -- 生菜片
        [foodFile["lettuce"]] = {
            file = foodFile["dishWithSalad"],
            size = 1.8
        }
    },
    -- 有生菜片的餐盘
    [foodFile["dishWithLettuce"]] = {
        -- 番茄片
        [foodFile["tomato"]] = {
            file = foodFile["dishWithSalad"],
            size = 1.8
        }
    }
}

registerBroadcastEvent("onMountDish", function(msg)
    msg = commonlib.totable(msg)
    local entity = GetEntity(msg.name)
    local mountedEntity = GetEntity(msg.mountedEntityName)
    if entity and mountedEntity then
        local entityFile = entity:GetModelFile()
        local mountedFile = mountedEntity:GetModelFile()
        if foodTable[entityFile] and foodTable[entityFile][mountedFile] then
            entity:SetModelFile(foodTable[entityFile][mountedFile].file)
            entity:SetScaling(foodTable[entityFile][mountedFile].size)
            mountedEntity:Destroy()
        end
    end
end)
