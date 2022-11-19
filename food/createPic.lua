-- 创建拼图后随机打乱
-- 1. 创建拼图
-- 19948.44 -130.21 19957.81
-- 19948.44 -130.21 19939.06
local picEntity = GetEntity("20221119T124319.906498-394")
if not picEntity then
    tip("拼图原型模型被删除了，需重新创建")
else
    local x, y, z = 19948.44, -130.21, 19957.81
    for style = 1, 2 do
        -- 两种拼图样式
        local index = 0
        for i = 1, 4 do
            for j = 1, 2 do
                index = index + 1
                local subEntity = GetEntity("pic" .. style .. "_" .. index)
                if subEntity then
                    subEntity:Destroy()
                end
                subEntity = picEntity:CloneMe()
                subEntity:SetName("pic" .. style .. "_" .. index)
                -- 8 or 24
                local filenum = 8
                if style == 1 then
                    filenum = 8
                else
                    filenum = 24
                end
                subEntity:SetModelFile("blocktemplates/d" .. index + filenum .. ".bmax")
                subEntity:SetCanDrag(false)
                subEntity.tag = index
                subEntity:SetScaling(5)
                subEntity:SetOnClickEvent("onClickPic")
                subEntity:SetPosition(x + 2.35 * i, y, z - 18.75 * (style - 1) - 2.75 * j)
            end
        end
    end
end

-- 2. 打乱拼图
for style = 1, 2 do
    local picEntitys = {}
    for i = 1, 8 do
        picEntitys[i] = GetEntity("pic" .. style .. "_" .. i)
    end
    -- 打乱6次
    for i = 1, 6 do
        local fristIndex = math.random(1, 8)
        local secondIndex = 0
        repeat
            secondIndex = math.random(1, 8)
        until fristIndex ~= secondIndex
        local x1, y1, z1 = picEntitys[fristIndex]:GetPosition()
        local x2, y2, z2 = picEntitys[secondIndex]:GetPosition()

        picEntitys[fristIndex]:SetPosition(x2, y2, z2)
        picEntitys[secondIndex]:SetPosition(x1, y1, z1)
        picEntitys[fristIndex].tag, picEntitys[secondIndex].tag = picEntitys[secondIndex].tag,
            picEntitys[fristIndex].tag
    end
end
