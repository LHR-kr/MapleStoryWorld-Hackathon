--@ BeginProperty
--@ SyncDirection=All
number triggerTileIndex = "0 "
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number maxTileNum = "8"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void OnBeginPlay()
{
math.randomseed(os.time())
self.triggerTileIndex = math.random(1,self.maxTileNum) -- 1~8 중에 하나의 발판을 트리거로 설정
}
--@ EndMethod

