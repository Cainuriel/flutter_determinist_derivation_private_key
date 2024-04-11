import 'package:flutter/material.dart';
import 'package:web3dart/crypto.dart' as crypto;
import 'package:web3dart/web3dart.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final rng = Random.secure();
  final password = 'your_password'; // Cambia 'your_password' por tu contraseña
  String? randomMnemonic;
  late Wallet wallet;
  late String seed;
  List<Wallet> wallets = [];

  @override
  void initState() {
    super.initState();
    generateWallet();
  }

  Future<void> generateWallet() async {
    randomMnemonic = bip39.generateMnemonic();
    debugPrint("seed $randomMnemonic");
    seed = bip39.mnemonicToSeedHex(randomMnemonic!);
    bip32.BIP32 root = bip32.BIP32.fromSeed(crypto.hexToBytes(seed));
    bip32.BIP32 derivation = root.derivePath("m/44'/60'/0'/0/0");
    List<int> privateKeyBytes = derivation.privateKey!;
    // await LocalStorage.instance.saveSeedWallet(randomMnemonic);
    final seedEthType =
        EthPrivateKey.fromHex(crypto.bytesToHex(privateKeyBytes));
    setState(() {
      wallet = Wallet.createNew(seedEthType, password, rng);
      wallets.add(wallet);
      debugPrint('First public Key: ${wallets[0].privateKey.address}');
    });
  }

  Future<void> deriveNewKeyPair() async {
    bip32.BIP32 root = bip32.BIP32.fromSeed(crypto.hexToBytes(seed));
    int currentIndex = wallets
        .length; // Usar la longitud de la lista de billeteras como índice
    bip32.BIP32 derivation = root.derivePath("m/44'/60'/0'/0/$currentIndex");
    List<int> privateKeyBytes = derivation.privateKey!;
    Wallet newWallet = Wallet.createNew(
        EthPrivateKey.fromHex(crypto.bytesToHex(privateKeyBytes)),
        password,
        rng);
    setState(() {
      wallets.add(newWallet);
      debugPrint('Public Key: ${wallets[currentIndex].privateKey.address}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24.0),
              child: const Text(
                'Seed:',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(randomMnemonic!,
                  style: const TextStyle(
                      letterSpacing: 0.5,
                      color: Colors.black,
                      fontFamily: "Sans",
                      fontWeight: FontWeight.w600,
                      fontSize: 19.0)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: deriveNewKeyPair,
              child: const Text('Derive New Key Pair'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: wallets.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Account ${index + 1}'),
                    subtitle: Text(
                        'Public Key: ${wallets[index].privateKey.address} Private Key: ${crypto.bytesToHex(wallets[index].privateKey.privateKey)}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
