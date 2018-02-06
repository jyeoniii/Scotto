pragma solidity ^0.4.0;

contract Token {
    string internal _symbol;
    string internal _name;
    uint8 internal _decimals;
    uint internal __totalSupply = 1000;
    mapping (address => uint) internal __balanceOf;
    mapping (address => mapping (address => uint)) internal __allowances;

    function Token(string symbol, string name, uint8 decimals, uint totalSupply) public {
        _symbol = symbol;
        _name = name;
        _decimals = decimals;
        __totalSupply = totalSupply;
    }

    // 새로 추가된 4개의 기본 함수들.
    function name() public constant returns (string) {
        return _name;
    }

    function symbol() public constant returns (string) {
        return _symbol;
    }

    function decimals() public constant returns (uint8) {
        return _decimals;
    }

    function totalSupply() public constant returns (uint) {
        return __totalSupply;
    }

    // 기존 abstract function들
    function balanceOf(address _addr) public constant returns (uint);
    function transfer(address _to, uint _value) public returns (bool);
    event Transfer(address indexed _from, address indexed _to, uint _value);
}
