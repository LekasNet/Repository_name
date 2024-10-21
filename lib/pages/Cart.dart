import 'package:adyshkin_pcs/globals.dart';
import 'package:adyshkin_pcs/tremplates/CardTemplate.dart';
import 'package:flutter/material.dart';
import 'package:adyshkin_pcs/presentation/models/positionModel.dart';
import 'package:google_fonts/google_fonts.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Метод для пересчета общей суммы
  int calculateTotalPrice() {
    return items
        .where((item) => item.added > 0)
        .fold(0, (sum, item) => sum + (item.price * item.added));
  }

  @override
  Widget build(BuildContext context) {
    // Фильтруем список, чтобы включать только элементы с added > 0
    List<PositionModel> filteredItems = items.where((item) => item.added > 0).toList();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              width: MediaQuery.sizeOf(context).width,
              padding: const EdgeInsets.only(top: 60, left: 30),
              child: Text(
                'Корзина',
                textAlign: TextAlign.left,
                style: GoogleFonts.montserrat(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  height: 24 / 28,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(), // Отключаем скролл у ListView
                    shrinkWrap: true, // Подгоняем размер ListView под количество элементов
                    itemCount: filteredItems.length, // Используем отфильтрованный список
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: CardTemplate(
                          item: item,
                          onQuantityChanged: () {
                            setState(() {
                              // Обновляем состояние для пересчета суммы
                            });
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Сумма',
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.w500, // Medium
                        ),
                      ),
                      Text(
                        '${calculateTotalPrice()} ₽', // Выводим пересчитанную сумму и символ рубля
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.w500, // Medium
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 80), // Добавляем отступ, чтобы не перекрывать текст кнопкой
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 60, // Учитываем отступы по 30 с каждой стороны
          child: ElevatedButton(
            onPressed: () {
              // Логика перехода к оформлению заказа
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff1a6fee),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16), // Высота кнопки
            ),
            child: Text(
              'Перейти к оформлению заказа',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
