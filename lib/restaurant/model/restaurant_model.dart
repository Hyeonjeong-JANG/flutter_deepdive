import 'package:actual/common/const/data.dart';
import 'package:actual/common/utils/data_utils.dart';
import 'package:json_annotation/json_annotation.dart';

/**
 * json serializable을 사용하면 fromJson을 자동으로 만들어준다.
 * @JsonSerializable() 사용법
 * 1. 파일 상단에 part 'restaurant_model.g.dart'; 추가
 * 2. @JsonSerializable() 추가
 * 3. 터미널에 flutter pub run build_runner build 실행
 * - flutter pub run build_runner build를 하면 코드가 생성이 될 수 있는 모든 파일에서 코드가 생성이 된다. 
 * - flutter pub run build_runner watch를 하면 1회성이 아니라 빌드때마다 실행된다.
 * 4. 기존 factory 메서드 빌더? 자리에 factory RestaurantModel.fromJson(Map<String, dynamic> json) => _$RestaurantModelFromJson(json); 를 대신 써준다. 
 * - 이렇게 하면 fromJson을 사용하던 final pItem = RestaurantModel.fromJson(json: item); 자리에서 에러가 나는데 json이 없어서 그렇다. final pItem = RestaurantModel.fromJson(item);이렇게 고쳐주면 됨.
 */
part 'restaurant_model.g.dart';

enum RestaurantPriceRange {
  expensive,
  medium,
  cheap,
}

@JsonSerializable()
class RestaurantModel {
  final String id;
  final String name;

  /// 이렇게 하면 제이슨으로부터 가져온 썸유알엘의 값을
  /// 어노테이션의 파라미터로 넣고
  /// 하단에 static으로 정의된 pathToUrl 함수가 실행되고
  /// 그 값이 final String thumbUrl; 의 값으로 들어간다.
  @JsonKey(fromJson: DataUtils.pathToUrl)
  final String thumbUrl;
  final List<String> tags;
  final RestaurantPriceRange priceRange;
  final double ratings;
  final int ratingsCount;
  final int deliveryTime;
  final int deliveryFee;

  const RestaurantModel({
    required this.id,
    required this.thumbUrl,
    required this.name,
    required this.tags,
    required this.priceRange,
    required this.ratings,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$RestaurantModelToJson(this); // toJson은 잘 안 씀

  // DataUtils로 이동
  // static pathToUrl(String value) {
  //   return 'http://$ip$value';
  // } // 이름을 아무렇게나 넣어도 되는데 첫 번째 매개변수 안에 어노테이션에 정의한 그 값이 들어간다. final String thumbUrl;여기의 thumbUrl이 여기의 value다.
}
