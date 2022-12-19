--@ BeginProperty
--@ SyncDirection=All
number hp = "0"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
Entity MinigameManager = "a86715ae-3754-40af-9cec-4c2c23686c2a"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity bakUIGroup = "c94fd01f-3ba5-4fc4-b127-3a40e4b9c203"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity bakWinnerUIText = "627c3ee1-a445-4019-a8e7-1efa4be141eb"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void OnBeginPlay()
{
math.randomseed(os.time())

--self.hp = 1
self.hp = math.random(7,10)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Client
void SetEnableBakUIGroup()
{
self.bakUIGroup.Enable = true
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Client
void SetDisableBakUIGroup()
{
self.bakUIGroup.Enable = false
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Client
void ChangeWinnerUIText(string team)
{
if team == "red" then
	self.bakWinnerUIText.TextComponent.Text = "레드팀이 승리하였습니다"
else 
	self.bakWinnerUIText.TextComponent.Text = "블루팀이 승리하였습니다"
end
}
--@ EndMethod

--@ BeginEntityEventHandler
--@ Scope=Server
--@ Target=self
--@ EventName=TriggerEnterEvent
HandleTriggerEnterEvent
{
-- Parameters
local attackBall = event.TriggerBodyEntity
--------------------------------------------------------



--충돌한 엔티티가  공격용 공이 아닐 경우 함수 종료
if attackBall.AttackBallComponent == nil then
	return
end

--박의 체력 깎고
self.hp = self.hp-1
--공격용 공 destory

-- 타격음 재생
_SoundService:PlaySound("50c95260aa524be6b7bb9eeb48a30ec2",1)

--막타 처리
if self.hp == 0 then 
	self.Entity.TweenCircularComponent.Enable = false
	self.Entity.TriggerComponent.Enable =false
	self.Entity.SpriteRendererComponent.SpriteRUID = "d927eb4175b34fd3ab55b52e55f4f1a8"
	_SoundService:PlaySound("5b01b8fb528043f99d574bdd8e7317c2",1)
	
	--레드팀 승리
	if attackBall.AttackBallComponent.team == "red" then
		self:SetEnableBakUIGroup()
		self:ChangeWinnerUIText("red")
		wait(3)
		self:SetDisableBakUIGroup()		
		self.MinigameManager.MinigameManagerComponent:MinigameEnd(100,0) 
	--블루팀 승리
	else 
		self:SetEnableBakUIGroup()
		self:ChangeWinnerUIText("blue")
		wait(3)
		self:SetDisableBakUIGroup()		
		self.MinigameManager.MinigameManagerComponent:MinigameEnd(0,100)
	end
	
end
attackBall:Destroy()

}
--@ EndEntityEventHandler

