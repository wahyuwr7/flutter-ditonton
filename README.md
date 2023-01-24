# a199-flutter-expert-project
[![Flutter](https://img.shields.io/badge/Flutter-1.22-blue)](https://flutter.dev/) [![Firebase](https://img.shields.io/badge/Firebase-v7.5-orange)](https://firebase.google.com/) [![Codemagic build status](https://api.codemagic.io/apps/63c8bc93ce8a439348f81860/5e5f2e8fec6a2e000f7f6d2b/status_badge.svg)](https://codemagic.io/app/63c8bc93ce8a439348f81860/build/63cf34d8f31d6bea46a513b6)
Repository ini merupakan starter project submission kelas Flutter Expert Dicoding Indonesia.

---

## Tips Submission Awal

Pastikan untuk memeriksa kembali seluruh hasil testing pada submissionmu sebelum dikirimkan. Karena kriteria pada submission ini akan diperiksa setelah seluruh berkas testing berhasil dijalankan.


## Tips Submission Akhir

Jika kamu menerapkan modular pada project, Anda dapat memanfaatkan berkas `test.sh` pada repository ini. Berkas tersebut dapat mempermudah proses testing melalui *terminal* atau *command prompt*. Sebelumnya menjalankan berkas tersebut, ikuti beberapa langkah berikut:
1. Install terlebih dahulu aplikasi sesuai dengan Operating System (OS) yang Anda gunakan.
    - Bagi pengguna **Linux**, jalankan perintah berikut pada terminal.
        ```
        sudo apt-get update -qq -y
        sudo apt-get install lcov -y
        ```
    
    - Bagi pengguna **Mac**, jalankan perintah berikut pada terminal.
        ```
        brew install lcov
        ```
    - Bagi pengguna **Windows**, ikuti langkah berikut.
        - Install [Chocolatey](https://chocolatey.org/install) pada komputermu.
        - Setelah berhasil, install [lcov](https://community.chocolatey.org/packages/lcov) dengan menjalankan perintah berikut.
            ```
            choco install lcov
            ```
        - Kemudian cek **Environtment Variabel** pada kolom **System variabels** terdapat variabel GENTHTML dan LCOV_HOME. Jika tidak tersedia, Anda bisa menambahkan variabel baru dengan nilai seperti berikut.
            | Variable | Value|
            | ----------- | ----------- |
            | GENTHTML | C:\ProgramData\chocolatey\lib\lcov\tools\bin\genhtml |
            | LCOV_HOME | C:\ProgramData\chocolatey\lib\lcov\tools |
        
2. Untuk mempermudah proses verifikasi testing, jalankan perintah berikut.
    ```
    git init
    ```
3. Kemudian jalankan berkas `test.sh` dengan perintah berikut pada *terminal* atau *powershell*.
    ```
    test.sh
    ```
    atau
    ```
    ./test.sh
    ```
    Proses ini akan men-*generate* berkas `lcov.info` dan folder `coverage` terkait dengan laporan coverage.
4. Tunggu proses testing selesai hingga muncul web terkait laporan coverage.

## Usefull command

1. Build mock testing
   ```
    flutter pub run build_runner build --delete-conflicting-outputs
   ```
2. Testing dengan coverage
    pertama dapat menjalankan command berikut
    ```
    flutter test --coverage
    ```
    kemudian jalankan command dibawah untuk mengenerate html
    ```
    genhtml coverage/lcov.info -o coverage/html
    ```
   kemudian untuk membuka dapat menggunakan command berikut
    ```
    open coverage/html/index.html
    ```
