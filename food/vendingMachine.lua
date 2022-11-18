-- 自动售货机 冒烟特效
local smoke = "character/CC/05effect/V5/KTwu/KT_WU.x"

registerBroadcastEvent("onClickVendingMachine", function(msg)
    msg = commonlib.totable(msg)
    local entity = GetEntity(msg.name)
    if entity then
        local x, y, z = entity:GetPosition()
        local dir = 1
        for i = 1, 4 do
            dir = -dir
            for j = 1, 5 do
                x = x + 0.005 * j * dir
                entity:SetPosition(x, y, z)
                wait(0.01)
            end
        end

        local smokeEntity = entity:CloneMe()
        smokeEntity:SerModelFile(smoke)
        smokeEntity:SetScaling(2)
        smokeEntity:SetPosition(x - 1, y + 2, z + 0.5)
        wait(1)
        smokeEntity:Destroy()
    end
end)
