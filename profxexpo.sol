
// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

abstract contract ReentrancyGuard {
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }
   modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be _NOT_ENTERED
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
         _status = _NOT_ENTERED;
    }
    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == _ENTERED;
    }
}

contract Initializable {

    bool private _initialized;

    bool private _initializing;

    modifier initializer() {
        require(_initializing || !_initialized, "Initializable: contract is already initialized");

        bool isTopLevelCall = !_initializing;
        if (isTopLevelCall) {
            _initializing = true;
            _initialized = true;
        }

        _;

        if (isTopLevelCall) {
            _initializing = false;
        }
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    function ownable(address _newowner) internal {
        _transferOwnership(_newowner);
    }

    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

interface IERC20 {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function burn(uint256 amount) external;

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);
}



abstract contract Pausable is Context {
    event Paused(address account);
    event Unpaused(address account);

    bool private _paused;

    modifier whenNotPaused() {
        _requireNotPaused();
        _;
    }

    modifier whenPaused() {
        _requirePaused();
        _;
    }

    function paused() public view virtual returns (bool) {
        return _paused;
    }

    function _requireNotPaused() internal view virtual {
        require(!paused(), "Pausable: paused");
    }

    function _requirePaused() internal view virtual {
        require(paused(), "Pausable: not paused");
    }

    function _pause() internal virtual whenNotPaused {
        _paused = true;
        emit Paused(_msgSender());
    }

    function _unpause() internal virtual whenPaused {
        _paused = false;
        emit Unpaused(_msgSender());
    }
}

contract PROFXEXPO is  Ownable, Pausable, Initializable, ReentrancyGuard {
   

    struct User {
        uint256 userId;
        address referrer;
        uint256 partnerCount;
        uint256 totalStake;
        uint256 directBusiness;
        uint256 teamBusiness;
        uint256 lastinvest;
        uint256 rewTaken;
        uint256 stakecount;
        uint256 partnersCount;
        uint256 levelIncome;
        bool onof;
    }

    struct Package {
        uint256 packageId;
        uint256 minAmount;
        uint256 dailyROI; // in basis points (0.33% = 33)
        uint256 lockinDuration; // in days
        string packageName;
    }

    address public admin;
    address public operator;
    address public USDT;
    address public UnitySign;

    uint256 public lastUserId;
    mapping(address => User) public users;
    mapping(uint256 => address) public idToAddress;
    mapping(address => uint) public nonce;
    Package[] public packages;
    mapping(uint256 => uint256) public packageMinAmounts;


    event Registration(
        address indexed user,
        address indexed referrer,
        uint256 userId,
        uint256 referrerId
    );
   
    event Stake(address indexed user, uint amount, uint plan);
    event MemberPayment(address indexed  investor,uint netAmt);
    event Withdraw(address indexed user, uint amount, uint nonce);

    modifier onlyOperator {
        require(_msgSender()==operator,"Forbidden! Only Operator Can Call");
        _;
    } 

     function initialize( address _usdt, address _owner)  external initializer  {
        USDT = _usdt;
     
        ownable(_owner);
        

        packages.push(Package(1, 50 * 10**18, 33, 90, "Precious Metals"));
        packages.push(Package(2, 500 * 10**18, 50, 180, "Real Estate"));
        packages.push(Package(3, 2500 * 10**18, 67, 360, "US Stocks"));
        packages.push(Package(4, 5000 * 10**18, 80, 720, "Forex Market"));
        packages.push(Package(5, 10000 * 10**18, 100, 1080, "Digital Assets"));
        
        // Initialize mapping
        for (uint256 i = 0; i < packages.length; i++) {
            packageMinAmounts[packages[i].packageId] = packages[i].minAmount;
        }

        lastUserId = 1;
        users[_owner].userId = lastUserId;
        idToAddress[lastUserId] = _owner;
        lastUserId++;
        emit Registration(_owner, address(0), 1, 0);
    } 

     function registration(address userAddress, address referrerAddress) private {
        require(!isUserExists(userAddress), "User Exists!");
        require(isUserExists(referrerAddress), "Referrer not Exists!");
        users[userAddress].userId = lastUserId; 
        idToAddress[users[userAddress].userId] = userAddress;       
        users[userAddress].referrer = referrerAddress;
        users[userAddress].partnersCount = 0;
        lastUserId++;
        users[referrerAddress].partnersCount++;
        emit Registration(userAddress, referrerAddress, users[userAddress].userId,users[referrerAddress].userId);
    } 


        function stake(uint amount, uint plan, address _referral) public {
         if(!isUserExists(_msgSender())){
        registration(_msgSender(),_referral);
        }
        require(isUserExists(_msgSender()), "Dsclab: User not Exists!");
        require(plan == 1 && amount >= packages[plan].minAmount, "Invalid Investment Amount for this Plan");
        uint lastinvst = users[_msgSender()].lastinvest;
        // if(lastinvst > 0){
        // require(amount >= lastinvst, "Re Investment Should Equal/Greater than last Investment");    
        // }

        address ref = users[_msgSender()].referrer;
        emit Stake(msg.sender, amount, plan);
        users[_msgSender()].lastinvest = amount;
        users[_msgSender()].totalStake += amount;
        uint refStake = users[_msgSender()].totalStake;
        if(refStake == 0){
        users[ref].partnerCount++;
        }
        
    }


    function isUserExists(address user) public view returns (bool) {
        return (users[user].userId != 0);
    }

    function pause() external onlyOperator {
      _pause();
    }

    function unpause() external onlyOperator {
       _unpause();
    }

    function withdrawLost(uint256 WithAmt) public {
        require(_msgSender() == owner(), "onlyOwner");
        payable(owner()).transfer(WithAmt*1e18);
    }
  
	function withdrawLostTokenFromBalance(uint QtyAmt,IERC20 _TOKEN) public {
        require(_msgSender() == owner(), "onlyOwner");
        _TOKEN.transfer(owner(),(QtyAmt*1e18));
	}

    function multisendToken(address payable[]  memory  _contributors, uint256[] memory _balances, uint256 totalQty,IERC20 _TKN) public payable {
    	uint256 total = totalQty;
        uint256 i = 0;
        for (i; i < _contributors.length; i++) {
            require(total >= _balances[i]);
            total = total - _balances[i];
            _TKN.transferFrom(msg.sender, _contributors[i], _balances[i]);
			      emit MemberPayment(_contributors[i],_balances[i]);
        }
    }

    function getWithdrawHash(
        address user,
        uint256 weeklyReward,
        uint256 deadline
    ) public view returns (bytes32) {
        return
            keccak256(
                abi.encodePacked(
                    user,
                    weeklyReward,
                    nonce[user],
                    deadline,
                    block.chainid,
                    address(this)
                )
            );
    }

    // Add time-bound signature verification
    function verifySignatureWithDeadline(
        bytes32 hash,
        uint8 v,
        bytes32 r,
        bytes32 s,
        uint256 deadline
    ) internal view returns (bool) {
        require(block.timestamp <= deadline, "Signature expired");
        bytes32 messageHash = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
        );
        address signer = ecrecover(messageHash, v, r, s);
        return signer == UnitySign;
    }

    function withdrawRoi(
        uint256 amount,
        uint8 v,
        bytes32 r,
        bytes32 s,
        uint256 deadline
    ) external nonReentrant {
        require(isUserExists(_msgSender()), "user not exists");
        require(verifySignatureWithDeadline(getWithdrawHash(_msgSender(), amount,  deadline),v,r,s,deadline),"invalid signature");
        uint polAmt =  amount;

        payable(_msgSender()).transfer(polAmt);
        emit Withdraw(_msgSender(),amount,nonce[_msgSender()]);
        nonce[_msgSender()]++;
    }
    
    function setUnitySignWallet(address _UnitySign) external onlyOwner {
        UnitySign = _UnitySign;
    }
 
}