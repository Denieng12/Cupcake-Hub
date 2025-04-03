import 'package:flutter/material.dart';
import 'package:dreamflow/models/cart.dart';
import 'package:dreamflow/providers/cart_provider.dart';
import 'package:dreamflow/providers/auth_provider.dart';
import 'package:dreamflow/theme/app_theme.dart';
import 'package:dreamflow/screens/login_screen.dart';
import 'package:dreamflow/screens/confirmation_screen.dart';
import 'package:dreamflow/widgets/adaptive_layout.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _numeroController = TextEditingController();
  final _complementoController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();
  final _cepController = TextEditingController();

  String _paymentMethod = 'Cru00e9dito';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isAuthenticated) {
      final user = authProvider.user!;
      _nomeController.text = user.nome;
      _emailController.text = user.email;
      _telefoneController.text = user.telefone;
      _enderecoController.text = user.endereco;
      _numeroController.text = user.numero;
      _complementoController.text = user.complemento;
      _bairroController.text = user.bairro;
      _cidadeController.text = user.cidade;
      _estadoController.text = user.estado;
      _cepController.text = user.cep;
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _enderecoController.dispose();
    _numeroController.dispose();
    _complementoController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    _cepController.dispose();
    super.dispose();
  }

  void _submitOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call to submit order
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final totalItems = cartProvider.itemCount;
    final totalValue = cartProvider.total;

    // Clear cart
    cartProvider.limparCarrinho();

    setState(() {
      _isLoading = false;
    });

    // Navigate to confirmation screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmationScreen(
          orderNumber: DateTime.now().millisecondsSinceEpoch.toString().substring(5, 12),
          totalItems: totalItems,
          totalValue: totalValue,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finalizar Pedido'),
      ),
      body: cart.items.isEmpty
          ? _buildEmptyCart()
          : !authProvider.isAuthenticated
              ? _buildLoginPrompt()
              : _buildCheckoutForm(context, cart),
    );
  }

  Widget _buildLoginPrompt() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_circle_outlined,
              size: 100,
              color: AppTheme.primaryColor.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'Entre na sua conta',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Para finalizar seu pedido, voci\u00ea precisa estar logado na sua conta.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  ).then((_) {
                    // Reload after login
                    setState(() {});
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'ENTRAR',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'VOLTAR PARA A LOJA',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 24),
          Text(
            'Seu carrinho está vazio',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
            label: const Text('VOLTAR PARA LOJA'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutForm(BuildContext context, CartProvider cart) {
    // Layout adaptativo baseado no tamanho da tela
    return AdaptiveLayout(
      builder: (context, screenSize) {
        if (screenSize == ScreenSize.small) {
          // Layout original para telas pequenas
          return SingleChildScrollView(
            padding: ResponsiveSpacing.screenPadding(context),
            child: Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: ResponsiveSpacing.contentMaxWidth(context),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildOrderSummary(cart),
                      const SizedBox(height: 30),
                      _buildDeliveryInformation(),
                      const SizedBox(height: 30),
                      _buildPaymentMethod(),
                      const SizedBox(height: 30),
                      _buildSubmitButton(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          // Layout de duas colunas para telas maiores
          return SingleChildScrollView(
            padding: ResponsiveSpacing.screenPadding(context),
            child: Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: ResponsiveSpacing.contentMaxWidth(context),
                ),
                child: Form(
                  key: _formKey,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Coluna de informau00e7u00f5es de entrega e pagamento
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDeliveryInformation(),
                            const SizedBox(height: 30),
                            _buildPaymentMethod(),
                            if (screenSize == ScreenSize.medium)
                              Column(
                                children: [
                                  const SizedBox(height: 30),
                                  _buildSubmitButton(),
                                ],
                              ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                      const SizedBox(width: 32),
                      // Coluna do resumo do pedido
                      Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            _buildOrderSummary(cart),
                            if (screenSize == ScreenSize.large)
                              Column(
                                children: [
                                  const SizedBox(height: 30),
                                  _buildSubmitButton(),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildOrderSummary(CartProvider cart) {
    return Card(
      elevation: context.isDesktop ? 1 : 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(context.isDesktop ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumo do Pedido',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...cart.items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Text(
                      '${item.quantidade}x',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(item.cupcake.nome),
                    ),
                    Text(
                      'R\$ ${item.precoTotal.toStringAsFixed(2).replaceAll('.', ',')}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }).toList(),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Subtotal'),
                Text(
                  'R\$ ${cart.total.toStringAsFixed(2).replaceAll('.', ',')}',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Taxa de entrega'),
                Text('R\$ 5,00'),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'R\$ ${(cart.total + 5.0).toStringAsFixed(2).replaceAll('.', ',')}',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informau00e7u00f5es de Entrega',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _nomeController,
          decoration: const InputDecoration(
            labelText: 'Nome Completo',
            prefixIcon: Icon(Icons.person),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, informe seu nome';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 6,
              child: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, informe seu e-mail';
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'Informe um e-mail vu00e1lido';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 4,
              child: TextFormField(
                controller: _telefoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe seu telefone';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _enderecoController,
          decoration: const InputDecoration(
            labelText: 'Endereu00e7o',
            prefixIcon: Icon(Icons.location_on),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, informe seu endereu00e7o';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: _numeroController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Nu00famero',
                  prefixIcon: Icon(Icons.pin),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o nu00famero';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 7,
              child: TextFormField(
                controller: _complementoController,
                decoration: const InputDecoration(
                  labelText: 'Complemento (opcional)',
                  prefixIcon: Icon(Icons.apartment),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _bairroController,
          decoration: const InputDecoration(
            labelText: 'Bairro',
            prefixIcon: Icon(Icons.location_city),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, informe seu bairro';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 6,
              child: TextFormField(
                controller: _cidadeController,
                decoration: const InputDecoration(
                  labelText: 'Cidade',
                  prefixIcon: Icon(Icons.location_city),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe sua cidade';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 4,
              child: TextFormField(
                controller: _estadoController,
                decoration: const InputDecoration(
                  labelText: 'Estado',
                  prefixIcon: Icon(Icons.map),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe seu estado';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _cepController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'CEP',
            prefixIcon: Icon(Icons.pin_drop),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, informe seu CEP';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPaymentMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mu00e9todo de Pagamento',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                RadioListTile<String>(
                  title: Row(
                    children: [
                      Icon(Icons.credit_card, color: AppTheme.primaryColor),
                      const SizedBox(width: 12),
                      const Text('Cartão de Crédito'),
                    ],
                  ),
                  value: 'Crédito',
                  groupValue: _paymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _paymentMethod = value!;
                    });
                  },
                  activeColor: AppTheme.primaryColor,
                ),
                RadioListTile<String>(
                  title: Row(
                    children: [
                      Icon(Icons.credit_card, color: AppTheme.primaryColor),
                      const SizedBox(width: 12),
                      const Text('Cartão de Débito'),
                    ],
                  ),
                  value: 'Débito',
                  groupValue: _paymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _paymentMethod = value!;
                    });
                  },
                  activeColor: AppTheme.primaryColor,
                ),
                RadioListTile<String>(
                  title: Row(
                    children: [
                      Icon(Icons.money, color: AppTheme.primaryColor),
                      const SizedBox(width: 12),
                      const Text('Dinheiro na Entrega'),
                    ],
                  ),
                  value: 'Dinheiro',
                  groupValue: _paymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _paymentMethod = value!;
                    });
                  },
                  activeColor: AppTheme.primaryColor,
                ),
                RadioListTile<String>(
                  title: Row(
                    children: [
                      Icon(Icons.qr_code, color: AppTheme.primaryColor),
                      const SizedBox(width: 12),
                      const Text('Pix'),
                    ],
                  ),
                  value: 'Pix',
                  groupValue: _paymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _paymentMethod = value!;
                    });
                  },
                  activeColor: AppTheme.primaryColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitOrder,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'CONFIRMAR PEDIDO',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}