import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:web3auth_flutter/enums.dart';
import 'package:web3auth_flutter/input.dart';
import 'package:web3auth_flutter/output.dart';
import 'dart:async';

import 'package:web3auth_flutter/web3auth_flutter.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _result = '';
  bool logoutVisible = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final themeMap = HashMap<String, String>();
    themeMap['primary'] = "#229954";

    Uri redirectUrl;
    if (Platform.isAndroid) {
      redirectUrl = Uri.parse('w3a://com.example.w3aflutter/auth');
    } else if (Platform.isIOS) {
      redirectUrl = Uri.parse('com.example.w3aflutter://openlogin');
    } else {
      throw UnKnownException('Unknown platform');
    }

    final loginConfig = HashMap<String, LoginConfigItem>();
    loginConfig['jwt'] = LoginConfigItem(
        verifier: "web3auth-core-firebase", // get it from web3auth dashboard
        typeOfLogin: TypeOfLogin.jwt,
        name: "Custom JWT Login",
        clientId:
            "BHZPoRIHdrfrdXj5E8G5Y72LGnh7L8UFuM8O0KrZSOs4T8lgiZnebB5Oc6cbgYSo3qSz7WBZXIs8fs6jgZqFFgw" // web3auth's plug and play client id
        );

    await Web3AuthFlutter.init(Web3AuthOptions(
        clientId:
            'BHZPoRIHdrfrdXj5E8G5Y72LGnh7L8UFuM8O0KrZSOs4T8lgiZnebB5Oc6cbgYSo3qSz7WBZXIs8fs6jgZqFFgw',
        network: Network.testnet,
        redirectUrl: redirectUrl,
        whiteLabel: WhiteLabelData(
            dark: true, name: "Web3Auth Flutter App", theme: themeMap),
        loginConfig: loginConfig));

    // const String privateKey =
    //     '20623a6a7d966af49b926f4c83ec3d5aea89480872310c41831aba73a82539a0';
    // const String rpcUrl = 'https://rpc.ankr.com/eth';

    // final client = Web3Client(rpcUrl, Client());
    // final credentials = EthPrivateKey.fromHex(privateKey);
    // final address = credentials.address;
    // print(address.hexEip55);
    // print(await client.getBalance(address));
  }

  @override
  Widget build(BuildContext context) {
    // Map<String, dynamic> user = jsonDecode(_result);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Web3Auth x Flutter Example'),
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
              ),
              Visibility(
                visible: !logoutVisible,
                child: Column(
                  children: [
                    const Icon(
                      Icons.flutter_dash,
                      size: 80,
                      color: Color(0xFF1389fd),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      'Web3Auth',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 36,
                          color: Color(0xFF0364ff)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Welcome to Web3Auth x Flutter Demo',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Login with',
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                                255, 72, 133, 237) // This is what you need!
                            ),
                        onPressed: _login(_withGoogle),
                        child: const Text('Google')),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                                255, 59, 89, 152) // This is what you need!
                            ),
                        onPressed: _login(_withFacebook),
                        child: const Text('Facebook')),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                                255, 114, 137, 218) // This is what you need!
                            ),
                        onPressed: _login(_withDiscord),
                        child: const Text('Discord')),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                                255, 3, 59, 54) // This is what you need!
                            ),
                        onPressed: _login(_withEmailPasswordless),
                        child: const Text('Email Passwordless')),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                                255, 245, 130, 13) // This is what you need!
                            ),
                        onPressed: _login(_withJWT),
                        child: const Text('Login with JWT via Firebase')),
                  ],
                ),
              ),
              Visibility(
                // ignore: sort_child_properties_last
                child: Column(
                  children: [
                    Center(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.red[600] // This is what you need!
                              ),
                          onPressed: _logout(),
                          child: Column(
                            children: const [
                              Text('Logout'),
                            ],
                          )),
                    ),
                    const Text(
                      'Blockchain calls',
                      style: TextStyle(fontSize: 20),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                                255, 195, 47, 233) // This is what you need!
                            ),
                        onPressed: _getAddress,
                        child: const Text('Get Address')),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                                255, 195, 47, 233) // This is what you need!
                            ),
                        onPressed: _getBalance,
                        child: const Text('Get Balance')),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                                255, 195, 47, 233) // This is what you need!
                            ),
                        onPressed: _sendTransaction,
                        child: const Text('Send Transaction')),
                  ],
                ),
                visible: logoutVisible,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(_result),
              )
            ],
          )),
        ),
      ),
    );
  }

  VoidCallback _login(Future<Web3AuthResponse> Function() method) {
    return () async {
      try {
        final Web3AuthResponse response = await method();
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('privateKey', response.privKey.toString());
        setState(() {
          _result = response.toString();
          logoutVisible = true;
        });
      } on UserCancelledException {
        print("User cancelled.");
      } on UnKnownException {
        print("Unknown exception occurred");
      }
    };
  }

  VoidCallback _logout() {
    return () async {
      try {
        setState(() {
          _result = '';
          logoutVisible = false;
        });
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('privateKey');
        await Web3AuthFlutter.logout();
      } on UserCancelledException {
        print("User cancelled.");
      } on UnKnownException {
        print("Unknown exception occurred");
      }
    };
  }

  Future<Web3AuthResponse> _withGoogle() {
    return Web3AuthFlutter.login(LoginParams(
      loginProvider: Provider.google,
      mfaLevel: MFALevel.DEFAULT,
    ));
  }

  Future<Web3AuthResponse> _withFacebook() {
    return Web3AuthFlutter.login(LoginParams(loginProvider: Provider.facebook));
  }

  Future<Web3AuthResponse> _withEmailPasswordless() {
    return Web3AuthFlutter.login(LoginParams(
        loginProvider: Provider.email_passwordless,
        extraLoginOptions:
            ExtraLoginOptions(login_hint: "shahbaz+flutterdemo@web3auth.io")));
  }

  Future<Web3AuthResponse> _withJWT() async {
    var idToken = "";
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: 'custom+jwt@firebase.login', password: 'Testing@123');
      idToken = (await credential.user?.getIdToken(true)).toString();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }

    return Web3AuthFlutter.login(LoginParams(
        loginProvider: Provider.jwt,
        extraLoginOptions:
            ExtraLoginOptions(id_token: idToken, domain: 'anything')));
  }

  Future<Web3AuthResponse> _withDiscord() {
    return Web3AuthFlutter.login(LoginParams(loginProvider: Provider.discord));
  }

  Future<String> _getAddress() async {
    final prefs = await SharedPreferences.getInstance();
    final privateKey = prefs.getString('privateKey') ?? '0';
    const String rpcUrl = 'https://rpc.ankr.com/eth_goerli';

    final client = Web3Client(rpcUrl, Client());
    final credentials = EthPrivateKey.fromHex(privateKey);
    final address = credentials.address;
    print(address.hexEip55);
    setState(() {
      _result = address.hexEip55.toString();
    });
    return address.hexEip55;
  }

  Future<EtherAmount> _getBalance() async {
    final prefs = await SharedPreferences.getInstance();
    final privateKey = prefs.getString('privateKey') ?? '0';
    // const String privateKey =
    //     '20623a6a7d966af49b926f4c83ec3d5aea89480872310c41831aba73a82539a0';
    const String rpcUrl = 'https://rpc.ankr.com/eth_goerli';

    final client = Web3Client(rpcUrl, Client());
    final credentials = EthPrivateKey.fromHex(privateKey);
    final address = credentials.address;
    final balance = await client.getBalance(address);
    print(balance);
    setState(() {
      _result = balance.toString();
    });
    return balance;
  }

  Future<String> _sendTransaction() async {
    final prefs = await SharedPreferences.getInstance();
    final privateKey = prefs.getString('privateKey') ?? '0';
    const String rpcUrl = 'https://rpc.ankr.com/eth_goerli';

    final client = Web3Client(rpcUrl, Client());
    final credentials = EthPrivateKey.fromHex(privateKey);
    final address = credentials.address;
    final receipt = await client.sendTransaction(
        credentials,
        Transaction(
          from: address,
          to: EthereumAddress.fromHex(
              '0x809D4310d578649D8539e718030EE11e603Ee8f3'),
          // gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 100),
          value: EtherAmount.fromUnitAndValue(
              EtherUnit.gwei, 5000000), // 0.005 ETH
        ),
        chainId: 5);
    print(receipt);
    setState(() {
      _result = receipt;
    });
    return receipt;
  }
}
