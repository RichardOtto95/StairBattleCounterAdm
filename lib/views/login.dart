import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stair_battle_counter/views/count_page.dart';
import 'package:stair_battle_counter/views/primary_button.dart';
import 'package:stair_battle_counter/views/utilities.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String username = "";
  String password = "";

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Batalha da Escada Adm",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff116D6E),
      ),
      body: SizedBox(
        width: maxWidth(context),
        child: Column(
          children: [
            const Spacer(flex: 8),
            SvgPicture.asset("assets/svg/escada.svg"),
            const Spacer(flex: 13),
            SizedBox(
              width: 328,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text("Usuário"),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff116D6E),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return "Preencha este campo";
                        }
                        return null;
                      },
                      onChanged: (value) => username = value,
                    ),
                    vSpace(15),
                    TextFormField(
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        label: Text("Senha"),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff116D6E),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return "Preencha este campo";
                        }
                        return null;
                      },
                      onChanged: (value) => password = value,
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(flex: 18),
            PrimaryButton(
              width: 310,
              height: 60,
              label: "Entrar",
              onTap: () async {
                if (_formKey.currentState!.validate()) {
                  final QuerySnapshot<Map<String, dynamic>> query =
                      await FirebaseFirestore.instance
                          .collection("adms")
                          .where("username", isEqualTo: username)
                          .where("password", isEqualTo: password)
                          .get();
                  if (query.docs.isEmpty) {
                    showToast("Usuário e/ou senha incorreto(s)");
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CountPage()));
                  }
                }
              },
            ),
            const Spacer(flex: 10),
          ],
        ),
      ),
    );
  }
}
