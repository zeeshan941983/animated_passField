import 'dart:developer';

import 'package:flutter/material.dart';

class AnimatedPage extends StatefulWidget {
  const AnimatedPage({super.key});

  @override
  State<AnimatedPage> createState() => _AnimatedPageState();
}

class _AnimatedPageState extends State<AnimatedPage>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  bool containsCapital = false;
  bool containsSmall = false;
  bool containsSpecial = false;
  bool containsEight = false;
  bool hasFocus = false;
  late AnimationController animationController;

  late Animation<double> animation;

  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        setState(() {
          log(animation.value.toString());
        });
      });
    animation = Tween<double>(begin: 0, end: 380).animate(animationController);
    setState(() {});
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          hasFocus = true;
        });
      } else {
        setState(() {
          hasFocus = false;
        });
      }
    });
    animationController.forward();
  }

  void validateInput(String input) {
    setState(() {
      containsCapital = RegExp(r'[A-Z]').hasMatch(input);
      containsSmall = RegExp(r'[a-z]').hasMatch(input);
      containsSpecial =
          RegExp(r'[!@#\$%^&*(),.?":{}|<>~\-_=+;' '\\[\\]]').hasMatch(input);
      containsEight = input.length >= 8;
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 470,
              left: 0,
              right: 0,
              child: AnimatedContainer(
                height: hasFocus ? 300 : 0,
                curve: Curves.easeInOutCubic,
                duration: const Duration(milliseconds: 500),
                width: double.infinity,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.blue,
                ),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 1000),
                  opacity: hasFocus ? 1 : 0,
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: containsCapital ? 1 : 0.5,
                          child: ListTile(
                            title: const Text(
                              'Capital Letter',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            trailing: Icon(
                              containsCapital
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: containsSmall ? 1 : 0.5,
                          child: ListTile(
                            title: const Text(
                              'Small Letter',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            trailing: Icon(
                              containsSmall ? Icons.check_circle : Icons.cancel,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: containsSpecial ? 1 : 0.5,
                          child: ListTile(
                            title: const Text(
                              'Special Character',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            trailing: Icon(
                              containsSpecial
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: containsEight ? 1 : 0.5,
                          child: ListTile(
                            title: const Text(
                              'Eight Characters',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            trailing: Icon(
                              containsEight ? Icons.check_circle : Icons.cancel,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 600),
              top: animation.value,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  focusNode: focusNode,
                  controller: _controller,
                  onChanged: validateInput,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                      ),
                      isDense: true,
                      fillColor: Colors.white,
                      filled: true,
                      suffixIcon: Icon(Icons.remove_red_eye)),
                ),
              ),
            ),
            // : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
