import 'package:flutter/material.dart';
import 'package:dreamflow/models/cupcake.dart';
import 'package:dreamflow/services/cupcake_service.dart';
import 'package:dreamflow/theme/app_theme.dart';
import 'package:dreamflow/screens/product_detail_screen.dart';
import 'package:dreamflow/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CatalogScreen extends StatefulWidget {
  final String? initialCategory;

  const CatalogScreen({Key? key, this.initialCategory}) : super(key: key);

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> with SingleTickerProviderStateMixin {
  final CupcakeService _cupcakeService = CupcakeService();
  late List<String> _categories;
  late String _selectedCategory;
  late List<Cupcake> _filteredCupcakes;
  late TabController _tabController;
  String _sortOption = 'Nome';

  @override
  void initState() {
    super.initState();
    _categories = ['Todos', ..._cupcakeService.getCategories()];
    _selectedCategory = widget.initialCategory ?? 'Todos';
    
    // Find the index of the selected category
    int initialIndex = _categories.indexOf(_selectedCategory);
    if (initialIndex < 0) initialIndex = 0; // Default to 'Todos' if not found
    
    _tabController = TabController(
      length: _categories.length, 
      vsync: this, 
      initialIndex: initialIndex,
    );
    
    _tabController.addListener(_handleTabSelection);
    _updateFilteredCupcakes();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _selectedCategory = _categories[_tabController.index];
        _updateFilteredCupcakes();
      });
    }
  }

  void _updateFilteredCupcakes() {
    if (_selectedCategory == 'Todos') {
      _filteredCupcakes = _cupcakeService.getAll();
    } else {
      _filteredCupcakes = _cupcakeService.getByCategory(_selectedCategory);
    }
    _sortCupcakes();
  }

  void _sortCupcakes() {
    switch (_sortOption) {
      case 'Nome':
        _filteredCupcakes.sort((a, b) => a.nome.compareTo(b.nome));
        break;
      case 'Preu00e7o - Menor para Maior':
        _filteredCupcakes.sort((a, b) => a.preco.compareTo(b.preco));
        break;
      case 'Preu00e7o - Maior para Menor':
        _filteredCupcakes.sort((a, b) => b.preco.compareTo(a.preco));
        break;
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catu00e1logo'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (String value) {
              setState(() {
                _sortOption = value;
                _sortCupcakes();
              });
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'Nome',
                child: Text('Ordenar por Nome'),
              ),
              const PopupMenuItem<String>(
                value: 'Preu00e7o - Menor para Maior',
                child: Text('Preu00e7o - Menor para Maior'),
              ),
              const PopupMenuItem<String>(
                value: 'Preu00e7o - Maior para Menor',
                child: Text('Preu00e7o - Maior para Menor'),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _categories.map((category) => Tab(text: category)).toList(),
          indicatorColor: AppTheme.primaryColor,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: AppTheme.textColor,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_filteredCupcakes.length} cupcakes encontrados',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _filteredCupcakes.isEmpty
                  ? _buildEmptyState()
                  : _buildCupcakeGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.no_food,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhum cupcake encontrado',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Tente selecionar outra categoria',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCupcakeGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _filteredCupcakes.length,
      itemBuilder: (context, index) {
        return _buildCupcakeCard(_filteredCupcakes[index]);
      },
    );
  }

  Widget _buildCupcakeCard(Cupcake cupcake) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(cupcakeId: cupcake.id),
          ),
        ).then((_) {
          // Refresh data when returning from detail screen
          setState(() {
            _updateFilteredCupcakes();
          });
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: Hero(
                tag: 'cupcake_image_${cupcake.id}',
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                          '${cupcake.imagem}?w=300&h=300'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            // Details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          cupcake.nome,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cupcake.descricao,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'R\$ ${cupcake.preco.toStringAsFixed(2).replaceAll('.', ',')}',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          cartProvider.adicionarItem(cupcake);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  '${cupcake.nome} adicionado ao carrinho!'),
                              duration: const Duration(seconds: 2),
                              backgroundColor: AppTheme.secondaryColor,
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add_shopping_cart,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}