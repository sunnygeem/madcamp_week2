# 발자국
<img src="https://github.com/sunnygeem/madcamp_week2/assets/51894747/55eef5df-08a7-48fc-970e-bc5d10a07314" width="10%" height="10%">

발자국에서 나만의 산책로를 업데이트하고 다른 사람들이 등록한 산책로를 직접 걸어보세요!

---

## 개발 환경

**Front-end** `flutter`

**Back-end/** `nodejs`(server), `mysql`(db)

---

## 팀원

[박강태](https://www.notion.so/3c906b5d84de4a73b555e1dd539b35ce?pvs=21)

[김선희](https://www.notion.so/553d94906edd4ba99d228ed8d2d49353?pvs=21) 

---

## DB 구성

**user**

| user_email | user_name | user_nickname |
| --- | --- | --- |
| varchar | varchar | varchar |

**trail:** 산책로 정보

| trail_name | user_email |
| --- | --- |
| varchar | varchar |

_**poisition:** 산책로 checkpoint

| trail_name | location1 | location2 | location3 | location4 | location5 |
| --- | --- | --- | --- | --- | --- |
| varchar | varchar | varchar | varchar | varchar | varchar |

**review:** 다른 사용자 리뷰

| trail_name | review | rev_nickname |
| --- | --- | --- |
| varchar | varchar | varchar |

---

## 앱 구성

‘발자국’은 google API를 연동하여 gmail로 로그인 및 회원가입 할 수 있습니다.

총 3가지 Tab으로 구성되어 있습니다.

---

### Tab 1: 산책로 추가하기

**[overview]**

<img src="https://github.com/sunnygeem/madcamp_week2/assets/51894747/0fbea0ab-d576-4100-8337-58da5ab9c02f" width="30%" height="30%">

<img src="https://github.com/sunnygeem/madcamp_week2/assets/51894747/e1d31dcb-6afc-4b07-9d59-150abfdacb90" width="30%" height="30%">

**[기능]**

- Pin 아이콘을 터치하여 현재 위치 정보 수집 권한을 허용한 후 현재 위치의 주소를 확인합니다.
- 버튼을 터치하면 google map이 켜집니다.
    - 30초마다 marker를 생성하면서 실시간으로 위치를 업데이트 합니다.
    - 각 marker를 잇는 polyline을 그려서 경로 파악할 수 있습니다.
    - 상단에 산책로의 이름을 설정하고 SAVE 버튼을 누르면 데이터베이스에 나만의 산책로가 등록됩니다. (데이터베이스의 용량으로 인해 전체 경로를 5등분 하여 checkpoint만 등록)

---

### Tab 2: 산책로 리스트

********************[overview]********************

****************[기능]****************

- 데이터베이스에 등록된 산책로 리스트를 볼 수 있습니다.
    - 등록자와 등록자가 설정한 산책로 이름을 볼 수 있습니다.
- 각 리스트를 터치하면 dialog 창이 떠서 산책로를 볼 수 있고 리뷰를 작성 및 확인할 수 있습니다.
    - 데이터베이스에 등록된 5개의 checkpoint를 불러와서 다시 지도에 marker를 생성한 후 polyline을 그려줍니다.
    - 리뷰를 작성하면 리뷰 작성자와 리뷰 내용이 담긴 listview가 업데이트 됩니다. (데이터베이스의 용량으로 인해 15자 글자수 제한)

---

### Tab 3: 내 프로필 확인 및 수정

**[overview]**

**[기능]**

- 내 프로필을 확인할 수 있습니다.
    - 로그인에 사용한 gmail과 google에 설정된 내 이름이 보입니다.
- 프로필 수정 버튼을 통해서 다른 사람에게 보여지는 닉네임을 수정할 수 있습니다.

---

## 추가할 사항

- 프로필 사진을 설정하는 기능
- 산책로 등록하는 중에 카페나 사진 스팟이 있다면 checkpoint를 따로 설정해 추가하는 기능
- 산책로 리스트 정렬 기능 (리뷰 개수 순서, 등록 날짜 순서 등)
