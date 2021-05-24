pragma solidity ^0.8.0;

interface IPayments {
    event _localTransferFrom(
            address indexed _token,
            address indexed _from,
            address indexed _to,
            uint _value);
    
    event _registerToken(
            address indexed _token,
            uint8 indexed _id
        );

    
    function getBalance(address _token, address _address) external view returns (uint result);
    
    function localTransferFrom(address _token, address _from, address _to, uint _amount) external;
    
    function depositToLocal(address _user_address, address _token, uint _amount) external ;

    function closeDeposit(address _user_address, address _token) external;
}