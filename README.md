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
ignore: 'merge,revert'
```

fungsi `ignore` disini akan mengignore commit message merge / revert, anda bisa custom sesuai keinginan dengan pemisah coma.

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

# Contoh Output

### Added
* [SPD-766](https://saas-telkomcorpu.atlassian.net/browse/SPD-766): F6001M10 - Mobile Classroom Session - Podcast
  * [SPD-978](https://saas-telkomcorpu.atlassian.net/browse/SPD-978): Mobile - Slicing Tab Overview Podcast (UI)
  * [SPD-977](https://saas-telkomcorpu.atlassian.net/browse/SPD-977): Mobile - Slicing Tab Detail Podcast (UI)
* [SPD-759](https://saas-telkomcorpu.atlassian.net/browse/SPD-759): F6001M01 - Mobile Explore Classroom
  * [SPD-850](https://saas-telkomcorpu.atlassian.net/browse/SPD-850): [Mobile] Slicing UI Filter Explore Classroom
  * [SPD-849](https://saas-telkomcorpu.atlassian.net/browse/SPD-849): [Mobile] Slicing UI Explore Classroom
* [SPD-765](https://saas-telkomcorpu.atlassian.net/browse/SPD-765): F6001M09 - Mobile Classroom Session - Video
  * [SPD-820](https://saas-telkomcorpu.atlassian.net/browse/SPD-820): Mobile - Slicing Tab Overview Video (UI)
  * [SPD-819](https://saas-telkomcorpu.atlassian.net/browse/SPD-819): Mobile - Slicing Tab Detail Video (UI)
* [SPD-762](https://saas-telkomcorpu.atlassian.net/browse/SPD-762): F6001M04 - Mobile Manage My Classroom
  * [SPD-818](https://saas-telkomcorpu.atlassian.net/browse/SPD-818): [Mobile] Slicing UI My Classroom Welcome
  * [SPD-813](https://saas-telkomcorpu.atlassian.net/browse/SPD-813): [Mobile] Slicing UI Filter My Classroom
  * [SPD-812](https://saas-telkomcorpu.atlassian.net/browse/SPD-812): [Mobile] Slicing UI My Classroom(Tab History)
  * [SPD-811](https://saas-telkomcorpu.atlassian.net/browse/SPD-811): [Mobile] Slicing UI My Classroom(Tab List Classroom)
  * [SPD-810](https://saas-telkomcorpu.atlassian.net/browse/SPD-810): [Mobile] Slicing UI My Classroom(Tab Overview)
* [SPD-764](https://saas-telkomcorpu.atlassian.net/browse/SPD-764): F6001M07 - Mobile Classroom Session - PDF
  * [SPD-805](https://saas-telkomcorpu.atlassian.net/browse/SPD-805): Mobile - Slicing Tab Overview PDF (UI)
  * [SPD-804](https://saas-telkomcorpu.atlassian.net/browse/SPD-804): Mobile - Slicing Tab Detail PDF (UI)
* [SPD-743](https://saas-telkomcorpu.atlassian.net/browse/SPD-743): 60 Classroom
  * [SPD-759](https://saas-telkomcorpu.atlassian.net/browse/SPD-759): F6001M01 - Mobile Explore Classroom
* Parentless
  * [SPD-743](https://saas-telkomcorpu.atlassian.net/browse/SPD-743): 60 Classroom
* [KBD-809](https://saas-telkomcorpu.atlassian.net/browse/KBD-809): F5511W02 - Timestamp video dikembalikan ke posisi terakhir ketika menonton, jika user DC/log out dan masuk/menonton kembali
  * [KBD-820](https://saas-telkomcorpu.atlassian.net/browse/KBD-820): [FE] Adding listener to save current time seeker when watching video
* [KBD-808](https://saas-telkomcorpu.atlassian.net/browse/KBD-808): F5511W01 - Default angka Slider UBPP diubah menjadi dari angka 0, jika user belum menggerakan slider form belum bisa disubmit
  * [KBD-819](https://saas-telkomcorpu.atlassian.net/browse/KBD-819): [FE] Change default value for slider from 8 to 0
* Ticketless Jira
  * feat(core) : add string extension for parseDateRange
  * feat(core) : add morpheme empty text state
  * feat(home) : add logic for category more content bottomsheet
  * feat(home) : adjust text size for more content bottomsheet
  * feat(classroom) : add ui for classroom page
  * feat(classroom) : add explore classroom
  * feat(classroom) : add my classroom
  * feat(classroom) : add my classroom welcome
  * feat(classroom) : init page classroom
  * feat(home) : add logic for category more content bottomsheet
  * feat(home) : add widget more content bottomsheet
  * feat(home) : add widget more content learning activity bottomsheet
  * feat(home) : add widget more content people multimedia bottomsheet
  * feat(home) : add widget more content people development bottomsheet
  * feat: init feature classroom
  * feat(home) : adjust text size for more content bottomsheet
  * feat(classroom) : add ui for classroom page
  * feat(classroom) : add ui for classroom page
  * feat(classroom) : add widget classroom tab layout
  * feat(classroom) : add explore classroom
  * feat(classroom) : add my classroom
  * feat(classroom) : add my classroom welcome
  * feat(assets) : add const for classroom
  * feat(assets) : add image banner my classroom welcome
  * feat(core) : add shared preferences for flagging welcome my classroom
  * feat(core) : add const for morpheme sizes
  * feat(route) : add classroom route
  * feat(classroom) : init page classroom
  * feat(home) : add logic for category more content bottomsheet
  * feat(home) : add widget more content bottomsheet
  * feat(home) : add widget more content learning activity bottomsheet
  * feat(home) : add widget more content menu item bottomsheet
  * feat(home) : add widget more content people multimedia bottomsheet
  * feat(home) : add widget more content people development bottomsheet
  * feat(assets) : add arb home
  * feat(core) : add const morpheme sizes
  * (WIP) feat(classroom-presence): implement dummy to funciton contact WhatsApp
  * (WIP) feat(classroom-presence): slicing classroom presence online
  * (WIP) feat/classroom-presence: move scanner overlay and painter to widget scanner
  * (WIP) feat(classroom-presence): slicing UI content presence

### Changed
* Ticketless Jira
  * refactor : remove flexible from widget
  * style(classroom) : adjust ui for my classroom welcome
  * style(filter) : move button no on param bottomsheet
  * style(home) : add rounded more content menu item for image
  * style(core) : remove param padding on morpheme empty text state
  * style(classroom) : renaming file icons
  * style(classroom) : adjust icon at my classroom overview
  * style(classroom) : adjust empty state for my classroom history
  * style(classroom) : adjust empty state for my classrom list
  * style(classroom) : adjust padding my classroom overview
  * refactor: reactive firebase remote config after rebase from staging
  * refactor: clear linter warning
  * refactor: make it clear linter
  * style(home) : remove appbar item classroom for test
  * style(home) : remove appbar item classroom for test
  * refactor : clear linter dart
  * refactor: fixing linter

### Fixed
* [SPD-743](https://saas-telkomcorpu.atlassian.net/browse/SPD-743): 60 Classroom
  * [SPD-762](https://saas-telkomcorpu.atlassian.net/browse/SPD-762): F6001M04 - Mobile Manage My Classroom
* Ticketless Jira
  * fix(assets) : adjust const for classroom
  * fix(assets) : change banner my classroom welcome
  * fix(route) : adjust route for classroom

### Other
* Ticketless Jira
  * syle(classroom) : adjust padding for my classroom
  * chore : remove class from setting routes
  * chore : delete remote_config.json
  * chore : temporary code for menu classroom
  * chore : temporary code for menu classroom