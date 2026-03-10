local AW = {}

local helmetSwitch = config:load("helmetSwitch")
local armorSwitch = config:load("armorSwitch")

local mainPage = action_wheel:newPage()

action_wheel:setPage(mainPage)

local togglePlushe = mainPage:newAction()
    :setToggleColor(vectors.hexToRGB("#ff7e00"))
    :setTitle("Плюшка")

local toggleArmor = mainPage:newAction()
    :setItem("minecraft:iron_chestplate")
    :setToggleColor(0, 1, 0)
    :setToggleTitle("Броня включена")
    :setColor(1, 0, 0)
    :setTitle("Броня выключена")
    :setToggled(armorSwitch)

local toggleHelmet = mainPage:newAction()
    :setItem("minecraft:iron_helmet")
    :setToggleColor(0, 1, 0)
    :setToggleTitle("Шлем включен")
    :setColor(1, 0, 0)
    :setTitle("Шлем выключен")
    :setToggled(helmetSwitch)

function pings.clickPlusheSwitch(state)
    models.models.model.root.torso.Head.plushe:setPrimaryTexture("PRIMARY")
    models.models.model.root.torso.Head.plushe:setVisible(state)
end

local function getPlusheTexture()
    local tex
    for k, v in pairs(textures:getTextures()) do
        if v:getName():find("plusheTexture") then
            tex = textures:copy("PlusheIcon", v)

            for x = 0, 7 do
                for y = 0, 7 do
                    local pixel = tex:getPixel(40 + x, 8 + y)
                    if pixel[4] ~= 0 then
                        tex:setPixel(8 + x, 8 + y, pixel)
                    end
                end
            end
        end
    end
    return tex
end

togglePlushe:setOnToggle(pings.clickPlusheSwitch)
    :setTexture(getPlusheTexture(), 8, 8, 8, 8, 2)

function pings.clickArmorSwitch(state)
    vanilla_model.ARMOR:setVisible(state)
    armorSwitch = state
    config:save("armorSwitch", armorSwitch)
    if not helmetSwitch then
        vanilla_model.HELMET:setVisible(helmetSwitch)
    end
end

function pings.clickHelmetSwitch(state)
    vanilla_model.HELMET:setVisible(state)
    helmetSwitch = state
    config:save("helmetSwitch", helmetSwitch)
end

toggleArmor:setOnToggle(pings.clickArmorSwitch)
toggleHelmet:setOnToggle(pings.clickHelmetSwitch)

return AW