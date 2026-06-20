local squapi = require("scripts/libs/SquAPI")
local tailPhysics = require("scripts/libs/tail")
local AW = require("scripts/ActionWheel")

vanilla_model.PLAYER:setVisible(false)
vanilla_model.CAPE:setVisible(false)

local tail = {
    models.models.tail.Tail.Tail1,
    models.models.tail.Tail.Tail1.Tail2,
    models.models.tail.Tail.Tail1.Tail2.Tail3,
    models.models.tail.Tail.Tail1.Tail2.Tail3.Tail4,
    models.models.tail.Tail.Tail1.Tail2.Tail3.Tail4.Tail5,
    models.models.tail.Tail.Tail1.Tail2.Tail3.Tail4.Tail5.Tail6,
    models.models.tail.Tail.Tail1.Tail2.Tail3.Tail4.Tail5.Tail6.Tail7,
    models.models.tail.Tail.Tail1.Tail2.Tail3.Tail4.Tail5.Tail6.Tail7.Tail8,
}

models.models.crown:moveTo(models.models.model.root.torso.Head)
local crown = models.models.model.root.torso.Head.crown

local tailModel = tailPhysics.new(models.models.tail.Tail.Tail1)
tailModel:setConfig {
    idleSpeed = vec(0.05, 0.01, 0.2),
    idleStrength = vec(2, 0.1, 8),
    walkSpeed = vec(.05, 0, 0.75),
    walkStrength = vec(0.2, 0.05, 1),
    bounce = 0.1,
    stiff = 1,
}

squapi.eye:new(
    models.models.model.root.torso.Head.Eyes.PupilLeft,
    1.2, 0.25, 0.5, 0.5
)
squapi.eye:new(
    models.models.model.root.torso.Head.Eyes.PupilRight,
    0.25, 1.2, 0.5, 0.5
)

squapi.smoothHead:new(
    {
      models.models.model.root.torso,
    	models.models.model.root.torso.Head --element(you can have multiple elements in a table)
    },
	{
		0.15,
		1
	},    --(1) strength(you can make this a table too)
    0.1,    --(0.1) tilt
    1,    --(1) speed
    nil,    --(true) keepOriginalHeadPos
    false,     --(true) fixPortrait
    nil,     --(nil) animStraightenList
    nil,     --(0.5) straightenMultiplier
    nil,     --(0.5) straightenSpeed
    nil     --(0.1) blendToConsiderStopped
)

squapi.ear:new(
 models.models.model.root.torso.Head.CatEars.leftEar3,
 models.models.model.root.torso.Head.CatEars.rightEar3,
 1, --(1) rangeMultiplier
 true, --(false) horizontalEars
 1, --(2) bendStrength
 true, --(true) doEarFlick
 300, --(400) earFlickChance
 0.1, --(0.1) earStiffness
 0.8  --(0.8) earBounce
)

squapi.randimation:new(
    animations["models.model"].blink,
    nil,    --(100) minTime
    nil,    --(300) maxTime
    true     --(false) stopOnSleep
)

local head = models.models.model.root.torso.Head
models.models.tail:moveTo(models.models.model.root.torso.Body)
models.models.plushe:moveTo(head)
head.plushe:setVisible(false)
head.plushe:setScale(0.5, 0.5, 0.5)
head.plushe:setPos(0, 17, 3)

local standardLeftEarRot = vec(-29.4084, -6.2127, -95.8681)
local standardRightEarRot = vec(-29.4084, 6.2127, 95.8681)

local lowLeftEarRot = vec(14.3745082811, 9.8757288844, -21.4548198683)
local lowRightEarRot = vec(14.3745082811, -9.8757288844, 21.4548198683)

local difPosEar = vec(0, -0.6, 0.5)


local leftEar = models.models.model.root.torso.Head.CatEars.leftEar3
local rightEar = models.models.model.root.torso.Head.CatEars.rightEar3

local function moveEars(delta)
  if player:isCrouching() then
    leftEar:setRot(math.lerp(leftEar:getRot(), lowLeftEarRot, delta))
    rightEar:setRot(math.lerp(rightEar:getRot(), lowRightEarRot, delta))
    models.models.model.root.torso.Body.tail.Tail:setRot(math.lerp(models.models.model.root.torso.Body.tail.Tail:getRot(), vec(120, 0, 0), delta))
  else
    leftEar:setRot(math.lerp(leftEar:getRot(), standardLeftEarRot, delta))
    rightEar:setRot(math.lerp(rightEar:getRot(), standardRightEarRot, delta))
    models.models.model.root.torso.Body.tail.Tail:setRot(math.lerp(models.models.model.root.torso.Body.tail.Tail:getRot(), vec(60, 0, 0), delta))
  end
end

function events.entity_init()

end

--tick event, called 20 times per second
function events.tick()
  --code goes here
end

function events.render(delta, context)
  moveEars(delta / 5)
end
