# flutter_nice_authentication_module

Flutter 나이스 본인인증 연동 코드 (Android only)
<br />
[자세한 설명 바로가기](https://blog.naver.com/rnjs1995/222871328505)

##### 구조
![백엔드-Spring](https://user-images.githubusercontent.com/80610295/189468851-c2859598-cb60-4cc3-9d85-aa191325c8ee.png)
![백엔드 - Spring / 프론트엔드 - Flutter](https://user-images.githubusercontent.com/80610295/189468867-41cbae50-8597-4618-8ae5-4b69eb8a79bf.png)

Spring jsp파일에서 처리해야 할 사항
- main.jsp에서 window.onload = function() {fnPopup();} 
- main.jsp에서 window.onload = function() {setTimeout(function() {fnPopup();}, 3000)} -> 이 방법이 조금 더 안정적

<br />
FLutter에서 처리해야 할 사항
- InAppWebView 사용 -> 웹 페이지의 window.popup을 실행하기 위함

<br />
##### 주의사항
- 웹에서 본인인증을 수행할 때 크롬에서 인증을 성공했다면 해당 url이 있을겁니다. 그 url을 엣지브라우저에서 수행하면 복호화 오류가 나타납니다. 이는 인증 자체가 브라우저에 어떠한 쿠키값을 주는 것 같았습니다. 즉, 암호화 데이터 값을 잘 가져왔어도 다른 브라우저에서 정보를 가져올 수 없습니다. 인앱에서 본인인증을 수행했으면 인앱에서만 success url에서 올바르게 정보를 가져올 수 있습니다. 

- onLoadStop에서 크롤링을 수행해야 합니다. 웹 페이지가 다 로딩되고 나서 암호화 데이터 값을 가져와야 하기 때문입니다.

- get.http 메서드 말고 controller.evaluateJavascript 메서드를 사용해야 로드된 웹페이지 정보를 그대로 가져올 수 있습니다.

- 테스트 수행할 때마다 애뮬레이터 앱 캐시를 삭제해야 합니다. 그렇게 해야 정상적으로 테스트를 수행할 수 있습니다. '모두 닫기'를 수행하시거나 '앱 삭제'를 수행해주세요!

<br />
##### 예시화면
![nice 본인인증 팝업창 화면](https://user-images.githubusercontent.com/80610295/189468996-6f00d633-9b3a-44c4-b80f-309a3ee7b832.png)
