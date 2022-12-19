--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=self
--@ EventName=TriggerEnterEvent
HandleTriggerEnterEvent
{
-- Parameters
local TriggerBodyEntity = event.TriggerBodyEntity
--------------------------------------------------------

--충돌한 물체가 플레이어가 아닌 경우 함수 종료
if TriggerBodyEntity.BakgamePlayerComponent == nil then
	return
end

--충돌한 플레이어가 이미 공을 가지고 있으면 함수 종료
if TriggerBodyEntity.BakgamePlayerComponent.hasBall == true then
	return
end


--현재 맵의 공 개수 감소
local ballGenerator = _EntityService:GetEntity("077e5a86-a949-4913-8706-54dddf015195")


ballGenerator.BallGeneratorComponent.ballNum = ballGenerator.BallGeneratorComponent.ballNum-1

TriggerBodyEntity.BakgamePlayerComponent.hasBall= true;
TriggerBodyEntity.NameTagComponent.FontColor = Color.red
self.Entity:Destroy() 


}
--@ EndEntityEventHandler

