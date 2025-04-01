import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dreamflow/providers/auth_provider.dart';
import 'package:dreamflow/theme/app_theme.dart';
import 'package:dreamflow/screens/login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _resetSuccess = false;

  @override
  void dispose() {
    _codeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.resetPassword(
      _codeController.text.trim(),
      _newPasswordController.text,
    );

    if (success && mounted) {
      setState(() {
        _resetSuccess = true;
      });
    }
  }

  void _goToLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Redefinir Senha'),
      ),
      body: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                _buildHeader(),
                const SizedBox(height: 40),
                if (!_resetSuccess) ..._buildResetForm(auth) else _buildSuccessContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Icon(
          _resetSuccess ? Icons.check_circle_outline : Icons.lock_open_outlined,
          size: 80,
          color: _resetSuccess ? Colors.green : AppTheme.primaryColor,
        ),
        const SizedBox(height: 16),
        Text(
          _resetSuccess ? 'Senha Alterada!' : 'Redefinir Senha',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: _resetSuccess ? Colors.green : AppTheme.primaryColor,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          _resetSuccess
              ? 'Sua senha foi redefinida com sucesso'
              : 'Digite o cu00f3digo recebido e sua nova senha',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  List<Widget> _buildResetForm(AuthProvider auth) {
    return [
      Text(
        'E-mail: ${widget.email}',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      const SizedBox(height: 24),
      TextFormField(
        controller: _codeController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'Cu00f3digo de Verificau00e7u00e3o',
          prefixIcon: Icon(Icons.pin),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, informe o cu00f3digo recebido';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _newPasswordController,
        obscureText: _obscurePassword,
        decoration: InputDecoration(
          labelText: 'Nova Senha',
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, informe sua nova senha';
          }
          if (value.length < 6) {
            return 'A senha deve ter pelo menos 6 caracteres';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _confirmPasswordController,
        obscureText: _obscureConfirmPassword,
        decoration: InputDecoration(
          labelText: 'Confirmar Nova Senha',
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, confirme sua nova senha';
          }
          if (value != _newPasswordController.text) {
            return 'As senhas nu00e3o coincidem';
          }
          return null;
        },
      ),
      if (auth.errorMessage != null) ...[                
        const SizedBox(height: 16),
        Text(
          auth.errorMessage!,
          style: TextStyle(color: AppTheme.errorColor),
          textAlign: TextAlign.center,
        ),
      ],
      const SizedBox(height: 32),
      SizedBox(
        height: 56,
        child: ElevatedButton(
          onPressed: auth.isLoading ? null : _resetPassword,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 0,
          ),
          child: auth.isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  'REDEFINIR SENHA',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    ];
  }

  Widget _buildSuccessContent() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green.shade300),
          ),
          child: Column(
            children: [
              const Text(
                'Sua senha foi redefinida com sucesso. Vocu00ea ju00e1 pode fazer login com sua nova senha.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: _goToLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
            ),
            child: const Text(
              'IR PARA LOGIN',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}