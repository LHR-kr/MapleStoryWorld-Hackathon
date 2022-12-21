
## MSW와 인스턴스 맵

MSW의 인스턴스 맵은 필요에 의해 동적으로 생성할 수 있는 맵으로 생성된 각각의 맵은 독립적으로 존재한다. 인스턴스 맵의 이러한 특징을 통해 멀티 플레이 게임에서 특정 플레이어를 위한 맵을 생성하여 플레이어들이 서로 분리된 공간에서 게임을 즐길 수 있다.

## MinigameManager 개요

MSW는 인스턴스 맵이 생성될 때 맵 리스트에 있는 모든 인스턴스 맵이 동시에 생성된다. 예를 들어 메이플 그라운드 게임에서는 7종의 미니게임이 있어 7종류의 인스턴스 맵이 개발되어 있다. 플레이어들의 멀티 플레이 매칭이 완료되고 새로운 인스턴스 맵이 생성될 때, 7종류의 인스턴스 맵이 모두 동시에 생성된다. 이로 인해 인스턴스에 각 맵에 적용된 call back 함수인 OnBeginPlay (인스턴스 맵이 생성될 때 호출), OnUpdate (매 프레임마다 호출) 함수가 동시에 실행되어 정상적인 게임 플레이가 어려워진다. 

이 문제를 해결하기 위해 MinigameManager 모델 (이하 매니저)을  설계하였다. 매니저는 인스턴스 맵이 현재 플레이 중인  미니게임인지 판단하고 해당 인스턴스 맵의 컴포넌트의 동작을 제어한다. 

매니저는 이 외에도 모든 미니게임 맵에서 동일하게 작동되어야 하는 미니게임의 시작, 종료, 스코어 산정, UI 처리 등의 로직 또한 담당한다.

## MinigameManager의 구조

매니저는 게임을 6개의 상태로 구분하며 게임을 제어한다.

1. 해당 미니게임이 시작되지 않았고. 맵에 아무도 입장하지 않은 상태.
2. 해당 미니게임이 시작되지 않았고, 맵에 플레이어가 입장한 상태. 대기 UI를 출력한다
3. 해당 미니게임이 시작되지 않았고, 맵에 플레이어가 모두 입장한 상태. 미니게임을 시작한다
4. 해당 미니게임이 시작된 상태.
5. 해당 미니게임이 끝났고, 맵에 플레이어가 남아 있는 상태. 안내 UI를 출력한다.
6. 해당 미니게임이 끝났고, 맵에서 플레이어가 모두 떠난 상태.

이들은 해당 맵에 존재하는 유저의 수를 매칭된 유저 수와 비교를 통해 제어된다.

## MinigameManager의 사용

1. 인스턴스 맵에 minigameManager 모델을 추가한다.

![image](https://user-images.githubusercontent.com/82368502/208841767-b07cafca-b11d-4126-ba8c-2b17e93ddad3.png)


2. 필요에 따라 컴포넌트에 minigameManager 프로퍼티를 추가한다. ( 예 : OnUpdate에서 주기적으로 무언가를 처리하는 컴포넌트 , 해당 맵에서만 작동해야 하는 컴포넌트 등)

![image](https://user-images.githubusercontent.com/82368502/208840718-8da73f35-7522-4f98-baa7-fbf7ff4b7a5c.png)

   
    
3. OnUpdate 함수 안에 도입부에 다음의 코드를 추가한다. 아래의 코드는 만약 해당 미니게임이 시작되기 전이거나 끝난 이후면 OnUpdate 함수에서 아무 동작도 하지 않도록 제어한다.
    
    **if self.minigameManager.MinigameManagerComponent.isStarted == false then
        return
    end**
    
    **if self.minigameManager.MinigameManagerComponent.isEnded == true then
        return
    end**
    
![image](https://user-images.githubusercontent.com/82368502/208840957-a1e9e27f-4f10-4799-9202-30ffc7f65ea7.png)
    
4. 미니게임이 종료되는 부분에서 매니저의 MinigameEnd함수를 호출한다. 해당 함수는 미니게임 종료와 관련된 로직과 UI를 담당한다. 함수의 인자로 레드팀이 득점한 점수, 블루팀이 득점한 점수를 넣어준다.


![image](https://user-images.githubusercontent.com/82368502/208841071-0e6f86a4-9a61-4d08-ae76-7bd4222680d4.png)


