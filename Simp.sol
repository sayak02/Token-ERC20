// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;
// use latest solidity version at time of writing, need not worry about overflow and underflow

/// @title ERC20 Contract 

contract Token {


    string public name;
    string public symbol;
    uint256 public decimals;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    //  event fires when state changes
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(string memory _name, string memory _symbol, uint _decimals, uint _totalSupply) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _totalSupply; 
        balanceOf[msg.sender] = totalSupply;
    }

    // transfer amount of tokens to an address -Function
    //  _to -- receiver of token
    //  _value -- amount value of token to send
    // return true for transfer
    function transfer(address _to, uint256 _value) external returns (bool success) {
        require(balanceOf[msg.sender] >= _value);
        _transfer(msg.sender, _to, _value);
        return true;
    }

    //  helper transfer function with required safety checks -Function - internal helper function
    /// _from, funds from the sender
    ///  _to receiver of token
    ///  _value amount value of token to send
    
    //  Emit Transfer Event
    function _transfer(address _from, address _to, uint256 _value) internal {
        // address should be valid
        require(_to != address(0));
        balanceOf[_from] = balanceOf[_from] - (_value);
        balanceOf[_to] = balanceOf[_to] + (_value);
        emit Transfer(_from, _to, _value);
    }

    //  Approve others to spend(tokens) on your behalf -- Function
    //  _spender allowed to spend and a max amount allowed to spend
    //  _value amount value of token to send
    // return  true, success once address approved
  
    function approve(address _spender, uint256 _value) external returns (bool) {
        require(_spender != address(0));
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    // aproved person from original address of an amount within approved limit 
    ///  _from -- address sending to and the amount to send
    ///  _to --  receiver of token
    ///  _value --  amount value of token to send
    /// internal helper transfer function with required safety checks
    /// returns true, success once transfered from original account    
    //also allowing spender to spend on your behalf
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool) {
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);
        allowance[_from][msg.sender] = allowance[_from][msg.sender] - (_value);
        _transfer(_from, _to, _value);
        return true;
    }

}