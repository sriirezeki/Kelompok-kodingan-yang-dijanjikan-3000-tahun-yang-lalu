program POSRestoran;

uses crt;

const
  MAX_MENU = 50;
  MAX_ORDER = 100;
  MAX_MEJA = 20;
  MAX_TRANSAKSI = 200;

type
  TKategori = (Makanan, Minuman, Dessert, Snack);
  
  TMenu = record
    kode: string[10];
    nama: string[50];
    kategori: TKategori;
    harga: longint;
    stok: integer;
    tersedia: boolean;
  end;
  
  TItemOrder = record
    kodeMenu: string[10];
    namaMenu: string[50];
    jumlah: integer;
    hargaSatuan: longint;
    subtotal: longint;
  end;
  
  TMeja = record
    nomor: integer;
    terisi: boolean;
    namaCustomer: string[50];
    jumlahItem: integer;
    items: array[1..MAX_ORDER] of TItemOrder;
    totalBayar: longint;
    waktuOrder: string[20];
  end;
  
  TTransaksi = record
    noTransaksi: string[15];
    noMeja: integer;
    namaCustomer: string[50];
    totalBayar: longint;
    diskon: longint;
    totalAkhir: longint;
    bayar: longint;
    kembalian: longint;
    tanggal: string[20];
  end;
  
var
  menu: array[1..MAX_MENU] of TMenu;
  meja: array[1..MAX_MEJA] of TMeja;
  transaksi: array[1..MAX_TRANSAKSI] of TTransaksi;
  jumlahMenu, jumlahTransaksi: integer;
  username, password: string;

// konversi kategori ke string
function KategoriToString(k: TKategori): string;
begin
  case k of
    Makanan: KategoriToString := 'Makanan';
    Minuman: KategoriToString := 'Minuman';
    Dessert: KategoriToString := 'Dessert';
    Snack: KategoriToString := 'Snack';
  end;
end;

// format rupiah
function FormatRupiah(nilai: longint): string;
var
  s: string;
  i, len: integer;
begin
  str(nilai, s);
  len := length(s);
  i := len - 2;
  while i > 1 do
  begin
    insert('.', s, i);
    i := i - 3;
  end;
  FormatRupiah := 'Rp ' + s;
end;

// inisialisasi data menu default
procedure InitMenu;
begin
  jumlahMenu := 15;
  
  // Makanan
  menu[1].kode := 'M001'; menu[1].nama := 'Nasi Goreng Special'; menu[1].kategori := Makanan; 
  menu[1].harga := 25000; menu[1].stok := 50; menu[1].tersedia := true;
  
  menu[2].kode := 'M002'; menu[2].nama := 'Mie Goreng'; menu[2].kategori := Makanan;
  menu[2].harga := 20000; menu[2].stok := 50; menu[2].tersedia := true;
  
  menu[3].kode := 'M003'; menu[3].nama := 'Ayam Bakar'; menu[3].kategori := Makanan;
  menu[3].harga := 30000; menu[3].stok := 30; menu[3].tersedia := true;
  
  menu[4].kode := 'M004'; menu[4].nama := 'Sate Ayam'; menu[4].kategori := Makanan;
  menu[4].harga := 28000; menu[4].stok := 40; menu[4].tersedia := true;
  
  menu[5].kode := 'M005'; menu[5].nama := 'Gado-Gado'; menu[5].kategori := Makanan;
  menu[5].harga := 18000; menu[5].stok := 35; menu[5].tersedia := true;
  
  // Minuman
  menu[6].kode := 'D001'; menu[6].nama := 'Es Teh Manis'; menu[6].kategori := Minuman;
  menu[6].harga := 5000; menu[6].stok := 100; menu[6].tersedia := true;
  
  menu[7].kode := 'D002'; menu[7].nama := 'Es Jeruk'; menu[7].kategori := Minuman;
  menu[7].harga := 8000; menu[7].stok := 80; menu[7].tersedia := true;
  
  menu[8].kode := 'D003'; menu[8].nama := 'Cappuccino'; menu[8].kategori := Minuman;
  menu[8].harga := 15000; menu[8].stok := 60; menu[8].tersedia := true;
  
  menu[9].kode := 'D004'; menu[9].nama := 'Jus Alpukat'; menu[9].kategori := Minuman;
  menu[9].harga := 12000; menu[9].stok := 50; menu[9].tersedia := true;
  
  menu[10].kode := 'D005'; menu[10].nama := 'Thai Tea'; menu[10].kategori := Minuman;
  menu[10].harga := 10000; menu[10].stok := 70; menu[10].tersedia := true;
  
  // Dessert
  menu[11].kode := 'DS001'; menu[11].nama := 'Ice Cream Vanilla'; menu[11].kategori := Dessert;
  menu[11].harga := 15000; menu[11].stok := 40; menu[11].tersedia := true;
  
  menu[12].kode := 'DS002'; menu[12].nama := 'Puding Coklat'; menu[12].kategori := Dessert;
  menu[12].harga := 12000; menu[12].stok := 35; menu[12].tersedia := true;
  
  // Snack
  menu[13].kode := 'S001'; menu[13].nama := 'Kentang Goreng'; menu[13].kategori := Snack;
  menu[13].harga := 15000; menu[13].stok := 50; menu[13].tersedia := true;
  
  menu[14].kode := 'S002'; menu[14].nama := 'Risoles Mayo'; menu[14].kategori := Snack;
  menu[14].harga := 10000; menu[14].stok := 45; menu[14].tersedia := true;
  
  menu[15].kode := 'S003'; menu[15].nama := 'Onion Rings'; menu[15].kategori := Snack;
  menu[15].harga := 18000; menu[15].stok := 40; menu[15].tersedia := true;
end;

// inisialisasi meja
procedure InitMeja;
var i: integer;
begin
  for i := 1 to MAX_MEJA do
  begin
    meja[i].nomor := i;
    meja[i].terisi := false;
    meja[i].namaCustomer := '';
    meja[i].jumlahItem := 0;
    meja[i].totalBayar := 0;
  end;
end;

function Login: boolean;
var
  inputUser, inputPass: string;
  percobaan: integer;
begin
  percobaan := 0;
  repeat
    clrscr;
    writeln('================================================');
    writeln('     SISTEM POS RESTORAN/CAFE - LOGIN      ');
    writeln('================================================');
    writeln;
    write('Username: '); readln(inputUser);
    write('Password: '); readln(inputPass);
    
    if (inputUser = 'admin') and (inputPass = 'admin123') then
    begin
      Login := true;
      exit;
    end
    else
    begin
      percobaan := percobaan + 1;
      writeln;
      writeln('Login gagal! Username atau password salah.');
      writeln('Percobaan ke-', percobaan, ' dari 3');
      if percobaan < 3 then
      begin
        write('Tekan Enter untuk mencoba lagi...');
        readln;
      end;
    end;
  until percobaan = 3;
  
  Login := false;
end;