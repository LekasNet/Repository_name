import 'package:adyshkin_pcs/presentation/models/positionModel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardTemplate extends StatefulWidget {
  final PositionModel item;
  final VoidCallback onQuantityChanged; // Добавляем колбэк

  const CardTemplate({Key? key, required this.item, required this.onQuantityChanged}) : super(key: key);

  @override
  _CardTemplateState createState() => _CardTemplateState();
}

class _CardTemplateState extends State<CardTemplate> {
  @override
  Widget build(BuildContext context) {
    double baseWidth = MediaQuery.of(context).size.width;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    String _pluralize(int number, List<String> forms) {
      if (number % 10 == 1 && number % 100 != 11) {
        return forms[0]; // "пациент"
      } else if (number % 10 >= 2 && number % 10 <= 4 && (number % 100 < 10 || number % 100 >= 20)) {
        return forms[1]; // "пациента"
      } else {
        return forms[2]; // "пациентов"
      }
    }

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0x6fbbbbbb), width: 1.3),
            borderRadius: BorderRadius.circular(16),
          ),
          height: 142,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 14, left: 14, right: 20),
                child: Text(
                  widget.item.text,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w400,
                    fontSize: 16 * ffem,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.item.added < 1
                            ? Text(
                          widget.item.duration,
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        )
                            : const SizedBox(height: 0),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.item.price} ₽',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w400,
                            fontSize: 19,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: widget.item.added > 0
                        ? Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            '${widget.item.added} ${_pluralize(widget.item.added, ['пациент', 'пациента', 'пациентов'])}',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: widget.item.added > 1
                              ? () {
                            setState(() {
                              widget.item.added--;
                              widget.onQuantityChanged(); // Обновляем сумму
                            });
                          }
                              : null,
                          icon: const Icon(Icons.remove),
                          color: widget.item.added > 1
                              ? Colors.grey
                              : Colors.grey.withOpacity(0.5),
                        ),
                        Container(
                          width: 1,
                          height: 20,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              widget.item.added++;
                              widget.onQuantityChanged(); // Обновляем сумму
                            });
                          },
                          icon: const Icon(Icons.add),
                          color: Colors.grey,
                        ),
                      ],
                    )
                        : ElevatedButton(
                      onPressed: () {
                        setState(() {
                          widget.item.added++;
                          widget.onQuantityChanged(); // Обновляем сумму
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff1a6fee),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        minimumSize: const Size(0, 46),
                      ),
                      child: Text(
                        'Добавить',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (widget.item.added > 0)
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.close),
              color: const Color(0xFF666666),
              onPressed: () {
                setState(() {
                  widget.item.added = 0;
                  widget.onQuantityChanged(); // Обновляем сумму
                });
              },
            ),
          ),
      ],
    );
  }
}
