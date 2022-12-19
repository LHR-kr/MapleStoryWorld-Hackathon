--@ BeginProperty
--@ SyncDirection=All
number ballNum = "0"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number ballMaxNum = "10"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number spawnDuration = "5"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number time = "0"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
Entity minigameManager = "a86715ae-3754-40af-9cec-4c2c23686c2a"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void OnBeginPlay()
{
--초기 공 생성
local parent = self.Entity.Parent
math.randomseed( os.time() )
for i=1, self.ballMaxNum, 1 do
	local posX = math.random(-5,5) + math.random()
	local posY = math.random(0,4) 
	local spawnPosition = Vector3(posX,posY,0)
	_SpawnService:SpawnByModelId("model://154814f2-95d9-42f2-a71b-0a44b888dd1a", "Ball", spawnPosition, parent)
	self.ballNum = self.ballNum +1
end



}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void OnUpdate(number delta)
{

--미니게임 시작 안 했으면 아무 것도 하지 마라
if self.minigameManager.MinigameManagerComponent.isStarted == false then
	return
end

--게임 끝났으면 아무 것도 하지 마라
if self.minigameManager.MinigameManagerComponent.isEnded == true then 
	return
end


self.time = self.time + delta

if self.time < self.spawnDuration then
	return
end

self.time = 0

local parent = self.Entity.Parent


math.randomseed(os.time())
--공의 개수가 최대가 될 때까지 생성
for i=1, self.ballMaxNum - self.ballNum, 1 do
	local posX = math.random(-5,7)+ math.random() 
	local posY = math.random(0,4)
	local spawnPosition = Vector3(posX,posY,0)
	_SpawnService:SpawnByModelId("model://154814f2-95d9-42f2-a71b-0a44b888dd1a", "Ball", spawnPosition, parent)
end
self.ballNum = self.ballMaxNum

}
--@ EndMethod

