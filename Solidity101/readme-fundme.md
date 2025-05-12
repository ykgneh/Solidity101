

# FundMe Smart Contract

Smart contract ini memungkinkan pengguna untuk mendonasikan ETH ke dalam kontrak, dan hanya pemilik kontrak yang dapat menarik dana tersebut. Kontrak ini juga melakukan konversi dari ETH ke USD menggunakan Chainlink Price Feed dan menetapkan batas minimum donasi.

## Deskripsi Kontrak FundMe

Kontrak **`FundMe`** adalah kontrak yang memungkinkan pengguna untuk mendonasikan **ETH** ke kontrak ini. Namun, ada batasan bahwa nilai donasi minimal harus setara dengan **5 USD**. 

Selain itu, hanya **pemilik kontrak** yang bisa menarik dana yang terkumpul. Kontrak ini menggunakan **Chainlink Price Feed** untuk mendapatkan nilai tukar ETH ke USD, memastikan bahwa setiap donasi yang diterima sudah memenuhi batas minimal yang ditetapkan. 

### Fungsi Utama dalam `FundMe`:
- **Donasi (fund)**: Pengguna dapat mengirim ETH sebagai donasi.
- **Penarikan (withdraw)**: Hanya pemilik kontrak yang dapat menarik dana yang terkumpul.
- **Fallback dan Receive**: Untuk menangani ETH yang dikirim tanpa data.

## Konsep Utama

### 1. **Constructor**
`Constructor` adalah fungsi khusus dalam kontrak yang hanya dipanggil sekali ketika kontrak pertama kali di-deploy (dipasang di blockchain). Fungsi ini digunakan untuk menginisialisasi nilai variabel awal.

```solidity
constructor() {
    i_owner = msg.sender;
}
````

* **`msg.sender`**: Ini adalah alamat yang meng-deploy kontrak. Nilai ini disimpan dalam variabel `i_owner` yang akan menjadi pemilik kontrak.
* Pemilik kontrak hanya dapat di-set saat deploy dan tidak dapat diubah setelah itu.

### 2. **`immutable`**

Keyword `immutable` digunakan untuk mendeklarasikan variabel yang hanya bisa di-set saat kontrak pertama kali di-deploy dan tidak dapat diubah setelahnya.

```solidity
address public immutable i_owner;
```

* Variabel `i_owner` hanya bisa di-set sekali dengan alamat yang meng-deploy kontrak.
* Setelah itu, nilai ini tidak dapat diubah lagi. Ini efisien dan menghemat gas karena nilainya tidak perlu disimpan di storage secara terpisah.

### 3. **`constant`**

Keyword `constant` digunakan untuk mendeklarasikan variabel yang nilainya **tidak akan berubah** sepanjang hidup kontrak dan sudah diketahui sebelum kontrak di-deploy.

```solidity
uint256 public constant MINIMUM_USD = 5 * 10 ** 18;
```

* `MINIMUM_USD` adalah nilai minimum donasi yang diizinkan, yang ditetapkan sebesar 5 USD dalam bentuk `wei` (unit terkecil dalam Ethereum).
* Nilai ini tetap dan tidak bisa diubah setelah kontrak di-deploy. Menggunakan `constant` menghemat gas karena nilai tersebut sudah disematkan langsung di bytecode kontrak.

### 4. **Logika Kontrak**

Kontrak ini menggunakan beberapa logika untuk memastikan bahwa hanya pemilik yang dapat menarik dana dan bahwa donasi yang dilakukan memenuhi persyaratan yang telah ditetapkan.

#### a. **Fungsi Fund**

Fungsi ini memungkinkan pengguna untuk mendonasikan ETH ke kontrak. Donasi hanya diterima jika nilai ETH yang dikirimkan setara atau lebih besar dari 5 USD.

```solidity
function fund() public payable {
    require(msg.value.getConversionRate() >= MINIMUM_USD, "You need to spend more ETH!");
    addressToAmountFunded[msg.sender] += msg.value;
    funders.push(msg.sender);
}
```

* **`msg.value`** adalah jumlah ETH yang dikirimkan.
* **`getConversionRate()`**: Fungsi ini mengonversi nilai ETH yang dikirim menjadi USD.
* **`require`**: Memastikan bahwa nilai yang dikirimkan memenuhi batas minimum yang ditetapkan. Jika tidak, transaksi akan dibatalkan.

#### b. **Fungsi Withdraw**

Fungsi ini hanya dapat dijalankan oleh pemilik kontrak. Fungsi ini akan menarik semua dana yang ada di kontrak dan mengirimkannya ke pemilik.

```solidity
function withdraw() public onlyOwner {
    for (uint256 i = 0; i < funders.length; i++) {
        address funder = funders[i];
        addressToAmountFunded[funder] = 0;
    }
    funders = new address ;
    (bool success,) = payable(msg.sender).call{value: address(this).balance}("");
    require(success, "Call failed");
}
```

* **`onlyOwner`** adalah modifier yang membatasi akses ke fungsi ini hanya untuk pemilik kontrak.
* **`msg.sender`** adalah alamat pemilik kontrak yang berhak menarik dana.
* **`call`** digunakan untuk mengirimkan dana ke pemilik kontrak dengan memastikan transaksi berhasil.

#### c. **Modifier `onlyOwner`**

Modifier ini digunakan untuk membatasi akses ke fungsi tertentu hanya untuk pemilik kontrak.

```solidity
modifier onlyOwner() {
    if (msg.sender != i_owner) revert NotOwner();
    _;
}
```

* **`msg.sender != i_owner`** memastikan bahwa hanya pemilik kontrak yang dapat mengakses fungsi yang menggunakan modifier ini.
* Jika yang memanggil fungsi bukan pemilik, kontrak akan me-revert dan mengembalikan error `NotOwner`.

#### d. **Fallback dan Receive**

Fungsi `fallback` dan `receive` digunakan untuk menangani ETH yang dikirim ke kontrak tanpa memanggil fungsi tertentu.

```solidity
fallback() external payable { fund(); }
receive() external payable { fund(); }
```

* **`receive()`**: Menangani transaksi ETH yang dikirim tanpa data.
* **`fallback()`**: Menangani transaksi ETH yang dikirim dengan data.

Kedua fungsi ini memanggil fungsi `fund()`, sehingga donasi tetap tercatat meskipun tidak ada data yang dikirim.

---

## Ringkasan

* **Constructor**: Menginisialisasi pemilik kontrak.
* **`immutable`**: Variabel yang hanya dapat diset sekali dan tidak bisa diubah setelah deploy.
* **`constant`**: Variabel yang nilainya tetap dan sudah ditentukan sebelum kontrak di-deploy.
* **Logika**: Menggunakan `require`, `modifier`, dan mekanisme transfer dana yang memastikan bahwa hanya pemilik yang dapat menarik dana dan donasi dilakukan dengan benar.


---
