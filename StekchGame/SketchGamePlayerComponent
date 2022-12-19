--@ BeginProperty
--@ SyncDirection=All
boolean isPainter = "false"
--@ EndProperty

--@ BeginEntityEventHandler
--@ Scope=Client
--@ Target=localPlayer
--@ EventName=ChatEvent
HandleChatEvent
{
-- Parameters
local Message = event.Message
local SenderName = event.SenderName
local UserId = event.UserId
--------------------------------------------------------

log("채팅")
local player = _UserService:GetUserEntityByUserId(UserId)



local sketchManager = _EntityService:GetEntity("01841dd6-af56-4e95-b845-bc4f17322145")
local minigameManager = _EntityService:GetEntity("fb5db0fa-6259-4589-8b90-045179319f11")

if minigameManager == nil or sketchManager == nil then
	log("매칭 전")
	return
end

--미니게임 시작 전이거나 끝났으면 아무 것도 하지 마라
if minigameManager.MinigameManagerComponent.isStarted == false then
	
	log("게임 시작 전")
	return
end

if minigameManager.MinigameManagerComponent.isEnded == true then
	log("게임 끝남")
	return
end

--스케치 매니저가 없으면 아무 일도 하지 마라
if sketchManager == nil then
	log("스케치매니저 nil")
	return
end

-- 그림 그리는 사람 채팅은 검사하지 않는다.
if player.SketchGamePlayerComponent.isPainter == true then
	log("화가임")
	return
end
log("chat evnent happen")
sketchManager.SketchManagerComponent:CheckAnswer(Message, player.ExtendPlayerComponent.team)
}
--@ EndEntityEventHandler

--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=localPlayer
--@ EventName=ChatBalloonEvent
HandleChatBalloonEvent
{




}
--@ EndEntityEventHandler

