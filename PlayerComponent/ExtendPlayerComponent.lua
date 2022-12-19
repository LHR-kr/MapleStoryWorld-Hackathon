--@ BeginProperty
--@ SyncDirection=All
string team = ""red" -- 디폴트 값은 red, red 또는 blue의 값을 가진다"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity exitButton = "9fe1cdbb-4fcd-4f44-9e19-9687e0fa92fa"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity scoreUIGroup = "df91603c-5fc9-4b57-bf76-5209b3a999eb"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity nextMinigameNoticeUiGruop = "d11196bd-73b7-45d5-8655-2a9b581ca5ff"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void OnMapLeave(any leftMap)
{
self.Entity.NameTagComponent.FontColor = Color.white

}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void OnMapEnter(any enteredMap)
{
wait(0.5) -- 로컬 플레이어 생성을 위한 대기시간
local mapName = self.Entity.CurrentMapName
log("ExtendPlayerComponent. ".. mapName.." enter")

self:SetDisableNextMinigameNoticeUIGroup()

if mapName == "Award" then

	log("ExtendPlayerComponent. doAward")
	self:SetDisableScoreUIGroup()
	self:SetEnableExitButton()
	local redTeamScore = _ScoreLogic:GetRedTeamScore()
	local blueTeamScore = _ScoreLogic:GetBlueTeamScore()
	self:DoAward(redTeamScore,blueTeamScore)
	return
		
elseif mapName == "BakGame" then
	self.Entity.BakgamePlayerComponent.Enable = true
	self.Entity.RulletGamePlayerComponent.Enable = false
	
elseif mapName =="RulletGame" then
	self.Entity.RulletGamePlayerComponent.Enable = true
	self.Entity.BakgamePlayerComponent.Enable = false
end
self:SetDisableExitButton()

}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Client
void DoAward(number redTeamScore,number blueTeamScore)
{
--지금은 log()로 하지만, 나중에 우승 연출 넣으면 된다.
log("ExtendPlayerComponent. do award")

if redTeamScore == blueTeamScore then
	log("무승부")
	return
end

-- 팝업 창 띄우기
if self.team == "red" then
	if redTeamScore> blueTeamScore then
		self.Entity.AvatarRendererComponent:PlayEmotion(EmotionalType.Cheers,100)
	else
		self.Entity.AvatarRendererComponent:PlayEmotion(EmotionalType.Oops,100)
	end
else
		if redTeamScore< blueTeamScore then
		self.Entity.AvatarRendererComponent:PlayEmotion(EmotionalType.Cheers,100)
	else
		self.Entity.AvatarRendererComponent:PlayEmotion(EmotionalType.Oops,100)
	end
end

}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Client
void SetEnableExitButton()
{
self.exitButton.Enable=true
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Client
void SetDisableExitButton()
{
self.exitButton.Enable=false
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Client
void SetDisableScoreUIGroup()
{
self.scoreUIGroup.Enable= false
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Client
void SetDisableNextMinigameNoticeUIGroup()
{
self.nextMinigameNoticeUiGruop.Enable = false
}
--@ EndMethod
