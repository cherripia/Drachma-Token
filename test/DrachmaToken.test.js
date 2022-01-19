const DrachmaToken = artifacts.require("DrachmaToken");

contract("DrachmaToken", (accounts) => {

    before(async () => {
        drachmatoken = await DrachmaToken.deployed();
        console.log("Drachma Contract Address: " + drachmatoken.address);
    })

    it("Gives the owner 1T tokens", async () => {
        let balance = await drachmatoken.balanceOf(accounts[0]);
        console.log("Accounts[0] balance (in wei): " + balance);
        balance = web3.utils.fromWei(balance, "ether");
        console.log("Accounts[0] balance: " + balance);
        assert.equal(balance, "1000000000000", "Balance should be 1T tokens for contract creator.")
    })

    it("Can transfer tokens between accounts", async () => {
        let amount =  web3.utils.toWei("100", "ether")
        console.log("Transfering " + amount + " tokens.");
        await drachmatoken.transfer(accounts[1], amount, {from: accounts[0]});
        let balance = await drachmatoken.balanceOf(accounts[1]);
        balance = web3.utils.fromWei(balance, "ether");
        console.log("Accounts[1] balance after transfer: " + balance);
        assert(balance > 0, "Reciever balance should greater than 0.")
    })

    it("Burns 2% of tokens between transfers", async () => {
        let amount =  web3.utils.toWei("100", "ether")
        await drachmatoken.transfer(accounts[1], amount, {from: accounts[0]});
        let balance = await drachmatoken.balanceOf(accounts[1]);
        balance = web3.utils.fromWei(balance, "ether");
        console.log("Accounts[1] balance after transfer: " + balance);
        assert.equal(balance > 0, "Reciever balance should be 196.")
    })

})