import '../Coffees/coffee_response.dart';
import 'cart_item_create_request.dart';
import 'cart_response.dart';

class CartItemMapper {
  static CartItemCreateDTO fromDataToDTO(CartItemData data, String userId) {
    return CartItemCreateDTO(
      userId: userId,
      coffeeId: data.coffeeData?.coffeeId,
      size: data.size,
      quantity: data.quantity?.toString(),
    );
  }

  static CartItemData fromDTOToData(CartItemCreateDTO dto) {
    return CartItemData(
      size: dto.size,
      quantity: int.tryParse(dto.quantity ?? '0'),
      coffeeData: CoffeeData(coffeeId: dto.coffeeId),
    );
  }
}
