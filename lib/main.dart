import 'package:clipboard/clipboard.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fire/logout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire/add.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(home: mainpage()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DIALER',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 239, 164, 89)),
        useMaterial3: true,
      ),

      home: const MyHomePage(
        title: 'DIALER',
      ),
      debugShowCheckedModeBanner: false,

      // theme:ThemeData(brightness:Brightness.light),
      // darkTheme: ThemeData(brightness: Brightness.dark),
      // themeMode: ThemeMode.light,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isload = false;
  List<Map<String, dynamic>>? items;
  var user = FirebaseAuth.instance.currentUser!.email;
  var collection = FirebaseFirestore.instance
      .collection(FirebaseAuth.instance.currentUser!.email as String);

  _incrementCounter() async {
    List<Map<String, dynamic>> temp = [];
    var data = await collection.get();
    data.docs.forEach((e) {
      temp.add(e.data());
    });

    // collection.add({"NAME": "HABEEB SALEH AL HUSSAIN"});
    // var a = await collection.get();
    // var b = a.docs.first.id;
    // collection.doc(b).set({"NAME": "HABEEB SALEH",
    // "No":"9032789348"});

    setState(() {
      items = temp;
      // if (isload == false)
      //   isload = true;
      // else
      //   isload = false;
      // _counter = a.size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
        ),
        actions: [
          TextButton(
            child: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => logout()));
            },
          ),
        ],
      ),
      body:
          // isload?
          StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("$user").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _incrementCounter();

                  return ListView.builder(
                    itemCount: items?.length,
                    itemBuilder: (context, Index) {
                      return Card(
                        color: Color.fromARGB(255, 212, 151, 122),
                        child: ListTile(
                          title: Text(items?[Index]["NAME"] ?? "UNKNOWN"),
                          subtitle: Text(items?[Index]["No"] ?? "UNAVAILABLE"),
                          onLongPress: () async {
                            await FlutterClipboard.copy(FirebaseFirestore
                                .instance
                                .collection("$user")
                                .doc(snapshot.data!.docs[Index].get("No"))
                                .id);
                          },
                          leading: CircleAvatar(
                            child: InkWell(
                              onDoubleTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          "Delete this contact?",
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                FirebaseFirestore.instance
                                                    .collection("$user")
                                                    .doc(snapshot
                                                        .data!.docs[Index].id)
                                                    .delete();

                                                Navigator.pop(context);
                                              },
                                              child: Text("DELETE")),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("BACK"))
                                        ],
                                      );
                                    });
                              },
                              onLongPress: () {},
                            ),
                            backgroundColor: Colors.black,
                          ),
                          trailing: Container(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 50,
                                ),
                                Container(
                                  child: IconButton(
                                    icon: Icon(Icons.copy),
                                    onPressed: () async {
                                      var v = Text(FirebaseFirestore.instance
                                          .collection("$user")
                                          .doc(snapshot.data!.docs[Index]
                                              .get("No"))
                                          .id);
                                      print("copied");
                                      print(v);
                                      FlutterClipboard.copy(v as String);
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                    child: IconButton(
                                  icon: Icon(Icons.call),
                                  onPressed: () {
                                    FlutterPhoneDirectCaller.callNumber(
                                        items![Index]["No"]);
                                  },
                                ))
                              ],
                            ),
                            width: 150,
                            height: 100,
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("NO DATA"),
                  );
                } else
                  return Center(child: CircularProgressIndicator());
              }),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MyWidget()));
          },
          tooltip: 'ADD',
          child: Icon(Icons.add)),
      backgroundColor: const Color.fromARGB(255, 255, 156, 119),
    );
  }
}

class loading extends StatefulWidget {
  const loading({Key? key}) : super(key: key);

  @override
  State<loading> createState() => _loadingState();
}

class _loadingState extends State<loading> {
  var load = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageState();
  }

  _pageState() async {
    await Future.delayed(Duration(seconds: 2));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MyApp()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(
            height: 370,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyApp()));
            },
            child: Center(
              child: SpinKitSpinningLines(
                color: Colors.grey,
                duration: Duration(seconds: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////////////
class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  var a = TextEditingController();
  var b = TextEditingController();
  var v = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign In',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 239, 164, 89),
      ),
      body: SingleChildScrollView(
          child: Column(children: <Widget>[
        SizedBox(
          height: 250,
        ),
        TextField(
          controller: a,
          decoration: InputDecoration(
              hintText: 'EMAIL',
              enabledBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 3),
                  borderRadius: BorderRadius.circular(30)),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.black,
              ),
              suffixText: ''),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: b,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 3),
              borderRadius: BorderRadius.circular(30),
            ),
            hintText: 'PASSWORD',
            prefixIcon: Icon(
              Icons.password,
              color: Colors.black,
            ),
            suffixIcon: IconButton(
              icon: v ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
              onPressed: () => setState(
                () => v = !v,
              ),
            ),
          ),
          obscureText: !v,
        ),
        SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: signIn,
          child: Container(
            child: Text(
              'Sign In',
              style:
                  TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 16),
            ),
            padding: EdgeInsets.all(7),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color.fromARGB(255, 249, 138, 97)),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => reset()));
          },
          child: Text(
            'Forgot Password?',
            style: (TextStyle(color: Colors.blue)),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'dont have an account?',
        ),
        TextButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => signup()));
            },
            child: Text('signup'))
      ])),
      backgroundColor: Color.fromARGB(255, 255, 156, 119),
    );
  }

  Future signIn() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
          email: a.text.trim(),
          password: b.text.trim(),
        )
        .then((value) => Navigator.push(
            context, MaterialPageRoute(builder: (context) => mainpage())));
  }
}

