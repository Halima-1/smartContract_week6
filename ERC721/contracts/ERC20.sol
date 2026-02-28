// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract ERC20 {
    string public name;
        string public symbol;
    uint256 totalSupply;
    uint8 public immutable TOKEN_DECIMAL;

    mapping(address => uint256) _balances;
    mapping (address =>mapping (address => uint)) _allowances;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval (address indexed _owner, address indexed _spender, uint256 _value);

    constructor (string memory _name, string memory _symbol, uint8  _decimal, uint256 _totalSupply) {
        name = _name;
        symbol =_symbol;
        totalSupply =_totalSupply;
        TOKEN_DECIMAL = _decimal;
    }

  function mint(address _owner, uint256 _amount) external {
        require(_owner != address(0), "Can't transfer to address zero");
        totalSupply = totalSupply + _amount;
        _balances[_owner] = _balances[_owner] + _amount;
    }
    function balanceOf(address _owner ) public view returns (uint256){
        require(_owner != address(0), "Zero address detected");
        return _balances[_owner];
        // require _balances([_owner], "Insuffucuent fund");
    }
    

    function transfer(address _to, uint256 _value) external{
        require(_balances[msg.sender] >= _value, "Insuffucuent fund");
        _balances[msg.sender] = _balances[msg.sender] = _value;
        _balances[_to] =_balances[_to] + _value;
        emit Transfer( msg.sender, _to, _value);

    }

    function transferFrom(address _from, address _to, uint256 _value ) external returns(bool){
        require(_allowances[msg.sender][_from] >= _value, "Insufficient fund for allowance");
        require(_balances[_from] >= _value && _balances[_from] > 0, "");
        _balances[_from] =_balances[_from] - _value;
        _balances[_to] =_balances[_to] + _value;
        _allowances[msg.sender][_from] =_allowances[msg.sender][_from] - _value;
        emit Transfer(_from, _to, _value);

        return true;
        }

        function approval(address _spender, uint256 _value) external returns (bool){
            require(_balances[msg.sender] >= _value, "no allowance received");
            _allowances[_spender][msg.sender] = _allowances[_spender][msg.sender] - _value;
            emit Approval(msg.sender, _spender, _value);
            return true;
        }


        function allowance(address _owner, address _spender)external view returns (uint256){
            return _allowances[_spender][_owner];
        }

}

