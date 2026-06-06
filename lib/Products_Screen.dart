import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse("https://hadi.olivosoft.com/products.php"),
      );

      if (response.statusCode == 200) {
        await Future.delayed(const Duration(seconds: 1));
        final jsonData = jsonDecode(response.body);

        final List fetched = [];
        if (jsonData is Map) {
          if (jsonData.containsKey('products') &&
              jsonData['products'] is List) {
            fetched.addAll(List.from(jsonData['products']));
          } else if (jsonData.containsKey('data') && jsonData['data'] is List) {
            fetched.addAll(List.from(jsonData['data']));
          }
        } else if (jsonData is List) {
          fetched.addAll(List.from(jsonData));
        }

        setState(() {
          products = fetched;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue.shade50,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/online-shopping.png",
              height: 28,
              color: Colors.purple.shade600,
            ),
            SizedBox(width: 15),
            const Text(
              "Our Collections",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("❤️ Favorites: Coming soon!")),
                );
              },
              icon: const Icon(
                Icons.favorite_outline,
                color: Colors.red,
                size: 28,
              ),
            ),
          ),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
          ? const Center(child: Text("No products found"))
          : ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];

                final id = product["id"];
                const baseImageUrl = "https://hadi.olivosoft.com/images";
                final String imageUrl = (id != null)
                    ? "$baseImageUrl/product_${id}.jpg"
                    : (product["image"]?.toString() ?? "");

                String formatPrice(dynamic p) {
                  if (p == null) return "0.00";
                  if (p is num) return p.toStringAsFixed(2);
                  final parsed = double.tryParse(p.toString());
                  return parsed != null
                      ? parsed.toStringAsFixed(2)
                      : p.toString();
                }

                return Card(
                  margin: const EdgeInsets.only(bottom: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            imageUrl,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                height: 100,
                                width: 100,
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 100,
                                width: 100,
                                color: Colors.grey.shade300,
                                child: const Icon(Icons.broken_image, size: 32),
                              );
                            },
                          ),
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product["name"].toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(product["rating"].toString()),
                                ],
                              ),

                              const SizedBox(height: 8),

                              Text(
                                "\$${formatPrice(product["price"])}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        ElevatedButton(
                          onPressed: () {},
                          child: const Text("Buy"),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
