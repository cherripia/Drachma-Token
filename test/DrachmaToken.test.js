const DrachmaToken = artifacts.require("DrachmaToken");

contract("DrachmaToken", (accounts) => {

    before(async () => {
        drachmatoken = await DrachmaToken.deployed();
        console.log("Drachma Contract Address: " + drachmatoken.address);
    })

    it("Gives the contract creator 1T tokens", async () => {
        let balance = await drachmatoken.balanceOf(accounts[0]);
        console.log("Accounts[0] balance (in wei): " + balance);
        balance = web3.utils.fromWei(balance, "ether");
        console.log("Accounts[0] balance: " + balance);
        assert.equal(balance, "1000000000000", "Balance should be 1T tokens for contract creator.")
    })

    it("Excludes contract creator from transfer fees", async () => {
        let amount =  web3.utils.toWei("100", "ether")
        console.log("Transfering " + amount + " tokens.");
        await drachmatoken.transfer(accounts[1], amount, {from: accounts[0]});
        let balance = await drachmatoken.balanceOf(accounts[1]);
        balance = web3.utils.fromWei(balance, "ether");
        console.log("Accounts[1] balance after transfer: " + balance);
        assert.equal(balance, 100, "Reciever balance should 100.")
    })

    it("Burns 2% of tokens between normal account transfers", async () => {
        let amount =  web3.utils.toWei("100", "ether")
        await drachmatoken.transfer(accounts[2], amount, {from: accounts[1]});
        let balance = await drachmatoken.balanceOf(accounts[2]);
        balance = web3.utils.fromWei(balance, "ether");
        console.log("Accounts[2] balance after transfer: " + balance);
        assert.equal(balance, "98", "Reciever balance should be 98.")
    })

})