pragma solidity ^0.6.0;

interface ERC223{
    function transfer(address _from, uint value, byte _data) external returns(bool);
    event Transfer(address _from, address _to, uint _value, byte _data);
}
