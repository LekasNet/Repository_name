import 'package:adyshkin_pcs/globals.dart';
import 'package:adyshkin_pcs/tremplates/CardTemplate.dart';
import 'package:flutter/material.dart';
import 'package:adyshkin_pcs/presentation/models/positionModel.dart';
import 'package:google_fonts/google_fonts.dart';


class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: Colors.white,
            width: MediaQuery.sizeOf(context).width,
            padding: EdgeInsets.only(top: 60, left: 30),
            child: Text(
              'Каталог услуг',
              textAlign: TextAlign.left,
              style: GoogleFonts.montserrat(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                height: 24 / 28
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30),
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height, // Задайте желаемую высоту для списка
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
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
            ),
          ),
        ],
      ),
    );
    ;
  }
}
