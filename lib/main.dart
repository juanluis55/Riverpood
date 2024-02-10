import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
void main() {
  
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Riverpood',
      theme: ThemeData(
      
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 228, 228, 228)),
        useMaterial3: true,
      ),
      home: const ProductPage(),
    );
  }
}
class Product{
  Product({required this.name, required this.price});

  final String name;
  final double price;
}

final _products = [
  Product(name: "Hamburgesa", price: 10),
  Product(name: "Pizza", price: 6),
  Product(name: "Caldo de Pollo", price: 9),
  Product(name: "Platanos", price: 10),
  Product(name: "Pollo", price: 2),
];
enum ProductSortType{
  name,
  price,
}
final productSortTypeProvider = StateProvider<ProductSortType>((ref) => 
ProductSortType.name);
final futureProductsProvider = FutureProvider<List<Product>>((ref) async {
  await Future.delayed(const Duration(seconds: 3));
  final sortType = ref.watch(productSortTypeProvider);
switch (sortType) {
    case ProductSortType.name:
       _products.sort((a, b) => a.name.compareTo(b.name));
       break;
    case ProductSortType.price:
       _products.sort((a, b) => a.price.compareTo(b.price));
}
  return _products;
});
class ProductPage extends ConsumerWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final productsProvider = ref.watch(futureProductsProvider);

productsProvider.when(
            data: (products)=> ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
                    child: Card(
                      color: Colors.blueAccent,
                      elevation: 3,
                      child: ListTile(
                        title: Text(products[index].name,style: const TextStyle(
                            color: Colors.white,  fontSize: 15)),
                        subtitle: Text("${products[index].price}",style: const TextStyle(
                            color: Colors.white,  fontSize: 15)),
                      ),
                    ),
                  );
                }),
            error: (err, stack) => Text("Error: $err",style: const TextStyle(
                color: Colors.white,  fontSize: 15)),
            loading: ()=> const Center(child: CircularProgressIndicator(color: Colors.white,)),
        );

    return Scaffold(
        appBar: AppBar(
          title: const Text("Lista de Comidas"),
          actions: [
            DropdownButton<ProductSortType>(
              dropdownColor: Colors.brown,
              value: ref.watch(productSortTypeProvider),
                items: const [
                  DropdownMenuItem(
                    value: ProductSortType.name,
                    child: Icon(Icons.sort_by_alpha),
                ),
                  DropdownMenuItem(
                    value: ProductSortType.price,
                    child: Icon(Icons.sort),
                  ),
                ],
                onChanged: (value)=> ref.watch(productSortTypeProvider.notifier).state = value!
            ),
          ],
        ),
      backgroundColor: Colors.lightBlue,
      body: Container(
        child: productsProvider.when(
            data: (products)=> ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
                    child: Card(
                      color: Colors.blueAccent,
                      elevation: 3,
                      child: ListTile(
                        title: Text(products[index].name,style: const TextStyle(
                            color: Colors.white,  fontSize: 15)),
                        subtitle: Text("${products[index].price}",style: const TextStyle(
                            color: Colors.white,  fontSize: 15)),
                      ),
                    ),
                  );
                }),
            error: (err, stack) => Text("Error: $err",style: const TextStyle(
                color: Colors.white,  fontSize: 15)),
            loading: ()=> const Center(child: CircularProgressIndicator(color: Colors.white,)),
        ),
      )
    );
  }
}








 