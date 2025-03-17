import 'package:actual/common/const/data.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';

// "detail": "오늘 주문하면 배송비 3000원 할인!",
//   "products": [ // 프로덕트는 리스트니까 여기에 해당되는 모델을 또 만든다.
//     {
//       "id": "1952a209-7c26-4f50-bc65-086f6e64dbbd",
//       "name": "마라맛 코팩 떡볶이",
//       "imgUrl": "/img/img.png",
//       "detail": "서울에서 두번째로 맛있는 떡볶이집! 리뷰 이벤트 진행중~",
//       "price": 8000
//     }
class RestaurantDetailModel extends RestaurantModel {
  // extends 하면 새로 필드들을 선언할 필요가 없다.
  final String detail;
  final List<RestaurantProductModel>
      products; // 리스트는 별도로 아래에 모델을 만들어서 그걸 리스트의 타입으로 받는다.
  RestaurantDetailModel({
    required super.id,
    required super.thumbUrl,
    required super.name,
    required super.tags,
    required super.priceRange,
    required super.ratings,
    required super.ratingsCount,
    required super.deliveryTime,
    required super.deliveryFee,
    required this.detail,
    required this.products,
  });

  factory RestaurantDetailModel.fromJson({
    required Map<String, dynamic> json,
  }) {
    return RestaurantDetailModel(
      id: json['id'],
      thumbUrl: 'http://$ip${json['thumbUrl']}',
      name: json['name'],
      tags: List<String>.from(json['tags']),
      priceRange: RestaurantPriceRange.values
          .firstWhere((e) => e.name == json['priceRange']),
      ratings: json['ratings'],
      ratingsCount: json['ratingsCount'],
      deliveryTime: json['deliveryTime'],
      deliveryFee: json['deliveryFee'],
      detail: json['detail'],
      products: json['products']
          .map<RestaurantProductModel>(
            // RestaurantProductModel 타입으로 매핑하지 않으면 dynamic 타입이 자동으로 들어간 것으로 추론이 된다.
            (x) => RestaurantProductModel(
              id: x['id'],
              name: x['name'],
              imgUrl: x['imgUrl'],
              detail: x['detail'],
              price: x['price'],
            ),
          )
          .toList(), // products는 리스트이기때문에 마음대로 리스트로 넣을 수 없다.
    );
  }
}

//       "id": "1952a209-7c26-4f50-bc65-086f6e64dbbd",
//       "name": "마라맛 코팩 떡볶이",
//       "imgUrl": "/img/img.png",
//       "detail": "서울에서 두번째로 맛있는 떡볶이집! 리뷰 이벤트 진행중~",
//       "price": 8000
class RestaurantProductModel {
  final String id;
  final String name;
  final String imgUrl;
  final String detail;
  final int price;

  const RestaurantProductModel({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.detail,
    required this.price,
  });
}
