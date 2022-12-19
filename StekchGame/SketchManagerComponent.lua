--@ BeginProperty
--@ SyncDirection=All
string answer = """"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity timerUIGroup = "25e56ae4-e5ef-4950-b9e5-f9a61a840ba2"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity timerUIText = "8ee9c445-4913-45eb-8ab1-b0484714dd52"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity minigameWaitUIGroup = "0a72c936-bbcd-464b-b635-371cbca1161b"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity minigameWaitUIText = "fe6d5be5-6585-45fa-89d9-0e91f8b77f16"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity sketchAnswerUIGroup = "7ad3a855-0249-466b-bb2c-479ce5a157a8"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity sketchAnswerUIText = "e78e224f-c4f4-4765-838c-c4cdb6ffa792"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number phase = "1"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number redTeamScore = "0"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number blueTeamScore = "0"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
boolean isStarted = "false"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
boolean isCountdown = "false"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
boolean isAnswer = "false"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
Entity minigameManager = "fb5db0fa-6259-4589-8b90-045179319f11"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number score = "100"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
Entity painter = "nil"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
Entity sketch = "4b6f7a92-c275-4d0d-b7ac-974e48a16d5d"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number limitTime = "100"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number time = "100"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
Entity redTeamAnswerMark = "ae3ebc46-6361-4740-a7a3-c5d9ba313bf1"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
Entity blueTeamAnswerMark = "4bac2f76-9f13-4826-b318-c254b1d42ee9"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
Entity eraserButton = "18f2278d-e852-4bb0-8275-4ab8c9b3f1ad"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void OnUpdate(number delta)
{
--미니게임 시작 전이거나 끝났으면 아무 것도 하지 마라
if self.minigameManager.MinigameManagerComponent.isStarted == false then
	return
end

if self.minigameManager.MinigameManagerComponent.isEnded == true then
	return
end

--게임을 이제 시작하는 거면 1페이즈 설정. 2페이즈는 나중에 알아서 설정 됨
if self.isStarted == false then
	
	self.isStarted = true
	self:SetPahse()
end


-- 타이머 관련 코드 추가.
if self.isCountdown == false then
	return
end
	
self.time = self.time - delta
	
self:ChangeTimerUIText()
	
if self.time <= 0 then
	log("시간초과")
	self.isCountdown =false
	self:CheckAnswer(self.answer,"")
end

}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Server
void SetPahse()
{

log("phase setted")
--데이터베이스의 단어의 총 개수
local dataNum = _DataService:GetRowCount("WordDataSet")
math.randomseed(os.time())
self.answer = _DataService:GetCell("WordDataSet",math.random(1,dataNum),"Word")
log(self.answer)



self.isAnswer = false -- 정답 처리 과정 중 block을 담당하는 변수 초기화

--스케치북 초기화
self.sketch.ExtendPixelRendererComponent:ClearSketch()
self.sketch.ExtendPixelRendererComponent.color = Color.black



if self.phase == 1 then -- 레드팀이 그림 그릴 차례 겸 첫번째 차례
	local redTeamPlayerEntities={}
	
	local playerEntities = _UserService.UserEntities.Values
		
	for idx,playerEntity in ipairs(playerEntities) do
		--플레이어들의 SketchGamePlayerComponent 활성화	
		playerEntity.SketchGamePlayerComponent.Enable = true
		--만약 red팀이면 배열에 따로 저장
		if playerEntity.ExtendPlayerComponent.team =="red" then
			table.insert(redTeamPlayerEntities,1,playerEntity)
		end
	end
	
	--red팀 중에서 한 명 랜덤하게 골라서 화가 역할 부여
	math.randomseed(os.time())
	self.painter = redTeamPlayerEntities[math.random(1,#redTeamPlayerEntities)]
	self.painter.SketchGamePlayerComponent.isPainter = true
	

elseif self.phase==2 then
	
	--이전 red팀의 화가 자격 박탈
	self.painter.SketchGamePlayerComponent.isPainter = false
	self.painter.NameTagComponent.FontColor = Color.white -- 공격권 박탈하면서 이름 하얀색으로
	
	local blueTeamPlayerEntities={}
	local playerEntities = _UserService.UserEntities.Values
	
	
	for idx,playerEntity in ipairs(playerEntities) do
		--플레이어들의 SketchGamePlayerComponent 활성화, 이미 1페이즈에서 활성화 해서 주석 처리
		--playerEntity.SketchGamePlayerComponent.Enable = true
		
		--만약 blue팀이면 배열에 따로 저장
		if playerEntity.ExtendPlayerComponent.team =="blue" then
			table.insert(blueTeamPlayerEntities,1,playerEntity)
		end
	end
	
	--blue팀 중에서 한 명 랜덤하게 골라서 화가 역할 부여
	math.randomseed(os.time())
	self.painter = blueTeamPlayerEntities[math.random(1,#blueTeamPlayerEntities)]
	log(self.painter ==nil)
	self.painter.SketchGamePlayerComponent.isPainter = true
	
end


wait(0.5)

self.painter.NameTagComponent.FontColor = Color.red -- 화가 이름은 빨간으로

--타이머 초기화
self.time = self.limitTime
self:SetEnablerTimerUIGroup()
self.isCountdown = true

--화가에게만 정답 보여주는 ui 추가
self:SetPainterAnswerUI()


}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Server
void CheckAnswer(string playerAnswer,string team)
{
-- 플레이어의 정답이 서버의 정답과 다르면 아무 것도 하지 마라
if playerAnswer ~= self.answer then
	 return
end

--정답 처리 과정에서 오는 채팅 검사 요청은 무시. 
if self.isAnswer == true then
	log("is answer is true. so I cant handle it")
	return
end

log("정답 체크 호출")

--여기서부턴 정답을 맞췄을 경우에 실행되는 코드들
--isAnswer는 setPhase 함수에서 반대로 초기화된다.
self.isAnswer = true
--정답 처리 되는 동안은 카운트다운 멈추기
self.isCountdown = false
self:SetDisableTimerUIGroup()


if team =="red" then
	log("red team got score")
	self.redTeamScore = self.redTeamScore + self.score -- 레드팀 득점
	self:SetRedAnswerUI() -- 레드팀 정답 ui 
	
elseif team=="blue" then
	log("blue team got score")
	self.blueTeamScore = self.blueTeamScore + self.score -- 블루팀 득점
	self:SetBlueAnswerUI() -- 블루팀 정답 ui
else
	--do nothing
	--시간초과인 경우
end	

-- 레드팀이 그리던 차례면
if self.phase == 1 then
	self:SetWaitUI() -- 잠시 대기
	wait(6) -- setwait함수는 클라이언트 함수라서 서버와 독립적으로 실행된다. 그래서 서버에서는 6초 정도 기다려야 한다.
	self.phase = self.phase +1 -- 블루팀 차례로 한다
	self:SetPahse()
	
elseif self.phase == 2 then
	wait(2.5)
	self:SketchgameEnd() -- 게임 종료
end





}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void SketchgameEnd()
{
--스케치북 초기화
self.sketch.ExtendPixelRendererComponent:ClearSketch()
--painer를 nil로
self.painter = nil

--ui 숨기기
self:SetDisableSketchUIGroup()
self:SetDisableTimerUIGroup()

local playerEntities = _UserService.UserEntities.Values

for idx,playerEntity in ipairs(playerEntities) do
	playerEntity.SketchGamePlayerComponent.isPainter = false
	playerEntity.SketchGamePlayerComponent.Enable = false
end

self.minigameManager.MinigameManagerComponent:MinigameEnd(self.redTeamScore,self.blueTeamScore)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Client
void SetWaitUI()
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
self.minigameWaitUIGroup.Enable = false
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Client
void ChangeTimerUIText()
{
self.timerUIText.TextComponent.Text = tostring(math.floor(self.time))
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Client
void SetEnablerTimerUIGroup()
{
self.timerUIGroup.Enable = true


self.timerUIText.TextComponent.Text = tostring(self.limitTime)

--카운트다운 시작
self.isCountdown = true
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Client
void SetPainterAnswerUI()
{
log("setPainerAnswerUI called")
if _UserService.LocalPlayer.SketchGamePlayerComponent.isPainter == false then
	self.sketchAnswerUIGroup.Enable = false
	self.eraserButton.Enable = false
	
	return
end


self.sketchAnswerUIGroup.Enable = true
self.eraserButton.Enable = true



self.sketchAnswerUIText.TextComponent.Text = self.answer
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Client
void SetRedAnswerUI()
{
self.redTeamAnswerMark.Enable = true
wait(2)
self.redTeamAnswerMark.Enable = false
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Server
void SetBlueAnswerUI()
{
self.blueTeamAnswerMark.Enable = true
wait(2)
self.blueTeamAnswerMark.Enable = false
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Client
void SetDisableTimerUIGroup()
{
self.timerUIGroup.Enable =false
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Client
void SetDisableSketchUIGroup()
{
self.sketchAnswerUIGroup.Enable = false
}
--@ EndMethod

