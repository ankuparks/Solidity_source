pragma solidity ^0.6.0;

interface erc20{
    
    function totalSupply() external returns(uint);
    function balanceOf(address _addr) external returns(uint);
    function transfer(address _to, uint _value) external returns(bool);
    function transferFrom(address _from, address _to, uint _value) external returns(bool);
    function approve(address _spender, uint _value) external returns(bool);
    function allowence(address _owner, address _spender) external returns(uint);
    
    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}
