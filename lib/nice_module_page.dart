import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parse;

class NiceModulePage extends StatefulWidget {
  const NiceModulePage({Key? key}) : super(key: key);

  @override
  _NiceModulePageState createState() => _NiceModulePageState();
}

class _NiceModulePageState extends State<NiceModulePage> {

  String m = "";
  String encodeData = "";
  String requestBody = "";
  late InAppWebViewController _inAppWebViewController;

  String decryptDate = "";
  String requestNumber = "";
  String niceResponseNumber = "";
  String authenticationTool = "";
  String name = "";
  String di = "";
  String ci = "";
  String birth = "";
  String sex = "";
  String foreign = "";
  String phoneNumber = "";
  String phoneInc = "";

  List<String> authInfo = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // 미사용
  // Future<void> getInputTagData(String url) async {
  //   final response = await http.get(Uri.parse(url));
  //   if(response.statusCode == 200) {
  //     dom.Document document = parse.parse(response.body);
  //
  //     final input_m = document.querySelector("input[name=m]");
  //     final input_encodeData = document.querySelector("input[name=EncodeData]");
  //
  //     if(input_m != null) {
  //       m = input_m.outerHtml.split("value=").last.split(">")[0].replaceAll("\"", "");
  //     }
  //     if(input_encodeData != null) {
  //       encodeData = input_encodeData.outerHtml.split("value=").last.split(">")[0].replaceAll("\"", "").replaceAll("+", "%2b");
  //     }
  //
  //     print("m : $m");
  //     print("encodeData : $encodeData");
  //   }
  // }

  void inputInfo(List list) {
    print("list info");
    print(list);
    decryptDate = list[1].toString();
    requestNumber = list[3].toString();
    niceResponseNumber = list[5].toString();
    authenticationTool = list[7].toString();
    name = list[9].toString();
    di = list[11].toString();
    ci = list[13].toString();
    birth = list[15].toString();
    sex = list[17].toString();
    foreign = list[19].toString();
    phoneNumber = list[21].toString();
    phoneInc = list[23].toString();

    print("decryptDate : $decryptDate");
    print("requestNumber : $requestNumber");
    print("niceResponseNumber : $niceResponseNumber");
    print("authenticationTool : $authenticationTool");
    print("name : $name");
    print("di : $di");
    print("ci : $ci");
    print("birth : $birth");
    print("sex : $sex");
    print("foreign : $foreign");
    print("phoneNumber : $phoneNumber");
    print("phoneInc : $phoneInc");
  }

  // 값을 제대로 가져오지 못 함 -- 쿠기값 때문인 걸로 추정
  Future<void> checkUrl(encodeData) async {
    String url = "http://172.30.1.83:8080/success?EncodeData="+encodeData;
    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      print("################### checkUrl ###################");
      print(response.body);
      dom.Document document = parse.parse(response.body);
      List<dom.Element> keywordElements = document.querySelectorAll('body');

      // 정보 출력
      for (var element in keywordElements) {
        final tds = element.querySelectorAll("td").forEach((element) {
          print(element.text.trim());
        });
      }
    }
  }

  Future<void> checkInfo(controller) async {
    print("################### checkInfo ###################");
    var html = await controller.evaluateJavascript(
        source:
        "window.document.getElementsByTagName('html')[0].outerHTML;");

    dom.Document document = parse.parse(html);

    List<dom.Element> keywordElements = document.querySelectorAll('body');

    // 정보 출력
    for (var element in keywordElements) {
      final tds = element.querySelectorAll("td").forEach((element) {
        print(element.text.trim());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: InAppWebView(
                initialUrlRequest:
                  URLRequest(
                      url: Uri.parse("http://172.30.1.83:8080/login2"), // local ip 주소 + 8080 포트 + spring에서 제공하는 main.jsp 파일 링크
                  ),
                initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                      javaScriptEnabled: true,
                      javaScriptCanOpenWindowsAutomatically: true,
                      useShouldOverrideUrlLoading: true,
                      mediaPlaybackRequiresUserGesture: false,
                    ),
                    android: AndroidInAppWebViewOptions(
                      useHybridComposition: true,
                    ),
                    ios: IOSInAppWebViewOptions(
                      allowsInlineMediaPlayback: true,
                    )
                ),
                pullToRefreshController: PullToRefreshController(
                  options: PullToRefreshOptions(
                    color: Colors.blue,
                  ),
                ),
                onLoadStop: (InAppWebViewController controller, Uri? url) async {
                  if(url.toString().contains("login2")) { // 본인인증 시작 url에 포함된 string
                    final _url = url.toString();
                    print("url : $_url");
                    var html = await controller.evaluateJavascript(
                        source:
                        "window.document.getElementsByTagName('html')[0].outerHTML;");

                    dom.Document document = parse.parse(html);

                    List<dom.Element> keywordElements = document.querySelectorAll('body');

                    for (var element in keywordElements) {

                      final input_m = element.querySelector("input[name=m]");
                      final input_encodeData = element.querySelector("input[name=EncodeData]");

                      if(input_m != null) {
                        m = input_m.outerHtml.split("value=").last.split(">")[0].replaceAll("\"", "");
                      }
                      if(input_encodeData != null) {
                        encodeData = input_encodeData.outerHtml.split("value=").last.split(">")[0].replaceAll("\"", "");
                      }
                    }
                    print("m = $m");
                    print("encodeData = $encodeData");

                  } else if(url.toString().contains("success")) { // 본인인증 성공 시, 이동하는 url에 포함된 string
                    print("url : $url");
                    var html = await controller.evaluateJavascript(
                        source:
                        "window.document.getElementsByTagName('html')[0].outerHTML;");

                    dom.Document document = parse.parse(html);

                    List<dom.Element> keywordElements = document.querySelectorAll('body');

                    // 정보 출력
                    for (var element in keywordElements) {
                      final tds = element.querySelectorAll("td").forEach((element) {
                        print(element.text.trim());
                        authInfo.add(element.text.trim());
                      });
                    }
                    inputInfo(authInfo); // 정보 저장
                    await checkUrl(encodeData); // url 체크 -- 값을 제대로 가져오지 못 함 -- 쿠기값 때문인 걸로 추정
                    await checkInfo(controller); // 정보 체크
                  }
                },
              )
            ),
          ],
        ),
      ),
    );
  }

}