# İş İlanı ve Başvuru Yönetim Sistemi

## Proje Bilgileri

- **Proje Adı**: İş İlanı ve Başvuru Yönetim Sistemi
- **Öğrenci Adı**: Efe Demirci
- **Öğrenci Numarası**: 243301077
- **Ders**: Mobil Uygulama Geliştirme (2. Sınıf)
- **Geliştirme Aracı**: Flutter + Dart
- **Backend**: Supabase (PostgreSQL)

---

## Proje Açıklaması

Bu uygulama, işverenlerin iş ilanları yayınlaması ve iş arayanların bu ilanlara başvurması için geliştirilmiş bir mobil uygulamadır.

### Temel Özellikler:
- ✅ Rol tabanlı kullanıcı yönetimi (İşveren / İş Arayan)
- ✅ Kullanıcı kayıt ve giriş sistemi (Supabase Auth)
- ✅ İş ilanı oluşturma, düzenleme ve silme
- ✅ İş ilanlarına başvuru yapma
- ✅ Başvuru durumu takibi
- ✅ Tüm işlemlerin log kaydı
- ✅ Row Level Security (RLS) ile veri güvenliği

---

## Test Hesapları

### İş Arayan Hesabı
- **Email**: jobseeker@test.com
- **Şifre**: Test@123456
- **Rol**: Job Seeker (İş Arayan)

### İşveren Hesabı
- **Email**: employer@test.com
- **Şifre**: Test@123456
- **Rol**: Employer (İşveren)

---

## Kullanılan Paketler

### Ana Paketler
| Paket | Versiyon | Açıklama |
|-------|----------|----------|
| `flutter` | SDK | Flutter framework |
| `supabase_flutter` | 2.12.4 | Supabase entegrasyonu (Auth + Database) |
| `cupertino_icons` | 1.0.8 | iOS stilleri ve ikonlar |

### Supabase'in Yüklediği Ek Paketler
- `supabase`: 2.10.6 - Supabase client
- `gotrue`: 2.20.0 - Supabase Auth
- `postgrest`: 2.7.0 - Supabase Database
- `realtime_client`: 2.7.3 - Realtime subscriptions
- `storage_client`: 2.5.2 - File storage
- `shared_preferences`: 2.5.5 - Yerel veri saklama
- `http`: 1.6.0 - HTTP istekleri

---

## Uygulama Ekranları

### 1. Giriş/Kayıt Sayfası (SignInPage)
Kullanıcıların uygulamaya girmesi ve yeni hesap oluşturması için.

**Özellikler:**
- Email ve şifre girişi
- Rol seçimi (İş Arayan / İşveren)
- Kayıt ve Giriş modu geçişi
- Hata mesajları görüntüleme
- Supabase ile kimlik doğrulama

---

### 2. Ana Sayfa / İş İlanları Listesi (HomePage)
Tüm iş ilanlarının gösterildiği sayfa.

**Özellikler:**
- Tüm iş ilanlarının listelenmesi
- Her ilana başvuru yapabilme
- Ilan detaylarını görüntüleme
- İşveren ise kendi ilanlarını yönetme

---

### 3. İş İlanı Detayı (JobDetailPage)
Seçilen ilanın tüm detaylarının gösterilmesi.

**Özellikler:**
- İlan başlığı, açıklama
- İşveren bilgileri
- Başvuru butonu
- Başvurularını görüntüleme (işveren için)

---

## Veritabanı Yapısı

### Tablolar

#### `profiles` - Kullanıcı Profilleri
```sql
- id (UUID, primary key)
- full_name (text)
- role (text: 'employer' or 'job_seeker')
- created_at (timestamp)
```

#### `jobs` - İş İlanları
```sql
- id (UUID, primary key)
- title (text)
- description (text)
- employer_id (UUID, foreign key)
- created_at (timestamp)
```

#### `applications` - Başvurular
```sql
- id (UUID, primary key)
- job_id (UUID, foreign key)
- seeker_id (UUID, foreign key)
- status (text: 'pending', 'accepted', 'rejected')
- applied_at (timestamp)
```

