--@ BeginProperty
--@ SyncDirection=None
boolean hasBall = "false"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number forceX = "12"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number forceY = "5"
--@ EndProperty

--@ BeginEntityEventHandler
--@ Scope=Server
--@ Target=self
--@ EventName=PlayerActionEvent
HandlePlayerActionEvent
{
-- Parameters
local ActionName = event.ActionName
local PlayerEntity = event.PlayerEntity
--------------------------------------------------------

if self.Entity.CurrentMapName ~="BakGame" then
	self.hasBall=false
	self.Enable=false
	return
end

if ActionName == "Attack" and self.hasBall == true then
	self.hasBall = false
	self.Entity.NameTagComponent.FontColor = Color.white
	
    	local parent = self.Entity.Parent
    	local spawnPosition = self.Entity.TransformComponent.Position
    	local attackBall = _SpawnService:SpawnByModelId("model://098a9724-ddcb-49a2-ab4d-83e64ec1460f", "AttackBall", spawnPosition, parent)
	attackBall.AttackBallComponent.team = self.Entity.ExtendPlayerComponent.team


	local vec2 = Vector2(self.forceX*PlayerEntity.PlayerControllerComponent.LookDirectionX,self.forceY)
	attackBall.RigidbodyComponent:SetForce(vec2)
	

end
}
--@ EndEntityEventHandler

