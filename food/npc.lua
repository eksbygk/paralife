hide()

local posTable = {{
    pos = {19197.5, 3, 19146.5},
    animNum = 163
}, {
    pos = {19206, 3, 19151},
    animNum = 163
}, {
    pos = {19190, 3, 19185},
    animNum = 163
}, {
    pos = {19187.5, 3, 19144.8},
    animNum = 158
}, {
    pos = {19198.5, 4.2, 19177.2},
    animNum = 163
}, {
    pos = {19193, 3, 19182},
    animNum = 72
}, {
    pos = {19197.3, 4.2, 19178.5},
    animNum = 78
}}

registerCloneEvent(function(index)
    local pos = posTable[index].pos
    local animNum = posTable[index].animNum
    setActorValue("index", index)
    setActorValue("movieactor", index)
    setActorValue("x", pos[1])
    setActorValue("y", pos[2])
    setActorValue("z", pos[3])

    registerClickEvent(function()
        broadcast("showDialog", getActorValue("index"))
        moveForward(0, 10)
    end)
    if index <= 3 then
        while true do
            anim(4)
            moveForward(2, 2)
            turn(90)
            anim(158)
            wait(math.random(3, 8))
            turn(90)
            anim(4)
            moveForward(2, 2)
            turn(180)
        end
    else
        if index == 7 then
            turn(90)
        end
        while true do
            anim(animNum or 0)
        end
    end
end)

for i = 1, 7 do
    clone("myself", i)
end