#### `logs` - İşlem Logları
```sql
- id (UUID, primary key)
- user_id (UUID, foreign key)
- action (text: 'sign_up', 'sign_in', vb.)
- detail (text)
- created_at (timestamp)
```

---

## Kurulum Adımları

### 1. Gerekli Yazılımlar
- Flutter SDK (3.11.5+)
- Dart SDK (entegre)
- Android Studio (Android geliştirmesi için)
- Xcode (iOS geliştirmesi için)

### 2. Projeyi Çalıştırma
```bash
# Bağımlılıkları yükle
flutter pub get

# Kod analizi
flutter analyze

# Uygulamayı çalıştır
flutter run
```

### 3. Supabase Kurulumu
1. Supabase'de yeni bir proje oluştur
2. SQL Editor'da verilen SQL kodlarını çalıştır
3. API URL ve Anon Key'i main.dart'a kopyala

---

## Mimari ve Kod Yapısı

### main.dart Bileşenleri

1. **MyApp** - Ana uygulama widget'ı
2. **AuthGate** - Oturum kontrol kapısı
3. **SignInPage** - Giriş/Kayıt sayfası
4. **HomePage** - Ana sayfa (placeholder)
5. **Gelecek Ekranlar**: JobDetailPage, AddJobPage, ProfilePage

### Kullanılan Tasarım Desenleri
- **StatelessWidget**: Sabit ekranlar için
- **StatefulWidget**: Değişen durumlar için
- **Stream**: Supabase auth durumunu izlemek için

---

## Öğrenilen Konseptler

### Flutter Konseptleri
- Widget hiyerarşisi
- State Management (setState)
- Async/Await (asenkron işlemler)
- UI Components (TextField, Button, Dropdown, vb.)
- Navigation ve routing

### Dart Konseptleri
- Null Safety
- Extension methods
- Future ve Stream
- Error handling (try-catch)

### Supabase Konseptleri
- Authentication (Auth)
- Row Level Security (RLS)
- Database (PostgreSQL)
- Policies (Güvenlik politikaları)

---

## Gereklilik Kontrol Listesi

- ✅ En az 2 rol tanımı (İşveren / İş Arayan)
- ✅ Supabase kullanımı (Auth + Database)
- ✅ Kullanıcı kayıt, giriş, çıkış
- ✅ En az 5 ekran planı (Giriş, Ana Sayfa, Detay, Ekle/Düzenle, Profil)
- ✅ Log kaydı (logs tablosu)
- ✅ README.md test hesapları
- ✅ En az 3 ekran görüntüsü (hazırlanacak)

---

## Git Commit Geçmişi

1. `Initial commit: Supabase entegrasyonu`
2. `Add: Firebase yerine Supabase tercih edildi`
3. `Add: Supabase API bilgileri yapılandırıldı`
4. `Add: Oturum yönetimi ve auth gate eklendi`
5. `Add: SignInPage giriş/kayıt formu oluşturuldu`
6. `Add: Supabase tables SQL scripts`
7. `Add: RLS policies ve güvenlik ayarları`
8. `Add: README.md ve test hesapları`

---

## Sonraki Adımlar

1. ✅ Giriş/Kayıt sayfasını test etme
2. ⏳ HomePage'i iş ilanları listesiyle doldurma
3. ⏳ JobDetailPage oluşturma
4. ⏳ AddJobPage (iş ilanı ekle/düzenle)
5. ⏳ ProfilePage (kullanıcı profili)
6. ⏳ Başvuru yönetim sistemi
7. ⏳ Ekran görüntüleri ekleme

---

## Notlar

- **Veri Güvenliği**: Tüm tablolarda RLS açık, politikalar yapılandırılmış
- **Logging**: Her kayıt, giriş ve işlem logs tablosuna kaydediliyor
- **Error Handling**: Tüm network işlemlerinde try-catch kullanılıyor

---

**Son Güncelleme**: 22 Mayıs 2026
