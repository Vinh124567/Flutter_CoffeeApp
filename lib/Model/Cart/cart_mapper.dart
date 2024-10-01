import '../Coffees/coffee_response.dart';
import 'cart_item_create_request.dart';
import 'cart_response.dart';

class CartItemMapper {
  // Chuyển từ CartItemData sang CartItemCreateDTO
  static CartItemCreateDTO fromDataToDTO(CartItemData data, String userId) {
    return CartItemCreateDTO(
      userId: userId,
      coffeeId: data.coffeeData?.coffeeId, // Lấy coffeeId từ coffeeData
      size: data.size,
      quantity: data.quantity?.toString(), // Chuyển đổi quantity từ int sang String
    );
  }

  // Chuyển từ CartItemCreateDTO sang CartItemData
  static CartItemData fromDTOToData(CartItemCreateDTO dto) {
    return CartItemData(
      size: dto.size,
      quantity: int.tryParse(dto.quantity ?? '0'), // Chuyển đổi quantity từ String sang int
      coffeeData: CoffeeData(coffeeId: dto.coffeeId), // Tạo đối tượng CoffeeData với coffeeId
    );
  }
}
