// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract A {
    address payable public contractB;
    address payable public contractD;

    constructor(address payable _contractB,address payable _contractD) {
        contractB = _contractB;
        contractD = _contractD;
    }
    
   function sendToB() external payable {
        (bool sent, ) = contractB.call{value: msg.value}("");
        require(sent, "Failed to send Ether to B");
    }

    function sendToD() external payable {
        (bool sent, ) = contractD.call{value: msg.value}("");
        require(sent, "Failed to send Ether to D");
    }
}

contract B {
    address payable public contractC;

    constructor(address payable _contractC) {
        contractC = _contractC;
    }

    receive() external payable {
        (bool sent, ) = contractC.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }
}

contract C {
    receive() external payable {}
}

contract D {
    receive() external payable {
        revert("D does not accept Ether");
    }
}
