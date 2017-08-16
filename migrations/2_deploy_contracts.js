const IronDoers = artifacts.require("./IronDoers.sol");
const IronPromise = artifacts.require("./IronPromise.sol");
const IronToken = artifacts.require("./IronToken.sol");

module.exports = function(deployer, network, accounts) {
  deployer.deploy(IronDoers)
    .then(function() {
      deployer.deploy(IronPromise, IronDoers.address);
    })
    .then(function() {
      deployer.deploy(IronToken);
    });
};
