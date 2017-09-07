const ENS = artifacts.require("./ENS.sol");
const FIFSRegistrar = artifacts.require('./FIFSRegistrar.sol');
const PublicResolver = artifacts.require('./PublicResolver.sol');
const namehash = require('eth-ens-namehash');

const Web3 = require('web3');
const web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

module.exports = function(deployer, network, accounts) {
  var domain = 'irondoers';
  var tld = 'test';

  deployer.deploy(ENS)
    .then(function() {
      return deployer.deploy(FIFSRegistrar, ENS.address, namehash.hash(tld));
    })
    .then(function() {
      return ENS.at(ENS.address).setSubnodeOwner('0x0', web3.sha3(tld), FIFSRegistrar.address);
    })
    .then(function() {
      return deployer.deploy(PublicResolver, ENS.address);
    })
    .then(function() {
      return FIFSRegistrar.at(FIFSRegistrar.address).register(web3.sha3(domain), web3.eth.accounts[0]);
    })
    .then(function() {
      return ENS.at(ENS.address).setResolver(namehash.hash(domain + '.' + tld), PublicResolver.address);
    });
};
