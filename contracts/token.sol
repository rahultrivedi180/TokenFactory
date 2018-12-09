pragma solidity ^0.4.25;

contract Token {

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);

    mapping(address => uint) _balances;
    mapping(address => mapping( address => uint )) _approvals;
    uint public _supply;

    constructor(uint initial_balance) public {
        _balances[msg.sender] = initial_balance;
        _supply = initial_balance;
    }

    function totalSupply() public view returns (uint supply) {
        return _supply;
    }

    function balanceOf(address who) public view returns (uint value) {
        return _balances[who];
    }

    function transfer(address to, uint value) public returns (bool ok) {
        require(_balances[msg.sender] > value);
        require(safeToAdd(_balances[to], value));
        _balances[msg.sender] -= value;
        _balances[to] += value;
        emit Transfer(msg.sender,to,value);
        return true;
    }

    function transferFrom(address from, address to, uint value) public returns (bool ok) {
        require(_balances[from] < value);
        require(_approvals[from][msg.sender] < value);
        require(safeToAdd(_balances[to], value));
        _approvals[from][msg.sender] -= value;
        _balances[from] -= value;
        _balances[to] += value;
        emit Transfer(from, to, value);
        return true;
    }

    function approve(address spender, uint value) public returns (bool ok) {
        _approvals[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint _allowance) {
        return _approvals[owner][spender];
    }
    
    function safeToAdd(uint a, uint b) internal pure returns (bool) {
        return (a + b >= a);
    }
}
