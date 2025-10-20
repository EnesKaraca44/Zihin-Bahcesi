import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../modeller/gorev.dart';
import '../providerlar/gorev_provider.dart';
import 'package:uuid/uuid.dart';

// Form elemanlarının durumunu yönetmek için ConsumerStatefulWidget kullanıyoruz.
class YeniGorevEklemeSayfasi extends ConsumerStatefulWidget {
  const YeniGorevEklemeSayfasi({Key? key, this.gorevToEdit}) : super(key: key);
  final Gorev? gorevToEdit;

  @override
  ConsumerState<YeniGorevEklemeSayfasi> createState() => _YeniGorevEklemeSayfasiState();
}

class _YeniGorevEklemeSayfasiState extends ConsumerState<YeniGorevEklemeSayfasi> {
  // Formun durumunu kontrol etmek için bir GlobalKey.
  final _formKey = GlobalKey<FormState>();
  final _uuidForm = Uuid();

  // TextField'lardaki metinleri okumak için Controller'lar.
  final _gorevAdiController = TextEditingController();
  final _gorevSuresiController = TextEditingController();

  // Dropdown menüde seçilen kategoriyi tutacak değişken.
  String _secilenKategori = 'Zihinsel';
  bool get _isEditMode => widget.gorevToEdit != null;

  @override
  void initState() {
    super.initState();
    // --- YENİ: Eğer düzenleme modundaysak, formu doldur ---
    if (_isEditMode) {
      _gorevAdiController.text = widget.gorevToEdit!.ad;
      // Süreden " dk" kısmını çıkarıp sadece sayıyı alıyoruz
      _gorevSuresiController.text = widget.gorevToEdit!.sure.replaceAll(RegExp(r'\s*dk'), '');
      _secilenKategori = widget.gorevToEdit!.kategori;
    }
  }

  @override
  void dispose() {
    // Controller'ları hafızadan temizlemek iyi bir pratiktir.
    _gorevAdiController.dispose();
    _gorevSuresiController.dispose();
    super.dispose();
  }

  void _goreviKaydet() {
    // Formun geçerli olup olmadığını kontrol et.
    if (_formKey.currentState!.validate()) {
      // Formdan gelen verileri al.
      final gorevAdi = _gorevAdiController.text;
      final gorevSuresi = _gorevSuresiController.text;
      final kategori = _secilenKategori;

      // Kategoriye göre doğru ikonu seçen bir mantık.
      IconData ikon;
      switch (kategori) {
        case 'Fiziksel':
          ikon = Icons.fitness_center;
          break;
        case 'Yaratıcı':
          ikon = Icons.palette;
          break;
        case 'Zihinsel':
        default:
          ikon = Icons.psychology;
          break;
      }

      // Yeni bir Gorev nesnesi oluştur.
      if (_isEditMode) {
        // Düzenleme: Mevcut ID'yi ve isCustom'ı koruyarak güncelle
        final guncellenecekGorev = Gorev(
          id: widget.gorevToEdit!.id, // Mevcut ID korunuyor
          ad: gorevAdi,
          kategori: kategori,
          sure: '$gorevSuresi dk',
          canSuyu: (int.parse(gorevSuresi) / 2).round().clamp(5, 50),
          ikonKodu: ikon.codePoint,
          ikonFontAilesi: ikon.fontFamily,
          isCustom: widget.gorevToEdit!.isCustom, // isCustom durumu korunuyor (true olmalı)
        );
        ref.read(gorevlerProvider.notifier).gorevGuncelle(guncellenecekGorev);
        Navigator.pop(context); // Düzenleme sonrası sadece bir kez pop yap

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('"${guncellenecekGorev.ad}" görevi başarıyla güncellendi!'),
            backgroundColor: Colors.blue,
          ),
        );
      } else {
        // Ekleme: Yeni ID ve isCustom=true ile ekle
        final yeniGorev = Gorev(
          ad: gorevAdi,
          kategori: kategori,
          sure: '$gorevSuresi dk',
          canSuyu: (int.parse(gorevSuresi) / 2).round().clamp(5, 50),
          ikonKodu: ikon.codePoint,
          ikonFontAilesi: ikon.fontFamily,
          id: _uuidForm.v4(), // Yeni ID oluşturuluyor
          isCustom: true, // Yeni görev her zaman özeldir
        );
        ref.read(gorevlerProvider.notifier).gorevEkle(yeniGorev);
        Navigator.pop(context); // Ekleme sonrası sadece bir kez pop yap

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('"${yeniGorev.ad}" görevi başarıyla eklendi!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF2D3436),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _isEditMode ? 'Görevi Düzenle' : 'Yeni Görev Oluştur',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3436),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isEditMode ? 'Görevi Güncelle' : 'Kendi Görevini Oluştur', // <-- Başlık değişti
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2D3436),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isEditMode ? 'Görevin detaylarını değiştir' : 'Kişisel hedeflerini takip etmek için özel görevler oluştur', // <-- Açıklama değişti
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF6C757D),
                ),
              ),

              const SizedBox(height: 32),

              // Form kartı
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Görev Adı
                    _buildFormField(
                      controller: _gorevAdiController,
                      label: 'Görev Adı',
                      hint: 'Örn: Gitar pratiği yap',
                      icon: Icons.task_alt,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen bir görev adı girin.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Görev Süresi
                    _buildFormField(
                      controller: _gorevSuresiController,
                      label: 'Süre (dakika)',
                      hint: 'Örn: 30',
                      icon: Icons.access_time,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen bir süre girin.';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Lütfen geçerli bir sayı girin.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Kategori seçimi
                    _buildCategorySelector(),
                    const SizedBox(height: 32),

                    // Kaydet butonu
                    _buildSaveButton(),
                  ],
                ),
              ),
          ],

          ),
        ),
      ),

    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kendi Görevini Oluştur',
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2D3436),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Kişisel hedeflerini takip etmek için özel görevler oluştur',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF6C757D),
          ),
        ),
      ],
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3436),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE9ECEF)),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: const Color(0xFF2D3436),
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.inter(
                fontSize: 16,
                color: const Color(0xFFADB5BD),
              ),
              prefixIcon: Icon(
                icon,
                color: const Color(0xFF00B894),
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kategori',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3436),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildCategoryOption('Zihinsel', Icons.psychology, const Color(0xFF3498DB)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCategoryOption('Fiziksel', Icons.fitness_center, const Color(0xFFE74C3C)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCategoryOption('Yaratıcı', Icons.palette, const Color(0xFF9B59B6)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryOption(String kategori, IconData icon, Color color) {
    final isSelected = _secilenKategori == kategori;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _secilenKategori = kategori;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : const Color(0xFFE9ECEF),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? color : const Color(0xFF6C757D),
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              kategori,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? color : const Color(0xFF6C757D),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _goreviKaydet,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00B894),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          _isEditMode ? 'Görevi Güncelle' : 'Görevi Kaydet',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}