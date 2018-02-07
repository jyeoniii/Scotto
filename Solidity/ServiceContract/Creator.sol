contract Creator {
    address addr;
    uint tokenAmount;

    function Creator (address _addr, uint _tokenAmount) public{
        addr = _addr;
        tokenAmount = _tokenAmount;
    }
}