///////////////////////////////////////////////////////////////////////////////////////////
class mainpage extends StatelessWidget {
  const mainpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return loading();
            } else {
              return login();
            }
          }),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////////

class signup extends StatefulWidget {
  const signup({Key? key}) : super(key: key);

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  var a = TextEditingController();
  var b = TextEditingController();
  var c = TextEditingController();
  var v = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign Up',
          style: TextStyle(color: Colors.black),
        ), //fromARGB(255, 229, 23, 181)
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 239, 164, 89),
      ),
      body: SingleChildScrollView(
          child: Form(
        child: Column(children: <Widget>[
          SizedBox(
            height: 250,
          ),
          TextFormField(
            controller: a,
            decoration: InputDecoration(
                hintText: 'EMAIL',
                enabledBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 3),
                    borderRadius: BorderRadius.circular(30)),
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                suffixText: ''),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (email) =>
                email != null && !EmailValidator.validate(email)
                    ? 'enter valid email'
                    : null,
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: b,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 3),
                borderRadius: BorderRadius.circular(30),
              ),
              hintText: 'PASSWORD',
              prefixIcon: Icon(
                Icons.password,
                color: Colors.black,
              ),
              suffixIcon: IconButton(
                icon: v ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                onPressed: () => setState(
                  () => v = !v,
                ),
              ),
            ),
            obscureText: !v,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) =>
                value != null && value.length <= 6 ? 'invalid' : null,
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: c,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 3),
                borderRadius: BorderRadius.circular(30),
              ),
              hintText: 'PASSWORD',
              prefixIcon: Icon(
                Icons.password,
                color: Colors.black,
              ),
              suffixIcon: IconButton(
                icon: v ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                onPressed: () => setState(
                  () => v = !v,
                ),
              ),
            ),
            obscureText: !v,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => value == b.text && value!.length >= 6
                ? null
                : "Pass doesn't match",
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              try {
                FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: a.text, password: b.text);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => loading()));
              } on FirebaseAuthException catch (e) {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          content: Text(e.message!.trim()),
                        ));
              }
            },
            child: Container(
              child: Text(
                'Sign Up',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              padding: EdgeInsets.all(7),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color.fromARGB(255, 249, 138, 97)),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Text('Already have an account?'),
          TextButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => login()));
              },
              child: Text('Sign In'))
        ]),
      )),
      backgroundColor: const Color.fromARGB(255, 255, 156, 119),
    );
  }
}

// Future signUp() async {
//     await FirebaseAuth.instance
//         .createUserWithEmailAndPassword(
//           email: a.text.trim(),
//           password: b.text.trim(),
//         )
//         .then((value) => Navigator.push(
//             context, MaterialPageRoute(builder: (context) => mainpage())));
//   }
// }

class Utils {
  static showSnackBar(String? text) {
    final messengerkey = GlobalKey<ScaffoldMessengerState>();
    if (text == null) return;

    final snackBar = SnackBar(content: Text(text));
    messengerkey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}

////////////////////////////////////////////////////////////////////////////////////
class reset extends StatefulWidget {
  const reset({Key? key}) : super(key: key);

  @override
  State<reset> createState() => _resetState();
}

class _resetState extends State<reset> {
  final a = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PASSWORD RESET',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color.fromARGB(255, 239, 164, 89),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 200,
            ),
            TextFormField(
              controller: a,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Enter Email'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) =>
                  email != null && !EmailValidator.validate(email)
                      ? 'invalid'
                      : null,
            ),
            SizedBox(
              height: 50,
            ),
            MaterialButton(
              onPressed: send,
              child: Text(
                'RESET',
                style: TextStyle(color: Colors.black),
              ),
              color: const Color.fromARGB(255, 249, 138, 97),
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 156, 119),
    );
  }

  Future send() async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: a.text);
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text('check your email'),
            ));
  }
}
