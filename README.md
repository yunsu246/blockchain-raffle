## blockchain-raffle
Team Project for 3rd KISA Fintech X Blockchain Academy 
한국인터넷진흥원 핀테크X블록체인 아카데미 3기 '1조' 프로젝트 저장소

## 개요
 1. 팀명 : 1조
 2. 프로젝트 아이템 : Blockchain을 활용한 경품추첨 dApp
    - 핵심기능
      - Smart Contract를 활용한 _Random number_ 생성 및 관리
      - 해당 경품에 대한 참여자 조회 
      - 실제 경품추첨 후 당첨자 발표
    - 구현형태 : WEB
    - 주요 리소스 및 아키텍쳐
      - Front-End : AWS ec2, Web3.js, Vue.js
      - Back-End : [KALEIDO](https://kaleido.io)
    - 블록체인 네트워크 구성
      - Network type : Private Network(KALEIDO)
      - Consensus algorithm : PoA
      - Core : [go-ethereum](https://github.com/ethereum/go-ethereum)
