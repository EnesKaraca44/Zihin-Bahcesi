import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../modeller/kullanici_verileri.dart';
import '../modeller/tema_provider.dart';
import '../providerlar/gorev_provider.dart';
import '../providerlar/kullanici_provider.dart';
import 'hakkinda_sayfasi.dart';
import 'hos_geldin_sayfasi.dart';

class AyarlarEkrani extends ConsumerStatefulWidget {
  const AyarlarEkrani({super.key});

  @override
  ConsumerState<AyarlarEkrani> createState() => _AyarlarEkraniState();
}

class _AyarlarEkraniState extends ConsumerState<AyarlarEkrani> {
  Future<void> _showEditDialog({
    required BuildContext context,
    required String title,
    required String initialValue,
    required Function(String) onSave,
  }) async {
    final TextEditingController controller = TextEditingController(text: initialValue);
    final formKey = GlobalKey<FormState>();

    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Yeni değeri girin',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Bu alan boş bırakılamaz.';
                }
                return null;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('İptal'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Kaydet'),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  onSave(controller.text.trim());
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(temaProvider);
    final isDarkMode = themeMode == ThemeMode.dark;
    final kullaniciVerileri = ref.watch(kullaniciVerileriProvider);
    final kullaniciNotifier = ref.read(kullaniciVerileriProvider.notifier);

    // Tema-uyumlu renkler
    final backgroundColor = isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA);
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF2D3436);
    final subtextColor = isDarkMode ? Colors.white70 : const Color(0xFF6C757D);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: textColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Ayarlar',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildProfileSection(kullaniciVerileri, kullaniciNotifier, isDarkMode),
            const SizedBox(height: 24),
            _buildAppearanceSection(isDarkMode),
            const SizedBox(height: 24),
            _buildNotificationsSection(kullaniciVerileri, kullaniciNotifier, isDarkMode),
            const SizedBox(height: 24),
            _buildSoundSection(kullaniciVerileri, kullaniciNotifier, isDarkMode),
            const SizedBox(height: 24),
            _buildAboutSection(context, isDarkMode),
            const SizedBox(height: 24),
            _buildDataSection(isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildAppearanceSection(bool isDarkMode) {
    return _buildSection(
      title: 'Görünüm',
      isDarkMode: isDarkMode,
      children: [
        SwitchListTile(
          title: Text(
            'Koyu Mod',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : const Color(0xFF2D3436),
            ),
          ),
          subtitle: Text(
            'Uygulama genelinde koyu temayı etkinleştir',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: isDarkMode ? Colors.white70 : const Color(0xFF6C757D),
            ),
          ),
          value: isDarkMode,
          onChanged: (value) {
            ref.read(temaProvider.notifier).temayiDegistir(value);
          },
          activeColor: const Color(0xFF00B894),
        ),
      ],
    );
  }

  Widget _buildDataSection(bool isDarkMode) {
    return _buildSection(
      title: 'Veri Yönetimi',
      isDarkMode: isDarkMode,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              _showResetConfirmationDialog();
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Tüm İlerlemeyi Sıfırla',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showResetConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Emin misiniz?'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bu işlem tüm ilerlemenizi ve oluşturduğunuz özel görevleri kalıcı olarak silecektir.'),
                Text('Bu eylem geri alınamaz.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('İptal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Evet, Sıfırla'),
              onPressed: () async {
                await ref.read(kullaniciVerileriProvider.notifier).verileriSifirla();
                await ref.read(gorevlerProvider.notifier).verileriSifirla();

                if (!mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const HosGeldinSayfasi()),
                      (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileSection(KullaniciVerileri kullaniciVerileri, KullaniciVerileriNotifier kullaniciNotifier, bool isDarkMode) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFFFE4B5),
            border: Border.all(
              color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.person,
            size: 60,
            color: Color(0xFFD2691E),
          ),
        ),
        const SizedBox(height: 20),
        _buildEditableProfileItem(
          context: context,
          label: 'Kullanıcı Adı',
          value: kullaniciVerileri.kullaniciAdi,
          isDarkMode: isDarkMode,
          onTap: () {
            _showEditDialog(
              context: context,
              title: 'Kullanıcı Adını Düzenle',
              initialValue: kullaniciVerileri.kullaniciAdi,
              onSave: (newValue) {
                kullaniciNotifier.updateKullaniciVerileri(kullaniciAdi: newValue);
              },
            );
          },
        ),
        const SizedBox(height: 12),
        _buildEditableProfileItem(
          context: context,
          label: 'Bahçe Adı',
          value: kullaniciVerileri.bahceAdi,
          isDarkMode: isDarkMode,
          onTap: () {
            _showEditDialog(
              context: context,
              title: 'Bahçe Adını Düzenle',
              initialValue: kullaniciVerileri.bahceAdi,
              onSave: (newValue) {
                kullaniciNotifier.updateKullaniciVerileri(bahceAdi: newValue);
              },
            );
          },
        ),
        const SizedBox(height: 8),
        Text(
          "ID: ${kullaniciVerileri.id.substring(0, 8)}...",
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: isDarkMode ? Colors.white60 : const Color(0xFF6C757D),
          ),
        ),
      ],
    );
  }

  Widget _buildEditableProfileItem({
    required BuildContext context,
    required String label,
    required String value,
    required bool isDarkMode,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode ? Colors.white70 : const Color(0xFF6C757D),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : const Color(0xFF2D3436),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            Icon(Icons.edit, size: 18, color: isDarkMode ? Colors.white54 : Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsSection(KullaniciVerileri kullaniciVerileri, KullaniciVerileriNotifier kullaniciNotifier, bool isDarkMode) {
    return _buildSection(
      title: 'Bildirimler',
      isDarkMode: isDarkMode,
      children: [
        _buildSettingItem(
          title: 'Görev Hatırlatıcıları',
          subtitle: 'Görevleriniz için bildirimleri etkinleştirin',
          isDarkMode: isDarkMode,
          trailing: Switch(
            value: kullaniciVerileri.bildirimlerAcik,
            onChanged: (value) {
              kullaniciNotifier.updateKullaniciVerileri(bildirimlerAcik: value);
            },
            activeColor: const Color(0xFF00B894),
            activeTrackColor: const Color(0xFF00B894).withOpacity(0.3),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFE9ECEF),
          ),
        ),
      ],
    );
  }

  Widget _buildSoundSection(KullaniciVerileri kullaniciVerileri, KullaniciVerileriNotifier kullaniciNotifier, bool isDarkMode) {
    return _buildSection(
      title: 'Ses',
      isDarkMode: isDarkMode,
      children: [
        _buildSettingItem(
          title: 'Sesler',
          subtitle: 'Uygulama seslerini etkinleştirin',
          isDarkMode: isDarkMode,
          trailing: Switch(
            value: kullaniciVerileri.sesAcik,
            onChanged: (value) {
              kullaniciNotifier.updateKullaniciVerileri(sesAcik: value);
            },
            activeColor: const Color(0xFF00B894),
            activeTrackColor: const Color(0xFF00B894).withOpacity(0.3),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFE9ECEF),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context, bool isDarkMode) {
    return _buildSection(
      title: 'Hakkında',
      isDarkMode: isDarkMode,
      children: [
        _buildSettingItem(
          title: 'Uygulama Hakkında',
          isDarkMode: isDarkMode,
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: isDarkMode ? Colors.white54 : const Color(0xFF6C757D),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HakkindaSayfasi()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
    required bool isDarkMode,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : const Color(0xFF2D3436),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    required bool isDarkMode,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? Colors.white : const Color(0xFF2D3436),
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: isDarkMode ? Colors.white70 : const Color(0xFF6C757D),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 16),
                trailing,
              ],
            ],
          ),
        ),
      ),
    );
  }
}