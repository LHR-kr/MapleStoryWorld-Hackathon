--@ BeginProperty
--@ SyncDirection=All
number rotateAnglePerSecond = "360"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number time = "0"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
Entity minigameManager = "a86715ae-3754-40af-9cec-4c2c23686c2a"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
string team = ""red""
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void OnBeginPlay()
{
--[[
local transform = self.Entity.TransformComponent
    self.posX = transform.Position.x
    self.posY = transform.Position.y

    local yDestination = 0.3
    local tweenDuration = 3

    local xTween = _TweenLogic:PlayTween(self.posX, self.posX + math.random(40, 100)/10, tweenDuration, EaseType.CubicEaseOut, function(val) self.posX = val end)
    local yTween1 = _TweenLogic:PlayTween(self.posY, yDestination, tweenDuration, EaseType.BounceEaseOut, function(val) self.posY = val end)

    local rotateTween = _TweenLogic:RotateTo(self.Entity, -1800 * math.random(95, 105)/100, tweenDuration, EaseType.QuartEaseOut)
]]

}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void OnUpdate(number delta)
{
--[[
--  프레임마다 변경되는 posX, PosY 프로퍼티 값을 TransformComponent.Position에 할당
    local transform = self.Entity.TransformComponent
    transform.Position = Vector3(self.posX, self.posY, transform.Position.z)
]]




self.Entity.TransformComponent:Rotate(self.rotateAnglePerSecond*delta)

self.time = self.time + delta 

if self.time >= 4 then
	self.Entity:Destroy()
end


}
--@ EndMethod

--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=self
--@ EventName=FootholdCollisionEvent
HandleFootholdCollisionEvent
{
-- Parameters
local FootholdNormal = event.FootholdNormal
local ImpactDir = event.ImpactDir
local ImpactForce = event.ImpactForce
local ReflectDir = event.ReflectDir
local Rigidbody = event.Rigidbody
--------------------------------------------------------

self.Entity:Destroy()

}
--@ EndEntityEventHandler

