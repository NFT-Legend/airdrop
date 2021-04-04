const Airdrop = artifacts.require("Airdrop");
const Whitelist = artifacts.require("Whitelist");
const NGC = artifacts.require("NGC");

module.exports = (deployer, network, accounts) => {

    var airdrop;
    var whitelist;
    var ngc;

    deployer.deploy(Airdrop).then(ins => {
        airdrop = ins;
    });
    deployer.deploy(Whitelist).then(ins => {
        whitelist = ins;
    });
    deployer.deploy(NGC, "NFT Legend Game Coin", "NGC", 18, "100000000000000000000000000").then(ins => {
        ngc = ins;
        whitelist.setMainAddr(airdrop.address);
        airdrop.setAddress(ngc.address, whitelist.address);
    });


};
