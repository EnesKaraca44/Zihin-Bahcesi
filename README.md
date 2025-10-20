# Zihin Bahçesi - Dijital Detoks ve Odaklanma Uygulaması

Zihin Bahçesi, kullanıcıların dijital cihazlardan uzaklaşarak odaklanmalarını ve kişisel gelişim görevlerini tamamlamalarını teşvik eden bir Flutter mobil uygulamasıdır. Kullanıcı, tamamladığı her görevle birlikte sanal bahçesini aşamalı olarak geliştirir ve ilerlemesini detaylı istatistiklerle takip edebilir.

Bu proje, Flutter, Riverpod state management ve Hive yerel veritabanı gibi modern teknolojileri kullanarak tam işlevsel bir portföy uygulaması olarak geliştirilmiştir.

## 📱 Ekran Görüntüleri
<img width="1080" height="2400" alt="Screenshot_20251020_213832" src="https://github.com/user-attachments/assets/921c1736-19f3-48c7-87ed-15f2f99b3dbe" />
<img width="1080" height="2400" alt="Screenshot_20251020_203248" src="https://github.com/user-attachments/assets/918c756d-fc39-4826-83f6-2333460c5a8d" />
<img width="1080" height="2400" alt="Screenshot_20251020_213857" src="https://github.com/user-attachments/assets/8ab68034-bb6f-43aa-9506-0b8eba1290b6"
  /><img width="1080" height="2400" alt="Screenshot_20251020_213849" src="https://github.com/user-attachments/assets/5f4dc3a6-98b4-4cb5-af31-81eee6436bc3" />




## ✨ Özellikler

Uygulama, aşağıdaki temel özellikleri içermektedir:

* **Dinamik Bahçe Gelişimi:** Tamamlanan görev sayısına göre aşamalı olarak (Tohum -> Fide -> Çiçek) gelişen bir sanal bahçe (Flutter'ın `AnimatedSwitcher`'ı ile).
* **Görev Zamanlayıcısı:** Seçilen bir göreve odaklanmak için tam işlevsel bir geri sayım sayacı ekranı.
* **Görev Yönetimi (CRUD):**
    * **Oluşturma:** Kullanıcıların kendi özel görevlerini (isim, süre, kategori) oluşturabilmesi.
    * **Okuma:** Görevlerin kategorize edilmiş (Zihinsel, Fiziksel, Yaratıcı) bir listede gösterilmesi.
    * **Düzenleme:** Kullanıcının oluşturduğu özel görevleri güncelleyebilmesi.
    * **Silme:** Kullanıcının oluşturduğu özel görevleri silebilmesi.
* **Kalıcı Veri Depolama:** Uygulama kapatılsa bile tüm görevlerin, kullanıcı ilerlemesinin ve ayarların **Hive** (NoSQL yerel veritabanı) ile telefonda güvenle saklanması.
* **Gelişmiş State Management:** Tüm uygulama durumunun (kullanıcı verileri, görev listesi, tema ayarları) **Riverpod** ile verimli ve merkezi bir şekilde yönetilmesi.
* **Detaylı İstatistikler:**
    * Toplam tamamlanan görev sayısı ve bahçe durumu özeti.
    * En çok tamamlanan ilk 3 görevin gösterilmesi.
    * **fl_chart** paketi ile son 7 günlük/30 günlük görev tamamlama performansını gösteren dinamik bir çubuk grafik.
* **Gelişmiş Ayarlar Ekranı:**
    * Kullanıcı profili ve bahçe adını düzenleyebilme.
    * **Açık/Koyu Tema** değiştirme ve tercihin kalıcı olarak saklanması.
    * Görev tamamlama seslerini açma/kapatma ve tercihin saklanması.
    * Tüm verileri sıfırlama seçeneği.
* **Sesli Geri Bildirim:** **audioplayers** paketi ile görev tamamlandığında başarı sesi çalma.
* **Modern Navigasyon:** `BottomNavigationBar` ile ana ekranlar (Bahçe, Görevler, İstatistikler) arasında kolay geçiş.
* **Özel İkon ve Açılış Ekranı:** `flutter_launcher_icons` ve `flutter_native_splash` paketleri ile uygulama kimliğinin özelleştirilmesi.

## 🛠️ Kullanılan Teknolojiler

Bu projenin geliştirilmesinde aşağıdaki teknolojiler ve paketler kullanılmıştır:

* **Çatı (Framework):** Flutter & Dart
* **State Management:** Riverpod
* **Yerel Veritabanı:** Hive
* **Grafikler:** fl_chart
* **Ses:** audioplayers
* **Animasyon:** Lottie & AnimatedSwitcher
* **Paketler:** google_fonts, uuid
* **Geliştirme Araçları:** build_runner, hive_generator
* **İkon/Açılış Ekranı:** flutter_launcher_icons, flutter_native_splash

## 🚀 Kurulum ve Çalıştırma

Projeyi yerel makinenizde çalıştırmak için aşağıdaki adımları izleyin:

1.  Bu repoyu klonlayın:
    ```sh
    git clone [SENİN_GITHUB_LİNKİN]
    ```
2.  Proje klasörüne gidin:
    ```sh
    cd zihin_bahcesi
    ```
3.  Gerekli paketleri yükleyin:
    ```sh
    flutter pub get
    ```
4.  Hive adaptör dosyalarını oluşturun (bu komut gereklidir):
    ```sh
    flutter pub run build_runner build --delete-conflicting-outputs
    ```
5.  Uygulamayı çalıştırın:
    ```sh
    flutter run
    ```
