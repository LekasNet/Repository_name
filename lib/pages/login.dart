import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color actientColor = Color(0x60000000);
const Color secondColor = Color(0x09000000);

class LoginPage extends StatelessWidget {

  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late bool checkboxValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: 50,
            margin: EdgeInsets.only(top: 40, left: 0, right: 0),
            child: Center(
              child: Text(
                'Авторизация',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
              ),
            )
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: secondColor,
                  borderRadius: BorderRadius.circular(6)
                ),
                child: Center(
                  child: TextField(
                  cursorColor: const Color(0xff000000),
                  cursorWidth: 1,
                  controller: loginController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.fromLTRB(
                        21, 5, 21, 7),
                    hintText: 'Логин',
                    hintStyle: TextStyle(color: actientColor),
                  ),
                   style: const TextStyle(fontSize: 18),
                ),
              ),
              ),
              const SizedBox(height: 25,),
              Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: secondColor,
                      borderRadius: BorderRadius.circular(6)
                  ),
                  child: Center(
                    child: TextField(
                      cursorColor: const Color(0xff000000),
                      cursorWidth: 1,
                      controller: loginController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(
                            21, 5, 21, 7),
                        hintText: 'Пароль',
                        hintStyle: TextStyle(color: actientColor),
                      ),
                      style: const TextStyle(fontSize: 18),
                    ),
                  )
              ),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    checkColor: actientColor,
                    activeColor: secondColor,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: actientColor, strokeAlign: BorderSide.strokeAlignInside, width: 1, style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                    value: checkboxValue,
                    onChanged: (newValue) => {},
                  ),
                  Text(
                    "Запомнить меня",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: actientColor.withAlpha(100), fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
              SizedBox(height: 15,),
              GestureDetector(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xff0b6bfe),
                    borderRadius: BorderRadius.circular(6)
                  ),
                  child: const Center(
                    child: Text(
                      'Войти',
                      style: TextStyle(color: Colors.white, fontSize: 17, fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25,),
              GestureDetector(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Color(0xff0b6bfe), width: 1.5, style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(6)
                  ),
                  child: const Center(
                    child: Text(
                      'Регистрация',
                      style: TextStyle(color: Color(0xff0b6bfe), fontSize: 17, fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 7,),
              GestureDetector(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                  ),
                  child: const Center(
                    child: Text(
                      'Восстановить пароль',
                      style: TextStyle(color: actientColor, fontSize: 17, fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

