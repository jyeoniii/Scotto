pragma solidity ^0.4.11;

 /**
 * @title Contract that will work with ERC223 tokens.
 */

//토큰을 받는 contract. 이것도 ERC223 standard를 따라야 하. fallback 함수만 만들어놨음.
contract ERC223ReceivingContract {
/**
 * @dev Standard ERC223 function that will handle incoming token transfers.
 *
 * @param _from  Token sender address.
 * @param _value Amount of tokens.
 * @param _data  Transaction metadata.
 */
    function tokenFallback(address _from, uint _value, bytes _data);
}
