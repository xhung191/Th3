import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'basic computer',
      theme: ThemeData(useMaterial3: true),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  String? _operator; // phép toán đang được chọn: + - * /
  String _result = '';

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  // Tính toán và cập nhật kết quả ngay lập tức
  void _calculate() {
    if (_operator == null) {
      setState(() => _result = '');
      return;
    }

    final double? a = double.tryParse(_controller1.text.trim());
    final double? b = double.tryParse(_controller2.text.trim());

    if (a == null || b == null) {
      setState(() => _result = 'Vui lòng nhập số hợp lệ');
      return;
    }

    double value;
    switch (_operator) {
      case '+':
        value = a + b;
        break;
      case '-':
        value = a - b;
        break;
      case '*':
        value = a * b;
        break;
      case '/':
        if (b == 0) {
          setState(() => _result = 'Không thể chia cho 0');
          return;
        }
        value = a / b;
        break;
      default:
        return;
    }

    setState(() => _result = _format(value));
  }

  // Số nguyên thì bỏ phần thập phân (8.0 -> 8)
  String _format(double v) {
    if (v == v.truncateToDouble()) return v.toInt().toString();
    return v.toStringAsFixed(4).replaceFirst(RegExp(r'0+$'), '');
  }

  void _selectOperator(String op) {
    _operator = op;
    _calculate();
  }

  Widget _buildInput(TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: true,
      ),
      onChanged: (_) => _calculate(),
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.black87),
        ),
      ),
    );
  }

  Widget _buildOpButton(String op, Color color) {
    final bool selected = _operator == op;
    return GestureDetector(
      onTap: () => _selectOperator(op),
      child: Container(
        width: 64,
        height: 64,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: selected
              ? Border.all(color: Colors.black, width: 3)
              : Border.all(color: Colors.transparent, width: 3),
        ),
        child: Text(
          op,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 120),
              const Center(
                child: Text(
                  'basic computer',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 80),

              // Ô nhập số thứ nhất
              _buildInput(_controller1),
              const SizedBox(height: 24),

              // Hàng 4 nút phép toán
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildOpButton('+', const Color(0xFFE04848)),
                  _buildOpButton('-', const Color(0xFFDDA83F)),
                  _buildOpButton('*', const Color(0xFF5B3FDB)),
                  _buildOpButton('/', const Color(0xFF1E1E1E)),
                ],
              ),
              const SizedBox(height: 24),

              // Ô nhập số thứ hai
              _buildInput(_controller2),
              const SizedBox(height: 20),

              // Kết quả
              Text(
                'Kết quả: $_result',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
