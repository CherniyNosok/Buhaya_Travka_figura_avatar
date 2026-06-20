local AW = {}
local SyncLib = require("scripts.libs.SyncLib")

local sync = SyncLib.new({interval = 100})

-- local helmetSwitch = config:load("helmetSwitch")
-- local armorSwitch = config:load("armorSwitch")

sync:register("helmet", true, SyncLib.BOOLEAN, function(visible)
    vanilla_model.HELMET:setVisible(visible)
end)
sync:register("armor", true, SyncLib.BOOLEAN, function(visible)
    vanilla_model.ARMOR:setVisible(visible)
end)
sync:register("plushe", false, SyncLib.BOOLEAN, function(visible)
    if models.models.model.root.torso.Head.plushe ~= nil then
        models.models.model.root.torso.Head.plushe:setPrimaryTexture("PRIMARY")
        models.models.model.root.torso.Head.plushe:setVisible(visible)
    end
end)

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

local toggleHelmet = mainPage:newAction()
    :setItem("minecraft:iron_helmet")
    :setToggleColor(0, 1, 0)
    :setToggleTitle("Шлем включен")
    :setColor(1, 0, 0)
    :setTitle("Шлем выключен")

function pings.clickPlusheSwitch()
    models.models.model.root.torso.Head.plushe:setPrimaryTexture("PRIMARY")
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

togglePlushe:setOnToggle(function(visible)
    pings.clickPlusheSwitch()
    sync:set("plushe", visible)
end)
    :setTexture(getPlusheTexture(), 8, 8, 8, 8, 2)

local function clickArmorSwitch(state)
    sync:set("armor", state)
    if not sync:get("helmet") then
        sync:toggle("helmet")
    end
end

local function clickHelmetSwitch(state)
    sync:set("helmet", state)
end

toggleArmor:setOnToggle(clickArmorSwitch)
toggleHelmet:setOnToggle(clickHelmetSwitch)


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

sync:register("crownSwitch", false, SyncLib.BOOLEAN, function(visible)
    if models.models.model.root.torso.Head.crown ~= nil then
        models.models.model.root.torso.Head.crown:setVisible(visible)
    end
end)
sync:register("crownInd", 1, SyncLib.INT8, function(id)
    local crownType = CrownTextures[CrownTextures:getKeys()[id]]
    models.models.model.root.torso.Head.crown:setPrimaryTexture("CUSTOM", getTextures(crownType[1])["texture"])
end)

local crownSwitch = sync:get("crownSwitch")
local crownInd = sync:get("crownInd")
local crownType = CrownTextures[CrownTextures:getKeys()[crownInd]]

local switchCrownType = mainPage:newAction()
    :setTexture(getTextures(crownType[1])["icon"], 16, 16, 16, 16)
    :setTitle(crownType[2].."\n:ЛКМ - вкл/выкл\n:ПКМ - выбор типа")
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
        :setTitle(tmpType[2].."\n:ЛКМ - вкл/выкл\n:ПКМ - выбор типа")
end

switchCrownType:onScroll(scrollingCrown)
    :onRightClick(function()
        sync:set("crownInd", crownInd)
    end)
    :onLeftClick(function()
        sync:toggle("crownSwitch")
        if not sync:get("crownSwitch") then
            switchCrownType:setColor(1, 0, 0)
        else
            switchCrownType:setColor(0, 1, 0)
        end
    end)


function events.entity_init()
    sync:init()

    toggleArmor:setToggled(sync:get("armor"))
    toggleHelmet:setToggled(sync:get("helmet"))
    togglePlushe:setToggled(sync:get("plushe"))

    if not sync:get("crownSwitch") then
        switchCrownType:setColor(1, 0, 0)
    else
        switchCrownType:setColor(0, 1, 0)
    end
end

function events.tick()
    sync:tick()
end

return AW