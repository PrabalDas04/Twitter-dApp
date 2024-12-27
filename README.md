# Twitter-dApp
These are smart contracts for a decentralised social media app, named Twitter dApp, written in Solidity.
# Deployment
These are compiled and executed in Remix IDE and deployed in Sepolia Testnet using Metamask.
I have also integrated "Ownable.sol" smart contract from Openzeppelin for further security.
"Twitter-User-Reg.sol" deployed at address 0xA8AF3EC1be3De9E5d58967E62591889c87D8372B
"Twitter.sol" deployed at address 0x285cE417198b935564766c96a3EC20B6dfB37EC7
# Details
"Twitter-User-Reg.sol" smart contract creates an user profile with user name and bio.
Using "Twitter.sol" smart contract, we can create, like, dislike, edit and delete tweets, if we are a registered user and we have required authorisation.
we can also get all tweets and total no of likes of an user with it's address.
I have also enabled event notification if those events are occurred.
# Further work
Since, this smart contract provide a backbone for a decentralised social media application, we can give it a graphics UI for ease of access.
We can also add more features like comment section, followers etc.
