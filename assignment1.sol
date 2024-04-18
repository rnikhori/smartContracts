// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract C {

    receive() external payable {}

    function getBalance() public view returns (uint256){
        return address(this).balance;
    }
}

contract D {
    function rejectEther() external payable{
        revert("D does not accept ETH");
    }

    function getBalance() public view returns (uint256){
        return address(this).balance;
    }
}

contract B{
    C public c;

    constructor(address payable _c){
        c = C(_c);
    }

    function forwardToC() external payable {
        require(msg.value > 0, "Must receive ETH to forward");
        (bool success, ) = address(c).call{value: msg.value}("");
        require(success, "Failed to send ETH to C");
    }
}


contract A {
    B public b;
    D public d;

    constructor(address _b,address _d){
        b = B(_b);
        d = D(_d);
    }

    function sendToBThenC() external payable{
        require(msg.value>0,"Must Send ETH");
        b.forwardToC{value: msg.value}();
    }

    function sendToDAndReject() external payable {
        require(msg.value > 0, "Must send ETH");
        d.rejectEther{value: msg.value}();
    }
}