pragma solidity ^0.4.0;

import "browser/ERC20.sol"; // Remix 상에서 ERC.sol 파일 만든 후 ERC20tokens.sol 복붙
                            // 다른 환경에서 import할 경우 알아서 경로 변경
import "browser/Token.sol";
import "browser/ERC223.sol";
import "browser/ERC223Receiving.sol";

import "zeppelin-solidity/contracts/math/SafeMath.sol"; // transfer에서 value add or sub 할 때 안전하게 계산해주는 라이브러리

// Token, ERC20, ERC223 상속.
contract MyFirstToken is Token("MFT", "My First Token", 18, 1000), ERC20, ERC223 {


  //constructor
  function MyFirstToken(){
    __balanceOf[msg.sender] = __totalSupply; // 만든 사람에게 모든 tokens 준다. 이후 어떠한 조작도 불가.
  }

  function totlaSupply() constant returns (uint _totalSupply){
      _totalSupply = __totalSupply;
  }

  function balanceOf(address addr) constant returns (uint balance){
      return __balanceOf[adwdr];
  }
  //ERC20의 transfer 함수였으나 여기서는 contract가 아닌 non-contract address에게만 transfer하도록 수정함.
  function transfer(address _to, uint _value) returns (bool success){
      if (_value > 0 &&
        _value <= balanceOf(msg.sender) &&
        !isContract(_to)){ // 대상이 contract 주소가 아니어야 transfer 실행.
        __balanceOf[msg.sender] = __balanceOf[msg.sender].sub(_value); // safeMath의 subtraction 함수
          __balanceOf[_to] = __balanceOf[_to].add(_value); // safeMath의 addition 함수
          Transfer(msg.sender, _to, _value);// interface에서 등록한 이벤트
        return true;
      }

      return false;
  }
  //ERC223에서 새로 만든, contract에 보내는 transfer 함수.
  function transfer(address _to, uint _value, bytes _data) public returns (bool){ // contract 에 전송할 data 추가.
    if (_value > 0 &&
      _value <= balanceOf(msg.sender) &&
      isContract(_to)){ // 대상이 contract 주소가 아니어야 transfer 실행.
      __balanceOf[msg.sender] = __balanceOf[masg.sender].sub(_value); // safeMath의 subtract 함수
      __balanceOf[_to] = __balanceOf[_to].add(_value); // safeMath의 addition 함수

      //받는 contract 또한 ERC223 standard를 따라야됨. tokenFallback 함수가 있는지 확인하는 것.
      ERC223ReceivingContract _contract = ERC223ReceivingContract(_to); // Token을 받아서 작업 수행을 하는 기능이 있는 contract에게만 보낼 수 있음.
      _contract.tokenFallback(msg.sender, _value, _data);

      Transfer(msg.sender, _to, _value, _data);// interface에서 등록한 이벤트
      return true;
    }

    return false;
  }
    //ERC20의 transferFrom 함수
  function transferFrom(address _from, address _to, uint _value) returns (bool success){
    if(  __allowances[_from][msg.sender] > 0 &&
      _value > 0 &&
      __allowances[_from][msg.sender] >= _value &&
      __balanceOf[_from] >= _value){ // 비디오에 없는 부분. 조건 추가
        __balanceOf[_from] = __balanceOf[_from].sub(_value); // safeMath의 subtract 함수
          __balanceOf[_to] = __balanceOf[_to].add(_value); // safeMath의 addition 함수
         __allowances[_from][msg.sender] -= _value; // 비디오에서 빠진 부분
         Transfer(_from, _to, _value); // interface에서 등록한 이벤트
        return true;
      }
      return false;
  }

  //ERC 20 과 ERC223의 차이점은 우리가 token을 보내는 contract가 존재하는지 확인하는 것.
  function isContract(address _addr) returns(bool){
    //inline assembly를 써야됨 . 이유는 실제 contract code가 그 주소에 존재하는지 확인하는 유일한 방법(?)
    //code가 존재한다면 그 길이가 0보다 클 것.

    uint codeSize;
    assembly {

      codeSize := extcodesize(_addr)
      // allocation operation in assembly
    }

    return codeSize > 0;
  }
  //ERC223의 transfer 함수


          //ERC223의 transferFrom 함수
  function approve(address _spender, uint _value) returns (bool success){
    __allowances[msg.sender][_spender] = _value; // msg.sender가 _spender이 자기 토큰을 _value만큼 쓰도록 허락한 정보를 mapping 에 저장. 여러 제약 추가 가능.
     Approval(msg.sender, _spender, _value); // interface에 등록한 이벤트
    return true;
  }

  function allowance(address _owner, address _spender) constant returns (uint remaining){
    // spender 가 owner 의 계좌에서 얼만큼 쓸 수 있는지 보여줌

 return __allowances[_owner][_spender];
    //owner 가 undefined일 경우 에러 발생 가능.


  }


}
