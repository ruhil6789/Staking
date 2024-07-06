//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Token.sol";

contract Staking is MyToken {
    IERC20 public stakingToken;
    IERC20 public rewardToken;
    MyToken public token;

    address owner;

    uint public duration;
    uint public finishTime;
    uint public rewardRate;

    uint rewardPerToken;

    mapping(address => uint) public userRewardPerToken;
    mapping(address => uint) public rewards;

    // uint totalSupply;

    uint public index; // rebasing index
    uint public lastIndexUpdate;

    mapping(address => uint) balanceOof;
    constructor(address _StakingToken, address _rewardToken, address _myToken) {
        owner = msg.sender;
        stakingToken = IERC20(_StakingToken);
        rewardToken = IERC20(_rewardToken);
        token = MyToken(_myToken);
        index = 0;
        lastIndexUpdate = block.timestamp;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "not the owner");
        _;
    }

    struct User {
        address user;
        uint stakeToken;
        uint recievedToken;
        uint duration;
        uint userIndex;
        uint timestamp;
    }
    mapping(address => User) public users;
    User public user;

    function totalSupplyOfToken(
        address _token,
        uint amount
    ) public view returns (uint) {
        return MyToken(_token).totalSupply();
    }

    function stake(address _user, uint _amount) public {
        require(_amount > 0, "amount is less than zero");
        uint currentTime = block.timestamp;
        uint timeElapsed = currentTime - lastIndexUpdate;
        uint newIndex = stakingToken.balanceOf(address(this)) /
            rewardToken.totalSupply(); // we can get the index of the user

        User memory newuser = User({
            user: _user,
            stakeToken: _amount,
            recievedToken: 0,
            duration: block.timestamp,
            userIndex: newIndex,
            timestamp: block.timestamp
        });
        MyToken(token).mint(address(this), _amount);
        // require(_amount > 0,"amount transfered to the addreisss");
        // MyToken(token).approve(address(this), _amount);
        MyToken(token).transferFrom(msg.sender, address(this), _amount);
        balanceOof[msg.sender] += _amount;
        users[_user] = newuser;
        // return _amount;
    }

    function withdraw(uint _amount) public {
        require(
            users[msg.sender].stakeToken >= _amount,
            "insufficient balance"
        );
        require(_amount > 0, "amount is less than zero");
        uint recievedToken = rewardToken.balanceOf(address(this)) * index;

        User memory newUser = User({
            user: msg.sender,
            stakeToken: users[msg.sender].stakeToken - _amount,
            recievedToken: recievedToken,
            duration: block.timestamp - users[msg.sender].duration,
            userIndex: users[msg.sender].userIndex,
            timestamp: block.timestamp
        });
        MyToken(token).transfer(msg.sender, _amount);
    }

    function updateIndex() public {
        uint currentTime = block.timestamp;
        uint timeElapsed = currentTime - lastIndexUpdate;
        uint newIndex = index * (1 + (rewardRate * timeElapsed));
        index = newIndex;
        lastIndexUpdate = currentTime;
    }

    function getUserReward(address _user) public view returns (uint) {
        uint userIndex = users[_user].userIndex;
        uint newIndex = index;
        uint reward = users[_user].stakeToken / newIndex;
        return reward;
    }
}
