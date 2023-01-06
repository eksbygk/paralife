-- Fisher–Yates shuffle 洗牌
local function getRandomCards(cards)
    for i = #cards, 1, -1 do
        local randomIndex = math.random(1, i)
        cards[randomIndex], cards[i] = cards[i], cards[randomIndex]
    end
    return cards
end

local humanCard = {
    {
        file = "blocktemplates/a34.bmax",
        size = 2
    }, {
        file = "blocktemplates/a35.bmax",
        size = 2
    }, {
        file = "blocktemplates/a36.bmax",
        size = 2
    }, {
        file = "blocktemplates/a37.bmax",
        size = 2
    }
}

local checkHumanCard = {
    ["blocktemplates/a34.bmax"] = true,
    ["blocktemplates/a35.bmax"] = true,
    ["blocktemplates/a36.bmax"] = true,
    ["blocktemplates/a37.bmax"] = true
}

local AnimalCard = {
    {
        file = "blocktemplates/a1.bmax",
        size = 2
    }, {
        file = "blocktemplates/a2.bmax",
        size = 2
    }, {
        file = "blocktemplates/a3.bmax",
        size = 3
    }, {
        file = "blocktemplates/a4.bmax",
        size = 2
    }, {
        file = "blocktemplates/a5.bmax",
        size = 2
    }, {
        file = "blocktemplates/a6.bmax",
        size = 2
    }, {
        file = "blocktemplates/a7.bmax",
        size = 2
    }, {
        file = "blocktemplates/a8.bmax",
        size = 2
    }, {
        file = "blocktemplates/a9.bmax",
        size = 2
    }, {
        file = "blocktemplates/a10.bmax",
        size = 2
    }, {
        file = "blocktemplates/a11.bmax",
        size = 2
    }, {
        file = "blocktemplates/a12.bmax",
        size = 2
    }
}

local currentIndex = 1

-- 生成随机4个卡牌（包含一个人类）
local function createCards(currentHumanCard)
    local cards = {}
    AnimalCard = getRandomCards(AnimalCard)
    for i = 1, 3 do
        cards[i] = AnimalCard[i]
    end
    cards[4] = currentHumanCard
    return getRandomCards(cards)
end

-- 更换新的卡牌模型
local function changeCards()
    local cards = createCards(humanCard[currentIndex])
    for i = 1, 4 do
        local entity = GetEntity("item" .. i)
        if entity then
            entity:SetModelFile(cards[i].file)
            entity:SetScaling(cards[i].size)
        end
    end
end
changeCards()
broadcast("startChoose")

registerBroadcastEvent("onClickCard", function(msg)
    msg = commonlib.totable(msg)
    local entity = GetEntity(msg.name)
    if entity then
        local file = entity:GetModelFile()
        if checkHumanCard[file] then
            -- 答对 开始新一轮
            tip("猜对了")
            if currentIndex >= 4 then
                wait(1)
                tip("游戏结束")
                broadcast("endChoose")
            else
                currentIndex = currentIndex + 1
                changeCards()
            end
        else
            tip("答错，重新选")
            changeCards()
        end
    end
end)

