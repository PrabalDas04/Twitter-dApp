// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

contract Profile {
    // structure for a user profile
    struct UserProfile
    {
        string displayName;
        string bio;
    }
    
    // mapping between address and structure User profile
    mapping(address => UserProfile) internal profiles;

    // dunction for setting a new profile
    function setProfile(string memory _displayName, string memory _bio) public
    {
        profiles[msg.sender] = UserProfile(_displayName, _bio);
    }

    // function for getting details of a user
    function getProfile(address _user) public view returns (UserProfile memory)
    {
        return profiles[_user];
    }
}
