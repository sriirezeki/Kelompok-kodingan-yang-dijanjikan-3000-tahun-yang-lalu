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