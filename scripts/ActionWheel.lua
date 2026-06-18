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


-- Изменение венка

-- Список текстур венков
---@enum CrownTextures
local CrownTextures = {
    ALLIUM = {"allium", "Лук"},
    AZALEA = {"azalea", "Азалия"},
    AZURE_BLUET = {"azure_bluet", "Голубой василек"},
    BLUE_ORCHID = {"blue_orchid", "Голубая орхидея"},
    BUTTERCUP = {"buttercup", "Лютик"},
    CORNFLOWER = {"cornflower", "Василек"},
    DANDELION = {"dandelion", "Одуванчик"},
    LILAC = {"lilac", "Сирень"},
    LILY_OF_THE_VALLEY = {"lily_of_the_valley", "Ландыш"},
    ORANGE_TULIP = {"orange_tulip", "Оранжевый тюльпан"},
    OXEYE_DAISY = {"oxeye_daisy", "Ромашка"},
    PEONY = {"peony", "Пион"},
    PINK_DAISY = {"pink_daisy", "Розовая ромашка"},
    PINK_TULIP = {"pink_tulip", "Розовый тюльпан"},
    POPPY = {"poppy", "Мак"},
    RED_TULIP = {"red_tulip", "Красный тюльпан"},
    ROSE_BUSH = {"rose_bush", "Розовый куст"},
    SUNFLOWER = {"sunflower", "Подсолнух"},
    WHITE_TULIP = {"white_tulip", "Белый тюльпан"},
    WITHER_ROSE = {"wither_rose", "Иссушенная роза"}
}

function CrownTextures:getKeys()
    local keys = {}
    for k, v in pairs(CrownTextures) do
        if k ~= "getKeys" then
            table.insert(keys, k)
        end
    end
    return keys
end

local crownSwitch = config:load("crownSwitch") == nil and false or config:load("crownSwitch")
local crownType = config:load("crownType") == nil and CrownTextures.ALLIUM or config:load("crownType")

local crownInd = 1

---Поиск текстур венка по низванию
---@param name string
---@return {["texture"]: Texture, ["icon"]: Texture}
local function getTextures(name)
    local texs = {
        texture = nil,
        icon = nil
    }
    for k, v in pairs(textures:getTextures()) do
        if v:getName():find(name .. "_crown_icon") then
            texs["icon"] = v 
        elseif v:getName():find(name .. "_crown") then
            texs["texture"] = v
        end
    end
    return texs
end

local switchCrownType = mainPage:newAction()
    :setTexture(getTextures(crownType[1])["icon"], 16, 16, 16, 16)
    :setTitle(crownType[2])
    :setColor((crownSwitch) and vec(0, 1, 0) or vec(1, 0, 0))

local function scrollingCrown(dir)
    if dir > 0 then
        crownInd = crownInd + 1
    else
        crownInd = crownInd - 1
    end

    if crownInd <= 0 then
        crownInd = #CrownTextures:getKeys()
    elseif crownInd > #CrownTextures:getKeys() then
        crownInd = 1
    end

    local tmpType = CrownTextures[CrownTextures:getKeys()[crownInd]]
    switchCrownType:setTexture(getTextures(tmpType[1])["icon"], 16, 16, 16, 16)
        :setTitle(tmpType[2])
end

function pings.lClickCrownSwitch()
    log("Left")
    crownSwitch = not crownSwitch
    models.models.model.root.torso.Head.crown:setVisible(crownSwitch)
    crownSwitch = crownSwitch
    config:save("crownSwitch", crownSwitch)

    if not crownSwitch then
        switchCrownType:setColor(1, 0, 0)
    else
        switchCrownType:setColor(0, 1, 0)
    end
end

function pings.rClickCrownSwitch()
    log("Right")
    crownType = CrownTextures[CrownTextures:getKeys()[crownInd]]
    models.models.model.root.torso.Head.crown:setPrimaryTexture("CUSTOM", getTextures(crownType[1])["texture"])
    config:save("crownType", crownType)
end

switchCrownType:onScroll(scrollingCrown)
    :onRightClick(pings.rClickCrownSwitch)
    :onLeftClick(pings.lClickCrownSwitch)

function events.entity_init()
    models.models.model.root.torso.Head.crown:setVisible(crownSwitch)
    models.models.model.root.torso.Head.crown:setPrimaryTexture("CUSTOM", getTextures(crownType[1])["texture"])
    switchCrownType:setTexture(getTextures(crownType[1])["icon"], 16, 16, 16, 16)
    for i, v in ipairs(CrownTextures:getKeys()) do
        if crownType[1] == string.lower(CrownTextures:getKeys()[i]) then
            crownInd = i
            break
        end
    end
end

return AW