const DrachmaToken = artifacts.require("DrachmaToken");

contract("DrachmaToken", (accounts) => {

    before(async () => {
        drachmatoken = await DrachmaToken.deployed();
        console.log("Drachma Contract Address: " + drachmatoken.address);
    })

    it("Gives the owner 1T tokens", async () => {
        let balance = await drachmatoken.balanceOf(accounts[0]);
        balance = web3.utils.fromWei(balance, "ether");
        assert.equal(balance, "1000000000000", "Balance should be 1T tokens for contract creator.")
    })

    it("Burns 2% of tokens transfered between accounts", async () => {
        let amount =  web3.utils.toWei("100", "ether")
        await drachmatoken.transfer(accounts[1], amount, {from: accounts[0]});
        let balance = await drachmatoken.balanceOf(accounts[1]);
        balance = web3.utils.fromWei(balance, "ether");
        assert.equal(balance, "98", "Reciever balance should be 98 tokens.")
    })

})