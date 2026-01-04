// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract Donasi{
    address public admin;

    // digunakan untuk mencatat siapa yang menyumbang
    mapping(address => uint256) public donatur;

    constructor(){
        admin = msg.sender;
    }

// Modifier: Hanya admin yang boleh lewat
    modifier onlyAdmin() {
        require( msg.sender == admin, "Anda bukan admin!");
        _;
    }

    //fungsi donasi menerima eth
    function donasi() public payable{
        require(msg.value > 0, "Minimal donasi > 0");
        donatur[msg.sender] += msg.value;
    }
    
    // Fungsi Tarik: Mengirim seluruh saldo kontrak ke admin
    function withdraw() public onlyAdmin{
        uint256 saldo = address(this).balance;
        (bool success, ) = payable(admin).call{value: saldo}("");
        require(success, "Gagal menarik dana");
    }  

}