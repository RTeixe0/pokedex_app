import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokédex App',
      theme: ThemeData.dark(),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text('Entrar na Pokédex'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PokedexScreen()),
            );
          },
        ),
      ),
    );
  }
}

class PokedexScreen extends StatefulWidget {
  const PokedexScreen({super.key});

  @override
  State<PokedexScreen> createState() => _PokedexScreenState();
}

class _PokedexScreenState extends State<PokedexScreen> {
  List pokemons = [];

  @override
  void initState() {
    super.initState();
    fetchPokemons();
  }

  Future<void> fetchPokemons() async {
    final url = Uri.parse("https://pokeapi.co/api/v2/pokemon?limit=10");
    final response = await http.get(url);
    final data = json.decode(response.body);

    setState(() {
      pokemons = data['results'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pokédex')),
      body: pokemons.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: pokemons.length,
              itemBuilder: (context, index) {
                final name = pokemons[index]['name'];
                final imageUrl =
                    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${index + 1}.png';

                return ListTile(
                  leading: Image.network(imageUrl),
                  title: Text(name.toUpperCase()),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.qr_code),
onPressed: () {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Acesse a Pokédex online'),
      content: SizedBox(
        width: 200,
        height: 200,
        child: QrImageView(
          data: 'https://www.pokemon.com/br/pokedex',
          version: QrVersions.auto,
          size: 200.0,
        ),
      ),
    ),
  );
},
      ),
    );
  }
}
