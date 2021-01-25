pragma solidity ^0.6.0;

import "browser/erc20.sol";
import "browser/ERC223.sol";
import "browser/IERCReceipent.sol";

contract MyToken is erc20, ERC223{
     
    string public name;  
    string public symbol;
    uint public decimals;
    uint public _totalSupply;
    
    mapping(address => uint) private _balanceOf;
    mapping(address => mapping(address => uint)) private _allowences;
    
    constructor () public{
        name = "Bit Token";
        symbol = "BTK";
        decimals = 18;
        _totalSupply = 1000*10**18;
        _balanceOf[msg.sender] = _totalSupply;
    }
    
    function totalSupply() external override returns(uint __totalSupply){
          __totalSupply = _totalSupply;
          return __totalSupply;
    }
      
    function balanceOf(address _addr) external override returns(uint){
        return _balanceOf[_addr];
    }
    
    // -------------------------------------------------------------------------------------------
    /*  
        ERC223 token with additional function named transfer
        same as transfer in ERC20 but there is an 
        addtional @data param of type byte
    */
    
    function transfer(address _to, uint _value, byte _data) external override returns(bool){
        require(_value>0 && _value<=_balanceOf[msg.sender], 
        "Insufficient Amount or Invalid amount transfer");
        _balanceOf[_to]+=_value;
        _balanceOf[msg.sender]-=_value;
        if(isContract(_to)){
            IERCReceipent _address = IERCReceipent(_to);
            _address.tokenFallback(msg.sender, _value, _data);
        }
        emit Transfer(msg.sender, _to, _value, _data);
        return true;
    }
    
    function isContract(address _addr) public returns(bool){
        uint codeSize;
        assembly{
            codeSize := extcodesize(_addr)
        }
        return (codeSize > 0);
    }
    //--------------------------------------------------------------------------------------------
    
    function transfer(address _to, uint _value) external override returns(bool){
        require(_value>0 && _value<=_balanceOf[msg.sender], 
        "Insufficient Amount or Invalid amount transfer");
        _balanceOf[_to]+=_value;
        _balanceOf[msg.sender]-=_value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    
    function transferFrom(address _from, address _to, uint _value) external override returns(bool){
        require(_value<=_balanceOf[_from]);
        require(_value<=_allowences[_from][msg.sender]);
        _allowences[_from][msg.sender]-=_value;
        _balanceOf[_to]+=_value;
        _balanceOf[_from]-=_value;
        emit Transfer(_from, _to, _value);
        return true;
    }
    
    function approve(address _spender, uint _value) external override returns(bool){
        _allowences[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value); 
        return true;
    }
    
    function allowence(address _owner, address _spender) external override returns(uint){
        return _allowences[_owner][_spender];
    }
}
