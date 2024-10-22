import 'package:flutter/material.dart';
import 'package:test/screens/Diagnosis/screens/diagnosis.dart';
import 'package:test/screens/Diagnosis/screens/retinopathy.dart';
import 'package:test/widgets/backButton.dart';

class SelectDiagnosis extends StatefulWidget {
  static const routeName = '/select-diagnosis';

  const SelectDiagnosis({super.key});

  @override
  State<SelectDiagnosis> createState() => _SelectDiagnosisState();
}

class _SelectDiagnosisState extends State<SelectDiagnosis> {
  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context)!.settings.arguments as Map;
    final user = route['user'];
    final type = route['type'];

    return Scaffold(
      body: Stack(
        children: [
          const Image(
            image: AssetImage('assets/images/eclipse.png'),
          ),
          Container(
            margin: const EdgeInsets.only(left: 0.0, top: 50, right: 30),
            child: Align(
              alignment: Alignment.topRight,
              child: Image.asset(
                'assets/images/authLogo.png',
                height: 80,
                width: 80,
              ),
            ),
          ),
          backButton(context),
          SizedBox(
            width: double.infinity,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 43.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Title(
                          color: Colors.black,
                          child: const Text(
                            "Diagnose Now!",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(Diagnosis.routeName,
                              arguments: {
                                "type": type,
                                "user": user,
                                "dis": "chest"
                              });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          width: 150,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                    blurRadius: 15,
                                    color: Color.fromARGB(255, 198, 198, 198))
                              ],
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(children: [
                            Image.asset(
                              'assets/images/lungs.png',
                              height: 60,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Chest",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            )
                          ]),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(Diagnosis.routeName,
                              arguments: {
                                "type": type,
                                "user": user,
                                "dis": "breast"
                              });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          width: 150,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                    blurRadius: 15,
                                    color: Color.fromARGB(255, 208, 208, 208))
                              ],
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(children: [
                            Image.asset(
                              'assets/images/breast.png',
                              height: 60,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Breast",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            )
                          ]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const Retinopathy()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          width: 150,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                    blurRadius: 15,
                                    color: Color.fromARGB(255, 204, 204, 204))
                              ],
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(children: [
                            Image.asset(
                              'assets/images/retinopathy.png',
                              height: 60,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Retinopathy",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            )
                          ]),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(Diagnosis.routeName,
                              arguments: {
                                "type": type,
                                "user": user,
                                "dis": "kidney"
                              });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          width: 150,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                    blurRadius: 15,
                                    color: Color.fromARGB(255, 204, 204, 204))
                              ],
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(children: [
                            Image.asset(
                              'assets/images/kidney.png',
                              height: 60,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Kidney",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            )
                          ]),
                        ),
                      ),
                    ],
                  ),
                ]),
          ),
        ],
      ),
    );
  }
}
