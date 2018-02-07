pragma solidity ^0.4.0;

//erc 20 : more at token delegation or token distribution delegation
/* erc 223 : protecting from getting lost, contracts에 배포용 */

interface ERC223 {
  function transfer(address _to, uint _value, bytes _data) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint value, bytes data);
}


/*
ERC223 장점 :
받은 토큰을 어떻게 쓸지가 구현이 안된 contract에 실수로 잘못 토큰을 보내서 사라지는 상황을 방지
https://github.com/Dexaran/ERC223-token-standard#erc223-advantages
*/
