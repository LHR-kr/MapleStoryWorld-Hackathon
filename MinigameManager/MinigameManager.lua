--@ BeginProperty
--@ SyncDirection=None
Entity minigameWaitUIText = "fe6d5be5-6585-45fa-89d9-0e91f8b77f16"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity minigameWaitUIGroup = "0a72c936-bbcd-464b-b635-371cbca1161b"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity minigameSelectorUIGroup = "2acc21d7-9dd1-4ece-be0e-05cb56372d67"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
boolean isStarted = "false"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
boolean isEnded = "false"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
boolean isCountDowned = "false"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number movementSpeed = "1.4"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity minigameEndNoticeUIGroup = "d11196bd-73b7-45d5-8655-2a9b581ca5ff"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity minigameEndNoticeUIText = "0d06c956-27f6-4fb8-98ea-ef6147db962b"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void OnBeginPlay()
{



}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void OnUpdate(number delta)
{
--현재 맵에 들어온 플레이어들
local playersInMap =_UserService:GetUsersByMapName(self.Entity.CurrentMapName) 
local numTotalPlayer = _UserService:GetUserCount()

--게임이 시작되기 전이고, 사람도 아무도 들어오지 않았을 경우 아무 일도 하지 않는다.
if self.isStarted == false and #playersInMap == 0 then
	return
end

-- 게임 시작 전이고, 사람이 있으면 대기 UI text 표시, 이 맵의 플레이어들 조작 불가
if self.isStarted == false and #playersInMap < numTotalPlayer then
	self:SetWaitText()
	
	for idx, playerEntity in ipairs(playersInMap) do
		--이속 0으로 만든다.
		playerEntity.MovementComponent.InputSpeed = 0
	end
	
end



--게임 시작 전인데, 사람 다 들어왔으면 카운트 다운 하고 게임 시작
if self.isStarted == false and #playersInMap == numTotalPlayer and self.isCountDowned == false then
	self.isCountDowned = true
	
	
	for idx, playerEntity in ipairs(playersInMap) do
		--이속 0으로 만든다.
		playerEntity.MovementComponent.InputSpeed = 0
	end
	
	self:SetCountdownText()
	return
end



-- 게임은 끝났지만 아직 사람이 남아 있다.
if self.isEnded == true and #playersInMap > 0 then
	--다음 맵으로 이동하라는 UI 띄움. 이건 나중에
	
end


-- 게임이 끝나고, 아무도 남지 않았으므로 아무 일도 하지 않는다.
if self.isEnded == true and #playersInMap == 0 then
	--혹은 자식 엔티티를 순회하면 전부 disable하게 만드는 코드  추가
	--self.Entity.Enable = false
	return
end

}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Server
void MinigameStart()
{
--현재 맵에 들어온 플레이어들
local playersInMap =_UserService:GetUsersByMapName(self.Entity.CurrentMapName) 

--게임 시작하기 전에 이 맵의 들어온 플레이어들이 조작 가능하게 만듦
for i,player in ipairs(playersInMap) do
	player.MovementComponent.InputSpeed = self.movementSpeed
end

self.isStarted = true



}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void MinigameEnd(number addRedTeamScore,number addBlueTeamScore)
{

--미니게임 종료 플래그 세움
self.isEnded = true

--플레이 유저들
local playerEntities = _UserService.UserEntities.Values
math.randomseed(os.time())

local randomPlayerName = playerEntities[math.random(1,#playerEntities)].PlayerComponent.Nickname

--미니게임 셀렉터 보이게 함
self:SetMinigameSelectorUIGroupEnable(randomPlayerName)

--대기문구 출력

-- 점수 정산
_ScoreLogic:AddRedTeamScore(addRedTeamScore)
_ScoreLogic:AddBlueTeamScore(addBlueTeamScore)

}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Client
void SetWaitText()
{
self.minigameWaitUIGroup.Enable = true
self.minigameWaitUIText.TextComponent.Text="아직 모든 인원이 게임에 참가하지 않았습니다."
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Client
void SetCountdownText()
{
self.minigameWaitUIGroup.Enable=true
self.minigameWaitUIText.TextComponent.Text = "5초 뒤 게임이 시작됩니다."
wait(1)
self.minigameWaitUIText.TextComponent.Text = "4초 뒤 게임이 시작됩니다."
wait(1)
self.minigameWaitUIText.TextComponent.Text = "3초 뒤 게임이 시작됩니다."
wait(1)
self.minigameWaitUIText.TextComponent.Text = "2초 뒤 게임이 시작됩니다."
wait(1)
self.minigameWaitUIText.TextComponent.Text = "1초 뒤 게임이 시작됩니다."
wait(1)

--UI들이 안 보이게 만듦
self.minigameWaitUIGroup.Enable = false

self:MinigameStart()

}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Client
void SetMinigameSelectorUIGroupEnable(string playerName)
{

if _UserService.LocalPlayer.PlayerComponent.Nickname ~= playerName then
	return
end
self.minigameSelectorUIGroup.Enable = true
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Client
void SetMinigameEndNoticeUIGroup(string nextMinigameName)
{
self.minigameEndNoticeUIGroup.Enable = true


if nextMinigameName == "BakGame" then
	self.minigameEndNoticeUIText.TextComponent.Text ="다음 게임은 박 터트리기입니다. 포탈로 이동해 주세요"
elseif nextMinigameName == "SketchGame" then
	 self.minigameEndNoticeUIText.TextComponent.Text="다음 게임은 캐치마인드입니다. 포탈로 이동해 주세요"
elseif nextMinigameName == "TileGame" then
	self.minigameEndNoticeUIText.TextComponent.Text="다음 게임은 타일 뒤집기입니다. 포탈로 이동해 주세요"
elseif nextMinigameName == "PacManGame" then
	self.minigameEndNoticeUIText.TextComponent.Text="다음 게임은 팩맨입니다. 포탈로 이동해 주세요"
elseif nextMinigameName == "JulGame" then
	self.minigameEndNoticeUIText.TextComponent.Text="다음 게임은 줄다리기입니다. 포탈로 이동해 주세요"
elseif nextMinigameName == "LadderGame" then
	self.minigameEndNoticeUIText.TextComponent.Text="다음 게임은 사다리게임입니다. 포탈로 이동해 주세요"
elseif nextMinigameName == "RulletGame" then
	self.minigameEndNoticeUIText.TextComponent.Text="다음 게임은 해적룰렛입니다. 포탈로 이동해 주세요"
elseif nextMinigameName == "Award" then
	self.minigameEndNoticeUIText.TextComponent.Text="모든 미니게임이 종료되었습니다. 시상식으로 이동해주세요"
end
}
--@ EndMethod

--@ BeginEntityEventHandler
--@ Scope=Server
--@ Target=logic:MinigameOrderLogic
--@ EventName=GetNextGameEvent
HandleGetNextGameEvent
{
-- Parameters
local nextMinigameName = event.nextMinigameName
--------------------------------------------------------

self:SetMinigameEndNoticeUIGroup(nextMinigameName)


}
--@ EndEntityEventHandler

