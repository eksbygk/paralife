-- 功能: 点击药草后，显示介绍对话框，播放介绍语音。第一次点击，获得一颗星星
function getHtml(filename)
    -- 生成介绍对话框的html代码
    local filename = "images/" .. filename .. ".png"
    local html = string.format([[
        <div style="width: 658;height: 163;background: url(%s);">
        </div>
    ]], filename)
    return html
end

local text = {"人参，主治体虚欲脱，肢冷脉微，脾虚食少，久病虚羸",
              "黄莲，治湿热痞满，呕吐吞酸，高热神昏，心烦不寐",
              "三七，治外伤出血，胸腹刺痛，跌扑肿痛。补血益气",
              "冬虫夏草，治腰膝酸痛，久咳虚喘，劳嗽痰血。不孕不育",
              "灵芝，主治心神不宁，失眠心悸，肺虚咳喘，虚劳短气，",
              "补骨脂，治肾阳不足、遗尿尿频、腰膝冷痛、五更泄泻；",
              "枸杞，主治腰膝酸痛、眩晕耳鸣、内热消渴、目昏不明。",
              "金佛手，治慢性胃炎、消化不良、脾胃虚弱、食欲不佳、",
              "白芍，主治养血调经，敛阴止汗，柔肝止痛，平抑肝阳",
              "麦冬，治喉痹咽痛，津伤口渴，内热消渴，心烦失眠，"}

-- 创建对话框的函数
function createDialog(html)
    local dialog = window(html, "_ct", -329, 100, 658, 163)
    dialog:SetDesignResolution(1800, 300)
    dialog:hide()
    dialog:registerEvent("onmouseup", function(event)
        if event:button() == "left" then
            dialog:hide()
        end
    end)
    return dialog
end

-- 创建10个对话框，存入herbDialogs数组中，isClicked数组记录是否已经点击过
local herbDialogs = {}
local isClicked = {}
for i = 1, 10, 1 do
    local html = getHtml("a" .. i)
    local dialog = createDialog(html)
    herbDialogs[i] = dialog
    isClicked[i] = false
end

-- 对象（打勾小图标）被克隆后，设置位置和朝向，data由克隆事件传入
registerCloneEvent(function(data)
    setPos(data[1] + 0.5, data[2] + 2, data[3] + 0.5)
    setActorValue("facing", data[4])
end)

-- 点击打勾小图标，显示提示已获得星星
registerClickEvent(function()
    tip("已收集星星")
end)

-- 点击药草，显示对话框，播放语音，第一次点击，获得星星
registerBroadcastEvent("onClickHerb", function(msg)
    msg = commonlib.totable(msg)
    local entity = GetEntity(msg.name)
    if entity then
        local tag = commonlib.totable(entity.tag)
        local herbIndex = tonumber(tag.index)
        playText(text[herbIndex], nil, 10005)
        if not isClicked[herbIndex] then
            broadcast("getStar")
            isClicked[herbIndex] = true
            local x, y, z = entity:GetBlockPos()
            local fac = entity:GetFacing() * 180 / math.pi
            clone("myself", {x, y, z, tag.fac})
        end
        herbDialogs[herbIndex]:show()
        -- 9秒后自动隐藏对话框
        wait(9)
        herbDialogs[herbIndex]:hide()
    end
end)
