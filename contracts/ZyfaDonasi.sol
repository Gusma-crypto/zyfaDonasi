// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract ZyfaDonasi{
    //1. state variable
    //menyimpan alamat pemilik contrack
    address public owner;

    //event agar frontend tau kalau ada donasi masuk
    event DonasiMasuk(address indexed pengirim, uint256 jumlah, uint256 waktu);

    //2. constructor
    //dijalankan sekali saat kontrak di deploy
    constructor(){
        owner = msg.sender; //set yang deploy (anda ) sebagai owner
    }

    //3. Modifier
    //fitur keamanan hanya owner yang bisa panggil fungsi tertentu misalkan tarik donasi
    modifier onlyOwner(){
        require(msg.sender == owner, "Anda bukan owner");
        _;//lanjut ke fungsi asli
    }

    //4. fungsi donasi
    //keyword 'payable' wajib ada agar fungsi dapat menerima eth/matic
    function donasi()public payable{
        //validasi donasi terlebih dahulu, nominal donasi > 0
        require(msg.value > 0,"mohon donasi lebih dari 0!");

        //emit event agar tercatat pada blockchain
        emit DonasiMasuk(msg.sender, msg.value, block.timestamp);

    }

    //5. fungsi mengecek saldo
    function cekSaldo()public view returns(uint256){
        return address(this).balance;
    }

    //6. function tarikdonasi/withdraw
    //pada fungsi ini tambahkan modifier 'onliOwner'
    function tarikDana()public onlyOwner{
        uint256 saldo = address(this).balance;
        require(saldo > 0,"saldo kosong bos, belum ada donatur");

        //cara moderen transfer eth (lebih aman dari transfer)
        (bool success, ) = owner.call{value:saldo}("");
        require(success, "gagal menarik dana");
    }
    
}