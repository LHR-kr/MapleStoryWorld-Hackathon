--@ BeginProperty
--@ SyncDirection=All
boolean isMyTurn = "false"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number groundedTileIdx = "0"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
Entity rullet = "45b337b3-3a39-4a89-8000-3827870437b5"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
Entity setPlayerTurn = "abeb48b6-d49f-4876-b80d-bb8ebacfd8c9"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
Entity minigameManager = "489ce5d2-dbc7-4336-ada8-f6be82eccb87"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity rulletUIGroup = "77c68510-efc4-428e-ab2a-ea38a64fa0f0"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity rulletUIText = "1610cb98-249e-40db-ab79-0d1db58b11f6"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=Client
void SetEnableRulletUIGruop()
{
self.rulletUIGroup.Enable = true
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Client
void SetDisableRulletUIGroup()
{
self.rulletUIGroup.Enable = false
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Client
void ChangeRulletUIText(string team)
{
if team == "red" then
	self.rulletUIText.TextComponent.Text = "레드팀이 승리하였습니다."
elseif team == "blue" then
	self.rulletUIText.TextComponent.Text = "블루팀이 승리하였습니다."
end
}
--@ EndMethod

--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=self
--@ EventName=TriggerEnterEvent
HandleTriggerEnterEvent
{
-- Parameters
local TriggerBodyEntity = event.TriggerBodyEntity
--------------------------------------------------------


if TriggerBodyEntity.TileComponent == nil then
	return
end

self.groundedTileIdx = TriggerBodyEntity.TileComponent.idx
}
--@ EndEntityEventHandler

--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=self
--@ EventName=TriggerLeaveEvent
HandleTriggerLeaveEvent
{
-- Parameters
local TriggerBodyEntity = event.TriggerBodyEntity
--------------------------------------------------------
if TriggerBodyEntity.TileComponent == nil then
	return
end

self.groundedTileIdx = nil
}
--@ EndEntityEventHandler

--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=self
--@ EventName=TriggerStayEvent
HandleTriggerStayEvent
{
-- Parameters
local TriggerBodyEntity = event.TriggerBodyEntity
--------------------------------------------------------
if TriggerBodyEntity.TileComponent == nil then
	return
end

self.groundedTileIdx = TriggerBodyEntity.TileComponent.idx
}
--@ EndEntityEventHandler

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


if ActionName == "Attack" and self.Entity.CurrentMapName=="RulletGame"then
	
		--공격한 플레이어가 공격권이 있는지 검사
	if self.isMyTurn == false then
		return
	end
	
	-- 현재 플레이어악 발고 있는 발판의 번호
	local tileIdx = self.groundedTileIdx 
	
	
	--path가 tileN.0 이런 식으로 반환되어서 끝의 두 글자 삭제해줘야 함
	local groundedTileEntityPath = "/maps/RulletGame/tile"..tostring(tileIdx)
	groundedTileEntityPath = groundedTileEntityPath:sub(1,-3)
	
	
	--현재 플레이어가 밝고 있는 발판 엔티티
	local groundedTileEntity = _EntityService:GetEntityByPath(groundedTileEntityPath)
	
	--공격권이 있는 플레이어가 밟고 있는 발판이 이미 사용된 건지 검사
	if groundedTileEntity.TileComponent.isUsed == true then
		return
	end
	
	
	-- 룰렛의 트리거 발판 번호
	local triggerTileIdx = self.rullet.RulletComponent.triggerTileIndex
	
	--사용한 발판으로 만들고 색 변화
	groundedTileEntity.TileComponent.isUsed = true
	groundedTileEntity.SpriteRendererComponent.Color = Color.red
	
	--효과음 재생
	_SoundService:PlaySound(" 41bf0f6f8d4945958183f7fca798a226",1)
	
	-- 현재 밟고 있는 발판에 속한 sword entity
	local swordEntityPath = groundedTileEntityPath.."/sword"..tostring(tileIdx)
	swordEntityPath = swordEntityPath:sub(1,-3)
	
	local sword =  _EntityService:GetEntityByPath(swordEntityPath)
	sword.Visible = true
		
	log("RulletGamePlayercomponent. hit tile is "..tostring(tileIdx))
	log("RulletGamePlayercomponent. the target tile is "..tostring(triggerTileIdx))
	
	if tileIdx == triggerTileIdx then
		log("RulletGamePlayercomponent. game is done")
		--터짐
		_SoundService:PlaySound("89fe1a53c0fb48bcb3293cad3301b157",1)
		wait(0.2)
		local animation = _EntityService:GetEntity("104c5f4a-d4a6-42e2-9c97-ac1b25862a74")
		
		animation.Visible = true
		
	
		
		
		if self.Entity.ExtendPlayerComponent.team == "red" then
			--레드팀이면 블루팀에게 점수 줌
			self:SetEnableRulletUIGruop()
			self:ChangeRulletUIText("blue")
			wait(3)
			self:SetDisableRulletUIGroup()
			self.minigameManager.MinigameManagerComponent:MinigameEnd(0,100)
		else 
			self:SetEnableRulletUIGruop()
			self:ChangeRulletUIText("red")
			wait(3)
			self:SetDisableRulletUIGroup()
			self.minigameManager.MinigameManagerComponent:MinigameEnd(100,0)
		end
			
		
		
	end
	
	
	
	--다음 플레이어에게 공격권 부여
	self.setPlayerTurn.SetPlayerTurnComponent:SetPlayerTurn()
	
end
}
--@ EndEntityEventHandler

