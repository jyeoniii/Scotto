pragma solidity ^0.4.0;

interface ERC20 {
    function totalSupply() public view returns (uint _totalSupply);
    function balanceOf(address _owner) public view returns (uint balance);
    function transfer(address _to, uint _value) public returns (bool success);
    function transferFrom(address _from, address _to, uint _value) public returns (bool success);
    function approve(address _spender, uint _value) public returns (bool success);
    function allowance(address _owner, address _spender) public view returns (uint remaining);
    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}


contract Scottoken is ERC20 {
    string public constant symbol = "SCT";
    string public constant name = "SCOTTOKEN";
    uint8 public constant decimals = 0;

    uint private constant __totalSupply = 10000000;
    uint private __circulation = 0;
    address _owner;
    mapping (address => uint) internal __balanceOf;
    mapping (address => mapping (address => uint)) private __allowances;
    mapping (address => bool) private faucet_list;

    function Scottoken() public {
        _owner = msg.sender;
        __balanceOf[_owner] = __totalSupply;
    }

    function totalSupply() public view returns (uint _totalSupply) {
        _totalSupply = __totalSupply;
    }

    function balanceOf(address _addr) public view returns (uint balance) {
        return __balanceOf[_addr];
    }

    function transfer(address _to, uint _value) public returns (bool success) {
        if(_value > 0 && _value <= balanceOf(msg.sender)){
            __balanceOf[msg.sender] -= _value;
            __balanceOf[_to] += _value;
            return true;
        }
        return false;
    }

    event transferAmount(uint);
    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
        if(__allowances[_from][msg.sender] > 0 &&
            _value > 0 &&
            __allowances[_from][msg.sender] >= _value &&
            __balanceOf[_from] >= _value){
            __balanceOf[_from] -= _value;
            __balanceOf[_to] += _value;
            // Missed from the video
            __allowances[_from][msg.sender] -= _value;
            return true;
        }
        return false;
    }

    function approve(address _spender, uint _value) public returns (bool success) {
        __allowances[msg.sender][_spender] += _value;
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint remaining) {
        return __allowances[_owner][_spender];
    }

    // For Java VM testing purpose
    // distribute tokens
    function faucet() public {
        require(__circulation <= __totalSupply);
        require(faucet_list[msg.sender] == false);
        faucet_list[msg.sender] = true;
        __circulation += 100;
        __balanceOf[msg.sender] += 100;
        __balanceOf[_owner] -= 100;
    }

    function getCirculate() public view returns(uint){
        return __circulation;
    }
}
