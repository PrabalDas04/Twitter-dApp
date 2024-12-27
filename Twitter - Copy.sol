//SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

// import Ownable contract from Openzeppelin
import "@openzeppelin/contracts/access/Ownable.sol";

// interface of user profile contract
interface IProfile
    {
        struct UserProfile
	{
            string displayName;
            string bio;
        }
    function getProfile(address _user) external view returns (UserProfile memory);
    }

// our main contract which is inherent from Ownable.sol contract
contract Tweets is Ownable
{
    // pre-define tweet size in bytes
    uint public MAX_TWEET_SIZE = 10;
    
    // structure for a tweet
    struct Tweet
    {
        address author;
        string content;
        uint id;
        uint256 timestamp;
        uint likes;
    }

    // profile contract defined here 
    IProfile profileContract;

    // initialization of the base constructor "Ownable" by msg.sender
    // parameter of the constructor is a address of a contract, in our case the address of the "Twitter-Interaction-User.sol" contract
    constructor(address _profileContract) Ownable(msg.sender)
    {
        profileContract = IProfile(_profileContract);
    }
    
    // modifier to check only registered user are allowed to create, like, dislike, edit and delete tweets
    modifier onlyRegistered()
    {
        // temporary variable stores the profile details of the msg.sender by using getProfile function
        IProfile.UserProfile memory userProfileTemp = profileContract.getProfile(msg.sender);

        // we need to check whether the user is in the list or not, by the user name size 0 or not
        require(bytes(userProfileTemp.displayName).length > 0, "User is NOT Registered!");
        _;
    }

    // mapping of address with array of structure 
    mapping(address => Tweet[]) internal tweet;

    // events
    event NewTweetRcv(address indexed user, uint id, uint time); 
    event NewLikeRcv(address indexed author, address liker, uint id, uint time);
    event NewDislikeRcv(address indexed author, address disliker, uint id, uint time);
    event TweetDeleted(address indexed author, uint id, uint time);
    event TweetEdited(address indexed author, uint id, uint time);

    // GetTweet takes a input address and returns the corresponding string value
    function GetTweet(address _owner, uint _i) public view returns (Tweet memory)
    {
        return tweet[_owner][_i];
    }
    
    // CreateTweet is a public function which takes a message and assigns it to the sender address
    function CreateTweet(string memory message) public onlyRegistered
    {
        // checking the tweet length
        require(bytes(message).length <= MAX_TWEET_SIZE, "Tweet size is too large.");

	// new tweet initialisation
        Tweet memory NewTweet = Tweet({
            author: msg.sender,
            content: message,
            id: tweet[msg.sender].length,   // current index of the array
            timestamp: block.timestamp,
            likes: 0
           });

        tweet[msg.sender].push(NewTweet);

        // this will emit the notification as "NewTweetRcv"
        emit NewTweetRcv(NewTweet.author, NewTweet.id, NewTweet.timestamp);
    }

    // function for like tweets
    function LikeTweet(address author, uint _i) external onlyRegistered
    {
        // we need to check that the tweet indeed exists
        require(tweet[author][_i].id == _i, "Tweet does not exist!");
        tweet[author][_i].likes += 1;

        // notify when new like recved on a tweet
        emit NewLikeRcv(author, msg.sender, _i, block.timestamp);
    }

    // function for dislike tweets
    function DislikeTweet(address author, uint _i) external onlyRegistered
    {
        require(tweet[author][_i].id == _i, "Tweet does not exist!");
        // need to ensure that the tweet has enough likes to deduct
        require(tweet[author][_i].likes > 0, "Insufficient no of Likes!");
        tweet[author][_i].likes -= 1;

        // notify when new dislike recved on a tweet
        emit NewDislikeRcv(author, msg.sender, _i, block.timestamp);
    }

    // function for deleting a tweet
    function DeleteTweet(uint _id) external onlyRegistered
    {
        // require that index should be in bound
        require(_id < tweet[msg.sender].length, "Index out of bounds");

        // Shift elements to the left
        for (uint i = _id; i < tweet[msg.sender].length - 1; i++)
        {
            tweet[msg.sender][i] = tweet[msg.sender][i + 1];
        }

        // Remove the last element (now a duplicate)
        tweet[msg.sender].pop();

        // notify when tweet deleted
        emit TweetDeleted(msg.sender, _id, block.timestamp);
    }

    // function for editing a tweet
    function EditTweet(uint _id, string memory newMsg) external onlyRegistered
    {
        // require that index should be in bound
        require(_id < tweet[msg.sender].length, "Index out of bounds");
        // require that new tweet size is in bound
        require(bytes(newMsg).length <= MAX_TWEET_SIZE, "Tweet size is too large.");

        // Replace the tweet content
        tweet[msg.sender][_id].content = newMsg;

        // notify when tweet deleted
        emit TweetEdited(msg.sender, _id, block.timestamp);
    }

    // function for getting total likes for a tweet user
    function getTotalLikes(address _user) external view returns(uint)
    {
        uint count = 0;
        // for loop for counting the total no of tweets
        for(uint i = 0; i < tweet[_user].length; i++)
        {
            count = count + tweet[_user][i].likes;
        }
        return count;
    }

    // function for getting all tweets of a specific address
    function getAllTweets(address _owner) public view returns(Tweet[] memory)
    {
        return tweet[_owner];
    }

    // function for changing tweet length(by the owner)
    // onlyOwner modifier is inside Ownable contract
    function changeTweetLength(uint length) public onlyOwner
    {
        MAX_TWEET_SIZE = length;
    }
}
