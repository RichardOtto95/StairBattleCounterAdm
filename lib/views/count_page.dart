import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'primary_button.dart';
import 'utilities.dart';

class CountPage extends StatefulWidget {
  const CountPage({super.key});

  @override
  State<CountPage> createState() => _CountPageState();
}

class _CountPageState extends State<CountPage> {
  String firstCompetitor = "";

  String secondCompetitor = "";

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
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("sections").where(
            "status",
            whereIn: ["OPEN", "CLOSED", "ACCURATE"],
          ).snapshots(),
          builder: (context, sectionSnap) {
            if (!sectionSnap.hasData) {
              return Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              );
            }
            if (sectionSnap.data!.docs.isEmpty) {
              return Column(
                children: [
                  const Spacer(flex: 5),
                  SizedBox(
                    width: 328,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              label: Text("Participante 1"),
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
                            onChanged: (value) => firstCompetitor = value,
                          ),
                          vSpace(15),
                          TextFormField(
                            decoration: const InputDecoration(
                              label: Text("Participante 2"),
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
                            onChanged: (value) => secondCompetitor = value,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(flex: 51),
                  PrimaryButton(
                    width: 310,
                    height: 60,
                    label: "Criar",
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        getConfirmPopup(
                          "Criar sessão",
                          "Tem certeza de que deseja criar uma sessão?",
                          () {
                            FirebaseFirestore.instance
                                .collection("sections")
                                .add(Section(
                                  createdAt: DateTime.now(),
                                  firstCompetitor: firstCompetitor,
                                  secondCompetitor: secondCompetitor,
                                  firstCompetitorVotes: 0,
                                  secondCompetitorVotes: 0,
                                  voters: [],
                                  status: "CLOSED",
                                ).toJson())
                                .then((value) => value.update({
                                      "created_at":
                                          FieldValue.serverTimestamp(),
                                      "id": value.id,
                                    }));
                            Navigator.pop(context);
                          },
                        );
                      }
                    },
                  ),
                  const Spacer(flex: 10),
                ],
              );
            } else {
              Section section = Section.fromDoc(sectionSnap.data!.docs.first);

              return Column(
                children: [
                  const Spacer(flex: 7),
                  Text(
                    "Votação ${section.status == "CLOSED" ? "fechada" : section.status == "OPEN" ? "aberta" : "apurada"}",
                    style: const TextStyle(
                      color: Color(0xff321E1E),
                      fontSize: 28,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                  const Spacer(flex: 7),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              Text(
                                section.firstCompetitor,
                                style: const TextStyle(
                                  color: Color(0xff321E1E),
                                  fontSize: 28,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                              ),
                              vSpace(60),
                              Result(
                                bigger: section.firstCompetitorVotes >
                                    section.secondCompetitorVotes,
                                value: section.firstCompetitorVotes,
                                enable: section.status == "ACCURATE",
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 3,
                        height: 360,
                        decoration: BoxDecoration(
                          color: const Color(0xffcfcfcf),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              Text(
                                section.secondCompetitor,
                                style: const TextStyle(
                                  color: Color(0xff321E1E),
                                  fontSize: 28,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                              ),
                              vSpace(60),
                              Result(
                                bigger: section.secondCompetitorVotes >
                                    section.firstCompetitorVotes,
                                value: section.secondCompetitorVotes,
                                enable: section.status == "ACCURATE",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(flex: 15),
                  if (section.status == "CLOSED")
                    PrimaryButton(
                      width: 310,
                      height: 60,
                      label: "Abrir",
                      onTap: () async {
                        await update(section, "OPEN");
                      },
                    ),
                  if (section.status == "OPEN") ...[
                    PrimaryButton(
                      width: 310,
                      height: 60,
                      label: "Fechar",
                      color: Color(0xffCD1818),
                      onTap: () async {
                        await update(section, "CLOSED");
                      },
                    ),
                    vSpace(15),
                    PrimaryButton(
                      width: 310,
                      height: 60,
                      label: "Encerrar",
                      onTap: () async {
                        getConfirmPopup(
                          "Encerrar batalha",
                          "Deseja mesmo encerrar esta batalha? Os eleitores não poderam mais visualizar a apuração!",
                          () async {
                            await update(section, "ACCURATE");
                          },
                        );
                      },
                    ),
                  ],
                  if (section.status == "ACCURATE")
                    PrimaryButton(
                      width: 310,
                      height: 60,
                      label: "Nova Batalha",
                      onTap: () async {
                        await update(section, "FINISHED");
                      },
                    ),
                  const Spacer(flex: 9),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future update(Section section, String newStatus) async {
    OverlayEntry entry = overlayProgressIndicator();
    Overlay.of(context).insert(entry);
    try {
      await FirebaseFirestore.instance
          .collection("sections")
          .doc(section.id)
          .update({"status": newStatus});
    } catch (e) {
      showToast("Algo de errado ocorreu");
    }
    entry.remove();
  }

  getConfirmPopup(String title, String content, void Function() onConfirm) {
    showDialog(
      context: context,
      useRootNavigator: true,
      builder: (context) {
        return AlertDialog(
          elevation: 5,
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Não",
                style: TextStyle(color: Color(0xffCD1818)),
              ),
            ),
            TextButton(
              onPressed: onConfirm,
              child:
                  const Text("Sim", style: TextStyle(color: Color(0xff116D6E))),
            ),
          ],
        );
      },
    );
  }
}

class Section {
  Section({
    required this.createdAt,
    required this.firstCompetitor,
    required this.secondCompetitor,
    required this.firstCompetitorVotes,
    required this.secondCompetitorVotes,
    required this.voters,
    required this.status,
    this.id,
  });

  DateTime createdAt;

  String firstCompetitor;

  String secondCompetitor;

  int firstCompetitorVotes;

  int secondCompetitorVotes;

  /// Can be: [OPEN, CLOSED, ACCURATE, FINISHED]
  String status;

  String? id;

  List<String> voters;

  factory Section.fromDoc(DocumentSnapshot doc) => Section(
        id: doc.id,
        createdAt: doc.get("created_at").toDate(),
        firstCompetitor: doc.get("first_competitor"),
        secondCompetitor: doc.get("second_competitor"),
        firstCompetitorVotes: doc.get("first_competitor_votes"),
        secondCompetitorVotes: doc.get("second_competitor_votes"),
        voters: List.from(doc.get("voters")),
        status: doc.get("status"),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt,
        "first_competitor": firstCompetitor,
        "second_competitor": secondCompetitor,
        "first_competitor_votes": firstCompetitorVotes,
        "second_competitor_votes": secondCompetitorVotes,
        "voters": voters,
        "status": status,
      };
}

class Result extends StatelessWidget {
  const Result({
    super.key,
    required this.bigger,
    required this.value,
    required this.enable,
  });

  final bool bigger;

  final int value;

  final bool enable;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      width: 131,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: enable ? Colors.white : const Color(0xffcccccc),
        border: Border.all(
          color: enable ? const Color(0xff917B7B) : const Color(0xffcccccc),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            offset: const Offset(0, 3),
            color: Colors.black.withOpacity(.3),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        enable ? value.toString() : "",
        style: TextStyle(
          color: bigger ? const Color(0xff116D6E) : const Color(0xffCD1818),
          fontSize: 28,
        ),
      ),
    );
  }
}
