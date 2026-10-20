import 'package:flutter/material.dart';
import 'package:pa_mobile/theme/app_colors.dart';

/// Halaman percakapan demo lokal; pesan tidak dikirim ke server/toko.
class StoreChatPage extends StatefulWidget {
  const StoreChatPage({super.key});

  @override
  State<StoreChatPage> createState() => _StoreChatPageState();
}

class _StoreChatPageState extends State<StoreChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = ['Halo! Ada yang bisa kami bantu soal produk atau servis?'];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final message = _controller.text.trim();
    if (message.isEmpty) return;
    setState(() {
      _messages.add(message);
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: context.appBackground,
      appBar: AppBar(
        titleSpacing: 4,
        leadingWidth: 48,
        title: Row(children: [
          CircleAvatar(
            backgroundColor: colors.primaryContainer,
            foregroundColor: colors.onPrimaryContainer,
            child: const Icon(Icons.storefront_rounded),
          ),
          const SizedBox(width: 10),
          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Chat BengkelKOM', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            Text('Balasan otomatis • Demo', style: TextStyle(fontSize: 11)),
          ]),
        ]),
      ),
      body: Column(children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.appSurfaceContainerLow,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            'Ini simulasi chat. Pesan hanya tampil di perangkat dan tidak dikirim ke toko.',
            style: TextStyle(fontSize: 12, color: context.appTextSecondary),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final isUser = index > 0;
              return Align(
                alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * .78),
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isUser ? colors.primary : context.appSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: isUser ? null : Border.all(color: context.appBorderSubtle),
                  ),
                  child: Text(
                    _messages[index],
                    style: TextStyle(fontSize: 13, color: isUser ? colors.onPrimary : context.appTextPrimary),
                  ),
                ),
              );
            },
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _send(),
                  decoration: InputDecoration(
                    hintText: 'Tulis pesan…',
                    filled: true,
                    fillColor: context.appSurface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: context.appBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: context.appBorder),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: _send,
                icon: Icon(Icons.send_rounded, color: colors.onPrimary),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}
