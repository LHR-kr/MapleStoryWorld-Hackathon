--@ BeginProperty
--@ SyncDirection=None
table playerOrderTable = "{}"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
Entity turnPlayer = "nil"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
Entity minigameManager = "489ce5d2-dbc7-4336-ada8-f6be82eccb87"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
boolean isInited = "false"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void OnBeginPlay()
{


wait(2)

--플레이어 순서 정하기
local redTeam={}
local blueTeam={}

local players = _UserService.UserEntities

log(#players.Values)

for userId, playerEntity in pairs(players) do
    if playerEntity.ExtendPlayerComponent.team == "red" then
		table.insert(redTeam,1, playerEntity)
	else 
		table.insert(blueTeam, 1, playerEntity)
	end
end

for i =0 , #redTeam, 1 do
	if redTeam[i]~=nil then
		table.insert(self.playerOrderTable,1,redTeam[i])
	end 
	if blueTeam[i]~=nil then
		table.insert(self.playerOrderTable,1,blueTeam[i])
	end 
	
end
log(#self.playerOrderTable)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void OnUpdate(number delta)
{
if self.minigameManager.MinigameManagerComponent.isStarted == true and self.isInited == false then
	self:SetPlayerTurn()
	self.isInited = true
end
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Server
void SetPlayerTurn()
{
if self.turnPlayer ~= nil then
	self.turnPlayer.RulletGamePlayerComponent.isMyTurn = false --공격권을 가졌던 이전 플레이어의 공격권 박탈
	self.turnPlayer.NameTagComponent.FontColor = Color.white -- 공격권 박탈하면서 이름 하얀색으로
end

table.insert(self.playerOrderTable,#self.playerOrderTable+1,self.playerOrderTable[1]) -- 첫번째 플레이어 맨 뒤로
table.remove(self.playerOrderTable,1) -- 첫번째 원소를 배열에서 삭제

self.turnPlayer =self.playerOrderTable[#self.playerOrderTable] -- 테이블의 마지막 원소가 이번 턴 플레이어

self.turnPlayer.RulletGamePlayerComponent.isMyTurn = true -- 공격 가능 상태로 만든다.
self.turnPlayer.NameTagComponent.FontColor = Color.magenta --공격 가능 상태면 이름 색깔 빨갛게
}
--@ EndMethod

