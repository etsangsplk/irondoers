pragma solidity ^0.4.0;

import "./IronDoersAbstract.sol";

contract IronPromise {

    address public deployer;

    IronDoersAbstract public doers;

    struct Promise {
        address doer;
        string thing;
        uint expire;
        uint value;
        bytes32 hash;
    }

    struct Fulfillment {
        address doer;
        bytes32 promise;
        string proof;
        uint timestamp;
        bytes32 hash;
    }

    mapping(bytes32 => Promise) public promises;
    mapping(bytes32 => Fulfillment) public fulfillments;

    uint public promiseCount;
    uint public fulfillmentCount;

    modifier onlyDoers {
        if (!doers.isDoer(msg.sender)) revert();
        _;
    }

    function IronPromise(IronDoersAbstract abs) {
        fulfillmentCount = 0;
        deployer = msg.sender;
        doers = abs;
    }

    function promise(string thing, uint expire) payable onlyDoers {
        require(expire > block.timestamp);
        require(msg.value > 0);

        bytes32 h = sha3(msg.sender, thing);
        promises[h] = Promise({doer: msg.sender, thing: thing, expire: expire, value: msg.value, hash: h});
        promiseCount++;
    }

    function fulfill(string thing, string proof) onlyDoers {
        // Validate existing promise.
        bytes32 ph = sha3(msg.sender, thing);
        require(block.timestamp < promises[ph].expire);

        bytes32 fh = sha3(msg.sender, proof);
        fulfillments[fh] = Fulfillment({doer: msg.sender, promise: promises[ph].hash, proof: proof, timestamp: block.timestamp, hash: fh});
        fulfillmentCount++;
    }

    function getDeployer() constant returns (address) {
        return deployer;
    }

    function getDoers() constant returns (IronDoersAbstract) {
        return doers;
    }

    function getPromiseCount() constant returns (uint) {
        return promiseCount;
    }

    function getFulfillmentCount() constant returns (uint) {
        return fulfillmentCount;
    }
}
