---
name: git-workflow
description: Use before committing, creating a branch, tagging a release, or editing .gitignore.
---

# Git İş Akışı

## 1. Commit mesajları

- **Her zaman İngilizce** yazılır, konuşma Türkçe olsa bile.
- Format: [Conventional Commits](https://www.conventionalcommits.org/)

```
<type>(<scope>): <short summary>

[optional body: what and why, wrapped at 72 chars]
```

| Type | Ne zaman |
|---|---|
| `feat` | Yeni özellik veya ekran |
| `fix` | Hata düzeltme |
| `refactor` | Davranışı değiştirmeyen yeniden yapılandırma |
| `style` | Yalnızca görsel/tema değişikliği (renk, boşluk, animasyon) |
| `docs` | `.md` dosyaları, README |
| `chore` | Paket ekleme, yapılandırma, build ayarları |
| `test` | Test ekleme veya düzeltme |

**Scope** = feature klasörünün adı: `auth`, `onboarding`, `verification`, `support`, `directory`, `mentors`, `investors`, `matching`, `programs`, `community`, `profile`, `demo`, `theme`, `router`, `core`.

**Özet satırı kuralları:** emir kipi ("add", "fix"; "added" değil), küçük harfle başlar, sonda nokta yok, en fazla 72 karakter.

✅ İyi örnekler
```
feat(community): add like animation with haptic feedback
feat(verification): show review timeline with rejection note
fix(router): redirect to onboarding only for entrepreneurs
style(theme): apply spacing tokens to program cards
chore: add flutter_animate and shimmer packages
docs(features): mark matching tasks as done
```

❌ Kötü örnekler
```
update                          → ne güncellendi?
Beğeni eklendi                  → İngilizce olmalı
feat: Added new stuff.          → geçmiş zaman, belirsiz, nokta
fix(community): fix bug         → hangi hata?
```

## 2. Commit kapsamı

- **Bir commit = `docs/features.md`'deki bir madde** (veya onun mantıklı bir parçası).
- İlgili `features.md` işaretlemesi **aynı commit'e** dahil edilir.
- Commit atmadan önce:
  1. `dart run build_runner build --delete-conflicting-outputs` (model değiştiyse)
  2. `dart format .`
  3. `flutter analyze` → sıfır hata/uyarı
- Çalışmayan kod commit'lenmez. `main` her zaman derlenir ve açılır durumda olmalı.

## 3. Branch'ler

| Branch | Kullanım |
|---|---|
| `main` | Her zaman çalışır durumda |
| `feat/<scope>-<kisa-aciklama>` | Yeni özellik: `feat/community-likes` |
| `fix/<scope>-<kisa-aciklama>` | Hata: `fix/router-onboarding-loop` |
| `docs/<konu>` | Dokümantasyon |

- Branch'ler küçük tutulur: bir faz maddesi = bir branch.
- Birleştirme: `main`'e **squash merge** yapılır. Squash commit mesajı da yukarıdaki formatta olur.

## 4. Sürüm etiketleri

| Etiket | Ne zaman |
|---|---|
| `v0.1.0` | Faz 1 (MVP) tamamlandığında |
| `v0.2.0`, `v0.3.0`… | Faz 2'den her 2–3 özellik tamamlandığında |
| `v1.0.0` | Faz 3 tamamlandığında |

```
git tag -a v0.1.0 -m "MVP: onboarding, verification, directory, matching, programs, community"
git push origin v0.1.0
```

## 5. .gitignore

Flutter'ın varsayılan `.gitignore` dosyasına ek olarak:

```
# Kod üretimi: build_runner ile yeniden üretilir
*.g.dart
*.freezed.dart

# IDE / sistem
.idea/
.vscode/*
!.vscode/settings.json
.DS_Store
```

> Üretilen dosyalar commit'lenmediği için README'de kurulum adımı açıkça yazılır:
> `flutter pub get && dart run build_runner build --delete-conflicting-outputs`

## 6. Agent için kısa kurallar

- Kullanıcı istemedikçe `push`, `force push`, `rebase` yapma.
- Commit atmadan önce değişen dosya listesini ve commit mesajını göster.
- Birden fazla feature'a dokunan değişiklikleri ayrı commit'lere böl.