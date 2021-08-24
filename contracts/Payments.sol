// SPDX-License-Identifier: MIT

/*
    Created by DeNet
*/

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract Payments is Ownable {
    using SafeMath for uint256;

    string public name;
    address public PoS_Contract_Address;

    constructor(string memory _name, address _address) {
        name = _name;
        PoS_Contract_Address = _address;
    }

    modifier onlyPoS() {
        require(msg.sender == PoS_Contract_Address);
        _;
    }

    function changePoS(address _new_address) public onlyOwner {
        PoS_Contract_Address = _new_address;
        emit ChangePoSContract(_new_address);
    }

    event ChangePoSContract(address indexed PoS_Contract_Address);

    event LocalTransferFrom(
        address indexed _token,
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    event registerToken(address indexed _token, uint8 indexed _id);

    mapping(address => mapping(address => uint256)) public balances;

    uint8 _tokensCount = 0;
    address[] _knowableTokens;

    function RegisterToken(address _token) private {
        _tokensCount++;
        _knowableTokens.push(_token);
        emit registerToken(_token, _tokensCount - 1);
    }

    function _addBalance(
        address _token,
        address _address,
        uint256 _balance
    ) private {
        balances[_token][_address] = balances[_token][_address].add(_balance);
    }

    function getBalance(address _token, address _address)
        public
        view
        returns (uint256 result)
    {
        return balances[_token][_address];
    }

    function localTransferFrom(
        address _token,
        address _from,
        address _to,
        uint256 _amount
    ) public onlyPoS {
        require(balances[_token][_from] >= _amount);
        require(0 < _amount);

        balances[_token][_from] = balances[_token][_from].sub(_amount);
        balances[_token][_to] = balances[_token][_to].add(_amount);

        emit LocalTransferFrom(_token, _from, _to, _amount);
    }

    function depositToLocal(
        address _user_address,
        address _token,
        uint256 _amount
    ) public onlyPoS {
        require(_amount > 0);

        bool founded = false;

        for (uint8 i = 0; i < _tokensCount; i++) {
            if (_knowableTokens[i] == _token) {
                founded = true;
                break;
            }
        }

        if (!founded) RegisterToken(_token);

        IERC20 tok = IERC20(_token);
        tok.transferFrom(_user_address, address(this), _amount);
        _addBalance(_token, _user_address, _amount);
    }

    /**
            TODO:
                - add vesting/unlockable balance
     **/
    function closeDeposit(address _user_address, address _token)
        public
        onlyPoS
    {
        IERC20 tok = IERC20(_token);
        tok.transfer(_user_address, balances[_token][_user_address]);
        balances[_token][_user_address] = 0;
    }
}
