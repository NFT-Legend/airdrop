const Airdrop = artifacts.require("Airdrop");
const Whitelist = artifacts.require("Whitelist");
const NGC = artifacts.require("NGC");

contract("Airdrop test", async accounts => {

    it("test", async () => {
        let airdrop = await Airdrop.deployed();
        let start = Math.floor(new Date("2021-04-04T14:40:29.698Z").getTime() / 1000);
        let end = Math.floor(new Date("2021-04-06T14:40:29.698Z").getTime() / 1000);
        airdrop.setParas(web3.utils.toWei("100", "ether"), start, end);

        let whitelist = await Whitelist.deployed();
        // 添加白名单
        await whitelist.add([accounts[1], accounts[2], accounts[3]]);

        // 检查是否可领取
        let result = await whitelist.checkAddress(accounts[1]);
        assert.equal(result, true);

        // 发行100000 NGC给空投合约
        let ngc = await NGC.deployed();
        let name = await ngc.name();
        let symbol = await ngc.symbol();
        console.log(name, symbol);
        await ngc.mint(airdrop.address, web3.utils.toWei("100000", "ether"))
        let balance = await ngc.balanceOf(airdrop.address);
        assert.equal(web3.utils.fromWei(balance, "ether"), "100000");

        // 检查余额
        balance = await ngc.balanceOf(accounts[1]);
        assert.equal(balance.toString(), "0");

        // 领取空投
        await airdrop.withdraw({ "from": accounts[1] });

        // 检查余额
        balance = await ngc.balanceOf(accounts[1]);
        assert.equal(web3.utils.fromWei(balance, "ether"), "100");

        // 检查领取状态
        result = await whitelist.checkAddress(accounts[1]);
        assert.equal(result, false);
    });

});