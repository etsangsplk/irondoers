const IronDoers = artifacts.require("./IronDoers.sol");
const IronPromise = artifacts.require("./IronPromise.sol");

module.exports = function(deployer, network, accounts) {
  deployer.deploy(IronDoers)
    .then(function() {
      return deployer.deploy(IronPromise, IronDoers.address);
    });
};
