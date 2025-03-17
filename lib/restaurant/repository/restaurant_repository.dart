import 'package:actual/restaurant/model/restaurant_detail_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

part 'restaurant_repository.g.dart';

/// retrofit을 사용하면 api요청부터 모델로 만드는 과정까지를 자동화할 수 있다.
/// 이 파일에서는 메서드를 정의만 하고 구체적으로 바디를 정의하진 않는다.
/// 그러면  retrofit이 알아서 restaurant_repository.g.dart 파일 안에 이 함수들이 어떻게 실행이 되어야 하는지 정의해 준다.
///
@RestApi()
abstract class RestaurantRepository {
  // http://$ip/restaurant -> 여기까지는 공통으로 쓰고 @GET() 매개변수에 그 이후의 url을 넣는다.
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
      _RestaurantRepository;

  // @GET('/') // 전체 요청 주소: http://$ip/restaurant/
  // () paginate() {}

  /// 메서드 앞에는 반드시 반환받을 데이터와 완전히 똑같은 모델을 적어줘야 하는데 통신을 통해 데이터를 받기 때문에 Future로 싸줘야한다.
  @GET(
      '/{id}') // 전체 요청 주소: http://$ip/restaurant/:id -> retrofit에서는 {id}로 써야 한다.
  @Headers({
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InRlc3RAY29kZWZhY3RvcnkuYWkiLCJzdWIiOiJmNTViMzJkMi00ZDY4LTRjMWUtYTNjYS1kYTlkN2QwZDkyZTUiLCJ0eXBlIjoiYWNjZXNzIiwiaWF0IjoxNzQyMjEzODUyLCJleHAiOjE3NDIyMTQxNTJ9.WI39OFSLoXid4Osf2rhKJr8QKxKFIE2KfVdaMgixbcQ'
  }) // 원래 이렇게 넣지 않는데 일단 이렇게 넣어둠.
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id,
    // @Path('id') required String sid, -> 이렇게 할 수도 있다.
  });
}
