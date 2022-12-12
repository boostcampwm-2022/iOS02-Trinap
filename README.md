# Trinap

<p align="center"><image alt="trinap" src="https://user-images.githubusercontent.com/27603734/200277055-fd64e53e-9901-4e8b-893a-1c028264500e.png" align="center"/></p>
<p align="center">  
  <img src="https://img.shields.io/github/issues/boostcampwm-2022/iOS02-Trinap"/>
  <img src="https://img.shields.io/github/issues-closed/boostcampwm-2022/iOS02-Trinap"/>
  <img src="https://img.shields.io/github/commit-activity/w/boostcampwm-2022/iOS02-Trinap">
  <br><br>
</p>

## 290km 팀 소개 👨‍👨‍👦‍👦
|S007 김세영|S015 김찬수|S016 박도윤|S033 유병주|
|:-:|:-:|:-:|:-:|
|<image width="150" src="https://avatars.githubusercontent.com/u/27603734?v=4"/>|<image width="150" src="https://avatars.githubusercontent.com/u/89574881?v=4"/>|<image width="150" src="https://avatars.githubusercontent.com/u/77266017?v=4"/>|<image width="150" src="https://avatars.githubusercontent.com/u/7793506?v=4"/>|
|[@yy0867](https://github.com/yy0867)|[@chansooo](https://github.com/chansooo)|[@d0yvn](https://github.com/d0yvn)|[@byeongjooyoo](https://github.com/byeongjooyoo)|

# 📷 프로젝트 소개

---

 **우리가 여행을 추억하는 방법 📷, Trinap**
 
👋 Trinap을 개발한 팀 **290km**입니다!

---


### 📝 여행에서의 추억을 남기고 싶으신가요?

> 
> 

### 👯‍♀️ 누구나 작가가 될 수 있고, 고객이 될 수 있습니다.

> 
> 

### 🏴‍☠️ 편하게 다른 유저와 만나보세요!

> 유저와의 채팅, 위치 공유를 통해서 편하게 만날 수 있습니다.
> 

# ✨ 주요 기능

> 🔎 원하는 장소를 검색하고, 가까운 순서대로 작가를 모아볼 수 있어요.
>
> 🧾 작가의 정보를 확인하고 예약을 신청할 수 있어요.
>
> 📡 채팅과 위치 공유를 통해서 손쉽게 만날 수 있어요.
>
> 👀 예약 내역을 한 눈에 모아 볼 수 있어요.

# 🔨 기술 소개

## Tuist
<image alt="tuist" width="100" src="https://user-images.githubusercontent.com/27603734/205533785-79272b8c-def9-43db-b7ba-ba854ee1ef61.svg"/>

프로젝트 관리 도구로 **Tuist**를 사용했습니다.

<details>
<summary>도입 이유 및 결과</summary>

### 도입 이유

`*.pbxproj` 기반으로 프로젝트를 관리할 경우 발생할 수 있는 여러 문제점들을 제거하기 위해 Tuist를 도입했습니다.

### 도입 결과

1. Swift로 프로젝트 관리를 할 수 있어 직관적으로 이해할 수 있었습니다.
2. 독립된 기능들을 쉽게 모듈화하여, 재사용성을 높이고 빌드 속도를 단축시킬 수 있었습니다.
3. 프로젝트를 생성할 때, 캐시되어 있는 프레임워크를 가져오기 때문에 생성 및 로딩 시간을 단축시켰습니다.
4. 프로젝트 리소스를 자동으로 생성해서 사용할 수 있습니다.

</details>

## 🏛️ **MVVM-C & Clean Architecture**

![TrinapArchitecture](https://user-images.githubusercontent.com/27603734/205534124-dc688740-07a3-4711-a816-e005eb91474f.png)

## MVVM
<details>
<summary>도입 이유 및 결과</summary>

### 도입 이유

- 사용자 입력 및 뷰의 로직과 비즈니스에 관련된 로직을 분리하고 싶었습니다.
- View의 Event로 부터 UI작업까지 단방향으로 관리할 수 있었습니다.
- ViewController에 의존적이지 않는 Testable한 ViewModel을 만들 수 있었습니다.

### 도입 결과

1. Input, Output으로 나누어 ViewModel에 전달받을 값과, 전달할 값을 직관적으로 인식할 수 있었습니다.
2. ViewController가 ViewModel의 프로퍼티를 참조하는 의존성을 해결할 수 있었습니다.

</details>

## Coordinator Pattern

<details>
<summary>도입 이유 및 결과</summary>

### 도입 이유

- 코드 베이스로 UI를 작성하게되면 StoryBoard로 UI를 작성할 때 보다 View들의 계층과 Flow를 파악하기가 힘들다는 문제가 있었습니다.
- ViewController의 화면 전환 및 의존성을 주입하는 역할을 분리하기 위해 적용했습니다.

### 도입 결과

- 동일한 인스턴스의 중복 생성을 막아 메모리 낭비를 막을 수 있었습니다.
- View의 계층과 Flow 및 의존성을 주입에 대한 정보를 한 눈에 파악할 수 있었습니다.
- 의존성 주입이 복잡해질 경우 DI Container를 추가적으로 구현하여 의존성에 관한 내용을 분리하였습니다.

</details>

## Clean Architecture

<details>
<summary>도입 이유 및 결과</summary>

### 도입 이유

- MVVM 구조에서 ViewModel이 모든 로직을 처리하는 것을 피하기 위해 Clean Architecture를 적용하였습니다.
- 각각의 레이어를 역할에 따라 분리하여 방대한 양의 코드를 쉽게 파악할 수 있도록 하고 싶었습니다.
- 프로토콜로 각 레이어의 객체에 대한 추상화를 진행하여 수정에 닫혀 있는 코드를 작성하고 싶었습니다.

### 도입 결과

- 각각의 비즈니스 로직을 따로 테스트할 수 있었습니다.
- 각 객체의 역할을 프로토콜로 정의하고, Mock 객체를 구현하여 단위 테스트하기에 용이하도록 구현할 수 있었습니다.
- 프로토콜로 해당 클래스의 역할과 형태를 명시해서, 협업을 할 때 각 객체가 어떤 역할을 하는지 쉽게 파악할 수 있었습니다.

</details>

## RxSwift

<details>
<summary>도입 이유 및 결과</summary>

### 도입 이유

- 네트워크 기반의 서비스여서 대부분의 동작이 비동기적이기 때문에 Thread 관리에 주의해야합니다.
- 실제 서버가 아닌 NoSQL기반의 파이어베이스를 사용하기 때문에 중첩된 네트워크 연산을 처리해야하므로 하나의 연산에 콜백이 중첩되어 가독성 저해 및 휴먼 에러로 인한 디버그 문제가 발생합니다.

### 도입 결과

- escaping closure가 아닌 RxSwift의 Operator를 활용하여 코드 양이 감소하여 깔끔해지고 실수를 방지할 수 있었습니다.
- Traits를 활용하여 Thread 관리를 더 쉽게 할 수 있었습니다.
- 비동기 코드(DispatchQueue, OperationQueue)를 직접적으로 사용하지 않아 일관성 있는 비동기 코드로 작성할 수 있었습니다.

</details>

## Firebase

<details>
<summary>도입 이유 및 결과</summary>

### 도입 이유

- 사용자 인증, 사용자 정보 저장, 실시간 채팅, 실시간 위치 공유 등의 기능 구현을 위해 별도의 서버 구현없이 빠르게 개발 가능한 FireBase를 사용하였습니다.
- Firebase Console을 통해 쉽게 프로젝트 데이터에 대한 모니터링이 가능하다는 장점이 있었습니다.

### 도입 결과

- Firebase Authentication을 사용하여 Apple 소셜 로그인을 구현하였습니다.
- Firebase Firestore를 활용하여 사용하여 사용자 데이터, 채팅 정보, 위치 정보를 저장하였습니다.
- FireStore의 채팅 데이터, 위치 데이터를 옵저빙하여 변경되는 데이터를 앱에서 실시간으로 업데이트  해주었습니다.
- Firebase Cloud Functions를 이용하여 채팅에 대한 알림 기능과 특정 위치에서 가까운 순서로 작가의 정보를 가져오는 기능을 구현하였습니다.

</details>

## 이미지 캐시 및 Downsampling 모듈 구현 → Queenfisher

<details>
<summary>도입 이유 및 결과</summary>

### 도입 이유

- 많은 View에서 네트워크 요청을 통한 이미지 처리가 필요합니다.
- 원본 이미지를 그대로 불러오게 되면서 메모리 관리에 어려움을 겪었습니다.
- 스크롤을 할 때마다 이미지를 불러오는 작업을 하기 때문에 반복된 네트워크 요청이 발생하는 문제를 겪었습니다.

### 도입 결과

- 캐싱을 도입해서 네트워크 통신 비용과 메모리 낭비를 획기적으로 줄일 수 있었습니다.
- Downsampling 과정에서 이미지 버퍼에 들어 있는 불필요한 픽셀을 삭제하여, Decode 및 Rendering 과정에서 CPU와 메모리 사용량을 획기적으로 줄일 수 있었습니다.

![Downsampling_MemoryGraph](https://user-images.githubusercontent.com/27603734/205535624-ec63f08f-a91a-444e-8c0c-daa21485e8c0.png)

</details>

# 🙆‍♂️ 협업 방식

### 🙌 **적극적인 의사소통**

- 혼자 해결하기 힘든 문제가 발생하거나, 그 문제 때문에 개발이 지연될 경우 적극적으로 팀원들에게 도움을 요청하였습니다.

<img width="300" alt="slack1" src="https://user-images.githubusercontent.com/27603734/205535824-124ec939-a7e8-4275-9968-ccbc366583af.png">

### 💕 페어 프로그래밍

- 초반에 서로의 코딩 스타일을 경험하고 이해의 깊이를 맞추기 위해서 페어프로그래밍을 진행했습니다.

<img height="150" alt="slack2" src="https://user-images.githubusercontent.com/27603734/205535853-067dd6ec-385f-4992-a565-27225b7596be.png">

<img height="150" alt="slack3" src="https://user-images.githubusercontent.com/27603734/205535856-5a4ca5ec-bea5-479a-bdcf-c575b552c552.png">

### 💬 **모든 PR에 대한 코드 리뷰**

![slack4](https://user-images.githubusercontent.com/27603734/205535895-508244b6-cba8-4327-9392-218b9b82a35e.png)

![slack5](https://user-images.githubusercontent.com/27603734/205535900-e4958d32-c1c3-40ea-8c67-4f5d75f54594.png)

- 모든 브랜치에 2명 이상이 Approve를 해야 PR이 Merge될 수 있도록 설정하였습니다.
- 컨벤션 뿐만 아니라 로직 및 아키텍처 관점에서의 의견 공유도 활발히 진행하였습니다.
- 코드 리뷰를 꼼꼼히 진행하면서 팀원 모두가 프로젝트의 전반적인 코드를 이해하는데 도움이 되었습니다.

### ⚡ **빠른 피드백**

- 깃허브 레포지토리와 슬랙을 연동해서 실시간으로 작업 상황을 공유하고 피드백을 할 수 있었습니다.

<img width="785" alt="slack6" src="https://user-images.githubusercontent.com/27603734/205535936-a88bdaf6-30dc-4fc9-93d2-f1036f9e5335.png">

### 📚 **코딩 컨벤션 정의**

- SwiftLint를 사용하여 코드의 형식을 일관되게 작성할 수 있도록 하였습니다.
- 아래의 스타일 가이드를 저희 팀의 스타일에 맞게 커스텀하여 사용하였습니다.
    
[GitHub - kodecocodes/swift-style-guide: The official Swift style guide for raywenderlich.com.](https://github.com/kodecocodes/swift-style-guide)
