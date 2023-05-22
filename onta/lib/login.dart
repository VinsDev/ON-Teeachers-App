import 'package:flutter/material.dart';
import 'package:onta/colors/colors.dart';
import 'package:onta/home.dart';
import 'package:onta/models/first.dart';
import 'package:onta/services/http_helper.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  School stat = School(success: false, schoolName: "schoolName");

  bool loggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor,
      body: Visibility(
          visible: loggedIn,
          replacement: Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/map_shape.png'))),
            child: ListView(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.1),
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(195, 51, 37, 172),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Orbital Node',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: 0.8),
                            ),
                            const Text(
                              "Teacher's App Login",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 189, 242, 255),
                                  letterSpacing: 0.5),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              width: double.maxFinite,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: const Color.fromARGB(207, 255, 255, 255),
                              ),
                              child: Center(
                                child: TextFormField(
                                  controller: usernameController,
                                  decoration: const InputDecoration.collapsed(
                                      hintText: "Enter your Username"),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              width: double.maxFinite,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: const Color.fromARGB(207, 255, 255, 255),
                              ),
                              child: Center(
                                child: TextFormField(
                                  controller: passwordController,
                                  decoration: const InputDecoration.collapsed(
                                      hintText: "Enter your Password"),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: (() {
                                send();
                              }),
                              child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color.fromARGB(255, 75, 75, 75),
                                        blurRadius: 1.2,
                                      )
                                    ],
                                    color:
                                        const Color.fromARGB(207, 14, 10, 253),
                                  ),
                                  child: const Center(
                                      child: Text(
                                    'Login',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        letterSpacing: 0.5),
                                  ))),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ]),
          ),
          child: const HomePage()),
    );
  }

  send() async {
    var status = await RemoteService("/staffLogin")
        .login(usernameController.text, passwordController.text);
    stat = status;

    if (stat.success) {
      setState(() {
        loggedIn = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Wrong username or password")));
    }
  }
}
