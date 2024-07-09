# ✨CtoR✨
_Tools untuk mengubah commit message ke release note_

Tools ini mengambil commit message dan merubahnya menjadi release note yang bisa di baca oleh Quality Assurance ✨

## Cara Instalasi
1. Unduh file aplikasi `*.zip` versi terbaru sesuai sistem operasi kalian, pada page release https://github.com/denameidina/ctor/releases

![Page Release](/docs/release.png)

2. extract file `*.zip`
3. ingat - ingat tempat extract file tersebut (misal di `D:/folder` atau `~/folder`)

### Jika kamu pake MAC:
4. buka terminal pada folder hasil extract tadi
5. run command `chmod +x /path/ctor`
6. tambahkan PATH `/path/ctor` pada variable device
7. jika melakukan command pada `ctor` gagal, coba cek pada setting/privacy & security dan allow `ctor`

![Warning](/docs/mac1.png) ![Allow Anyway](/docs/mac2.png)

### Jika kamu pake Windows:
4. tambahkan PATH folder hasil extract tadi ke environment variable

![Environment Variable](/docs/env.png)

5. buka command prompt
6. coba run command `ctor -v` jika muncul tulisan `0.0.1` berarti sudah bisa digunakan

![Success command](/docs/cmd.png)

---
## Cara Penggunaan

### Buat file ctor.yaml

buatlah file ctor.yaml dalam project kalian

```yaml
email_jira: "YOUR EMAIL"
token_jira: "YOUR TOKEN"
```

untuk mendapatkan token jira kalian bisa mengambil dari profile account masing-masing caranya:

1. klik avatar profile yang berada pada pojok kanan atas
2. klik manage account
3. pilih section security
4. klik Create and manage API tokens yang ada pada bagian API tokens
  ![Success command](/docs/create_jira_token.png)

### Penggunaan command

Anda bisa cek command melalui `ctor -h`

#### Command Jira

Anda bisa cek command melalui `ctor jira -h` untuk melihat argument lebih lengkap

```sh
ctor jira -h
Change commit messages to release note with implemented JIRA api

Usage: ctor jira [arguments]
-h, --help                 Print this usage information.
-s, --start (mandatory)    Hash start commit
-e, --end                  Hash end commit
                           (defaults to "HEAD")
    --email                Email to identify your jira account
    --token                Token to identify yout jira account
-o, --output               Output type
                           [plain, markdown (default)]

Run "ctor help" to see global options.
```

contoh penggunaan paling simple `ctor jira -s 57bbc2b2ff3a3a5498bc6d4bab4b8e2564fc37c0`

untuk contoh lebih compleks menggunakan start dan end commit `ctor jira -s 57bbc2b2ff3a3a5498bc6d4bab4b8e2564fc37c0 -e fee87cb6e06b9237345d3da81c557a642eb9e57e`