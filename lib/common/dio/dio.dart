import 'package:actual/common/const/data.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  CustomInterceptor({required this.storage});

  // 1) 요청 보낼 때
  // 요청이 보내질 때마다
  // 만약에 요청의 Header에 accessToken: true 라는 값이 있다면
  // 실제 토큰을 가져와서 (storage에서) authorization: bearer $token으로
  // 헤더를 변경한다. -> 이렇게 하면 매 요청에서 토큰이 자동으로 들어가게 된다.
  // 또한 만약에 요청의 Header에 refreshToken: true 라는 값이 있다면
  // 실제 토큰을 가져와서 (storage에서) authorization: bearer $token으로
  // 헤더를 변경한다.
  // 이렇게 하면 매 요청에서 토큰이 자동으로 들어가게 된다.
  @override
  void onRequest(
      // onRequest는 요청이 보내지기 전에 가로채서 거기에 뭐를 넣어주는 것이다.
      RequestOptions options,
      RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}] ${options.uri}');

    if (options.headers['accessToken'] == 'true') {
      // 헤더 삭제
      options.headers.remove('accessToken');

      final token = await storage.read(key: ACCESS_TOKEN_KEY);

      // 실제 토큰으로 대체
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    if (options.headers['refreshToken'] == 'true') {
      options.headers.remove('refreshToken');

      final token = await storage.read(key: REFRESH_TOKEN_KEY);

      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    return super.onRequest(options, handler); // 실제 요청은 여기서 보내진다.
  }

// 2) 응답 받을 때
// 응답을 받는 코드는 비교적 쉬운데 응용을 해서
// 정상적인 응답을 보내고도 에러를 던지거나 그럴 수 있다!
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        '[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}'); // 응답을 받기 위해 보낸 요청을 찍어보자!

    return super.onResponse(response, handler);
  }

// 3) 에러 발생 시 -> 에러가 났을 때는 어떤 상황을 캐치하고 싶냐가 매우 중요!
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401 에러가 났을 때 (status code)
    // 토큰을 재발급 받는 시도를 하고 토큰이 재발급되면
    // 다시 새로운 토큰으로 요청을 한다.

    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    // refreshToken이 아예 없으면
    // 당연히 에러를 던진다.
    if (refreshToken == null) {
      // 에러를 돌려주는 방법: handler.reject를 사용하는데
      // onError 메서드의 매개변수인 저 err를 reject의 매개변수로 넣어준다.
      return handler.reject(err);
    }

    // response의 statusCode가 401이면 true, 아니면 false, false면 아예 다른 에러다!
    final isStatus401 = err.response?.statusCode == 401; // 응답이 없을 수도 있으니까 ?를씀

    // 과연 이 에러가 token을 refresh하다가 난 오류인가를 확인하는 곳이다.
    //요청의 경로가 /auth/token 이면 토큰을 요청하다 에러가 났다 이거다.
    // 이 말은 토큰을 받으려고 시도를 했지만 오류가 난 것이기 때문에 refreshToken 자체가 문제가 있다 이 말이다.
    // 그러면 새로 요청을 보내봤자 에러가 또 난다.
    // 그래서 이 경우에는 그냥 오류를 던지는 것이 맞다.(reject를 해줘야 함)
    final isPathRefresh = err.requestOptions.path == '/auth/token';

    // 만약에 401 에러가 났는데 요청의 경로가 /auth/token이 아니라면
    // dio를 새로 만들어서 토큰 refresh 요청을 한다.
    if (isStatus401 && !isPathRefresh) {
      final dio = Dio();

      // refreshToken으로 accessToken 재발을 시도를 했는데 실패를 하면 err를 던진다.
      try {
        final resp = await dio.post(
          'http://$ip/auth/token',
          options: Options(
            headers: {'authorization': 'Bearer $refreshToken'},
          ),
        );

        final accessToken = resp.data['accessToken'];

        // 여기까지 왔다는 것은 요청에 문제가 없다는 것이다!
        // 그러면 requestOptions를 가져와서
        // accessToken을 넣어준다.
        final options = err.requestOptions;

        options.headers.addAll({
          'authorization': 'Bearer $accessToken',
        });

        // 그런데 이렇게만 하면 이번 요청에서만 새로 발급된 토큰을 사용하게 되고
        // 다른 요청에서는 secureStorage에 있는 토큰을 사용하게 된다.
        // 그렇기 때문에 token의 원천인 secureStorage에도 저장을 해줘야 한다.
        // 이렇게 하면 다음 요청에서도 새로 발급된 토큰을 사용할 수 있다.
        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        // 그럼 우리가 보냈던 요청을 어떻게 다시 보내나?
        // 이렇게 하면 에러를 발생시킨 요청에 관련된 모든 옵션을 다시 받아서
        // 토큰만 바꾼 후 다시 요청을 보낼 수 있게 된다.
        final response = await dio.fetch(options);

        // 그래서 사실 에러가 났지만 우리가 돌려줘야 하는 값은
        // 요청이 잘 왔고 응답을 잘 보냈다 라는 것이다.
        // 이걸 쓰면 실제 요청을 한 화면에서는 마치 에러가 나지 않은 것처럼 인식을 할 수 있다.
        return handler.resolve(response);

        // } catch (e) { // 이렇게 하면 모든 에러!
      } on DioException catch (e) {
        // 이렇게 하면 dio에러
        return handler.reject(e);
      }
    }

    return handler.reject(err);
  }
}
