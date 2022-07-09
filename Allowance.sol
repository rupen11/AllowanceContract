//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract main{

    address private owner;
    mapping (address => uint) public allowance;

    constructor(){
        owner = msg.sender;
    }

    receive() external payable{
        
    }

    //1000000000000000000
    event log(address _to, uint _amount, string _description);


    modifier onlyOwner(){
        require(owner == msg.sender, "You are not owner");
        _;
    }

    modifier ownerOrAllowed(uint _amount){
        require(isOwner() || allowance[msg.sender] >= _amount, "Not Allowed" );
        _;
    }

    
    function isOwner() private view returns(bool){
        if(owner == msg.sender){
            return true;
        }
        return false;
    }

    function addAllowance(address _to, uint _amount) public onlyOwner {
        require(_to != owner, "You are owner");
        allowance[_to] += _amount;
    }


    function withdrawMoney(address payable _to, uint _amount, string memory _description) public ownerOrAllowed(_amount) {
        emit log(_to, _amount, _description);
        require(address(this).balance >= _amount, "No enough funds");
        if(isOwner() == false){
            allowance[msg.sender] = allowance[msg.sender] - _amount;
        }
        _to.transfer(_amount);
    }
    
    function BALANCE() public view returns(uint){
        return address(this).balance;
    }

}