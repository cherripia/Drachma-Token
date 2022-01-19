const DrachmaToken = artifacts.require("DrachmaToken");

module.exports = function (deployer) {
  deployer.deploy(DrachmaToken, 1000000000000);
};