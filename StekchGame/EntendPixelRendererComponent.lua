--@ BeginProperty
--@ SyncDirection=All
number leftX = "-2.45"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number rightX = "2.4"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number belowY = "-0.8"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number highY = "2.6"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
Entity minigameManager = "fb5db0fa-6259-4589-8b90-045179319f11"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
Color color = "Color(0,0,0,0)"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=Server
void CallSetSketch(table<Color> arg1)
{
self:SetSketch(arg1)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Client
void SetSketch(table<Color> arg1)
{
self:SetPixels(arg1)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Server
void CallClearSketch()
{
self:ClearSketch()
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Client
void ClearSketch()
{
--서버에서 호출되어야 함
self:FillColor(Color.white)
}
--@ EndMethod

--@ BeginEntityEventHandler
--@ Scope=Client
--@ Target=service:InputService
--@ EventName=KeyHoldEvent
HandleKeyHoldEvent
{
-- Parameters
local key = event.key
--------------------------------------------------------

--미니게임 시작 전이거나 끝났으면 아무 것도 하지 마라
if self.minigameManager.MinigameManagerComponent.isStarted == false then
	return
end

if self.minigameManager.MinigameManagerComponent.isEnded == true then
	return
end

--마우스 클릭 아니면 아무 것도 하지 마라
if key~=KeyboardKey.Mouse0 and key~=KeyboardKey.Mouse1 then
	return
end	

-- 그림 그리는 사람 아니면 아무 것도 하지 마라 
if _UserService.LocalPlayer.SketchGamePlayerComponent.isPainter == false then
	return
end

--클릭 좌표를 월드 좌표로 변환. 월드 좌표는 다시 픽셀 좌표로 전환
local clcickPos = _UILogic:ScreenToWorldPosition(_InputService:GetCursorPosition())
if clcickPos.x >=self.leftX and clcickPos.x<=self.rightX and clcickPos.y >= self.belowY and clcickPos.y<=self.highY then 
	local x= math.floor(self.Width*(clcickPos.x-self.leftX)/(self.rightX-self.leftX))
	local y = math.floor(self.Height*(clcickPos.y - self.belowY)/(self.highY-self.belowY))

	if key== KeyboardKey.Mouse0 then
		self.Entity.PixelRendererComponent:SetPixel(x,y,self.color)
	elseif key == KeyboardKey.Mouse1 then
		self.Entity.PixelRendererComponent:SetPixel(x+1,y,Color.white)
		self.Entity.PixelRendererComponent:SetPixel(x-1,y,Color.white)
		self.Entity.PixelRendererComponent:SetPixel(x,y,Color.white)
		self.Entity.PixelRendererComponent:SetPixel(x,y-1,Color.white)
		self.Entity.PixelRendererComponent:SetPixel(x,y+1,Color.white)
		
	end
end




}
--@ EndEntityEventHandler

--@ BeginEntityEventHandler
--@ Scope=Client
--@ Target=service:InputService
--@ EventName=KeyReleaseEvent
HandleKeyReleaseEvent
{
-- Parameters
local key = event.key
--------------------------------------------------------

--미니게임 시작 전이거나 끝났으면 아무 것도 하지 마라
if self.minigameManager.MinigameManagerComponent.isStarted == false then
	return
end

if self.minigameManager.MinigameManagerComponent.isEnded == true then
	return
end

--마우스 클릭 아니면 아무 것도 하지 마라
if key~=KeyboardKey.Mouse0 and key~=KeyboardKey.Mouse1 then
	return
end	

-- 그림 그리는 사람 아니면 아무 것도 하지 마라
if _UserService.LocalPlayer.SketchGamePlayerComponent.isPainter ~= true then
	return
end

--마우스 버튼 뗐을 때 스케치북 안이면 그리기
local clcickPos = _UILogic:ScreenToWorldPosition(_InputService:GetCursorPosition())
if clcickPos.x >=self.leftX and clcickPos.x<=self.rightX and clcickPos.y >= self.belowY and clcickPos.y<=self.highY then 
	self:CallSetSketch(self:GetPixels())
end


}
--@ EndEntityEventHandler

