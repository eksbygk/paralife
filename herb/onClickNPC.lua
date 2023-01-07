-- 功能：与NPC李时珍的对话
-- 描述：点击NPC李时珍，触发对话。共创建三个对话框，每次点击对话框，触发下一个对话框

function getHtml(filename)
    local filename = "images/" .. filename .. ".png"
    local html = string.format([[
        <div style="width: 658;height: 163;background: url(%s);">
        </div>
    ]], filename)
    return html
end

function createDialog(html)
    local dialog = window(html, "_ct", -329, 100, 658, 163)
    dialog:SetDesignResolution(1400, 300)
    dialog:hide()
    return dialog
end

local texts = {"在公元1518年的湖北，我，横空出世了!",
               "我的名字叫李时珍，平日里我非常喜欢研究医药。",
               "这位小同学,你看过我写的本草纲目吗？"}
local npcDialogs = {}
for i = 1, 3, 1 do
    local html = getHtml(i)
    local dialog = createDialog(html)
    npcDialogs[i] = dialog
    npcDialogs[i]:registerEvent("onmouseup", function(event)
        if event:button() == "left" then
            npcDialogs[i]:hide()
            if npcDialogs[i + 1] then
                npcDialogs[i + 1]:show()
                playText(texts[i + 1], nil, 1)
            end
        end
    end)
end

registerBroadcastEvent("onClickNPC", function(msg)
    msg = commonlib.totable(msg)
    local entity = GetEntity(msg.name)
    if entity then
        npcDialogs[1]:show()
        playText(texts[1], nil, 1)
    end
end)
