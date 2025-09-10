/**
 *Submitted for verification at BscScan.com on 2025-07-31
*/

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

interface IUniswapV2Router01 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
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

contract DSCSTAKE is  Ownable, Pausable, Initializable, ReentrancyGuard {
   

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

    address public admin;
    address public operator;
    address public USDT;
    address public DSC;
    address public stDSC;

    uint256 public levelRoiPerDay;
    uint256 public roiPerDay;
    uint256 public multipler;
    uint256 public minWithdraw;
    uint256 public joiningFee;
    uint256 public minStake;
    uint256 public maxStake;

    uint256 public airdropUserCount;
    uint256 public airdropAmount;
    uint256 public airdropPerMonth;

    bool public isAirdropPaused;
    uint256 public TIME_STEP;
    uint256 public lastUserId;
    uint256 public PERCENT_DIVIDER;
    uint256 public LASTLEVEL;
    uint256 public totalStaked;
    uint256 public totalWithdrawal;
    uint256[] public levelBonusShares;
    uint256[] public airdropLevelShares;
    address[] public adminAchivers;
    mapping(uint=>uint) public levelShare;
    mapping(address => bool) public isAdminAchived;
    mapping(address => User) public users;
    mapping(uint256 => address) public idToAddress;
    IUniswapV2Router02 public uniswapRouter;

    event Registration(
        address indexed user,
        address indexed referrer,
        uint256 userId,
        uint256 referrerId,
        string regby
    );
   
    
    event ToppedUp(address indexed user, uint amount, uint token, string plan);
    event Stake(address indexed user, uint amount, uint token, string plan, string tyyp, uint plantype);
    event MemberPayment(address indexed  investor,uint netAmt);

    modifier onlyOperator {
        require(_msgSender()==operator,"Forbidden! Only Operator Can Call");
        _;
    } 

     function initialize( address _usdt, address _dsc, address _stdsc, address _owner)  external initializer  {
        USDT = _usdt;
        DSC = _dsc;
        stDSC = _stdsc;
        ownable(_owner);
        uniswapRouter = IUniswapV2Router02(
            0x10ED43C718714eb63d5aA57B78B54704E256024E
        ); 
        

        levelBonusShares = [100, 50, 30, 20, 10, 20, 20, 20, 30, 30];


        minStake = 60 * 1e18;
        maxStake = 10000 * 1e18;
      
        joiningFee = 30 * 1e18;
        multipler = 2;

        LASTLEVEL = 10;
        TIME_STEP = 1 days;

        PERCENT_DIVIDER = 1000;

        levelShare[1] = 3000;
        levelShare[2] = 1500;
        levelShare[3] = 750;
        levelShare[4] = 500;
        levelShare[5] = 400;

        isAirdropPaused = false;
        lastUserId = 1;
        users[_owner].userId = lastUserId;
        idToAddress[lastUserId] = _owner;
        lastUserId++;
        emit Registration(_owner, address(0), 1, 0,"Owner");
    } 

     function registration(address userAddress, address referrerAddress, string memory tyyp) private {
        require(!isUserExists(userAddress), "User Exists!");
        require(isUserExists(referrerAddress), "Referrer not Exists!");
        users[userAddress].userId = lastUserId; 
        idToAddress[users[userAddress].userId] = userAddress;       
        users[userAddress].referrer = referrerAddress;
        users[userAddress].partnersCount = 0;
        lastUserId++;
        users[referrerAddress].partnersCount++;
        emit Registration(userAddress, referrerAddress, users[userAddress].userId,users[referrerAddress].userId,tyyp);
    } 

    function registrationUSDT(address _user, address _referral) public {
        require(!isUserExists(_user), "Dsclab: User Exists!");
        require(isUserExists(_referral), "Dsclab: Referrer not Exists!");
        registration(_msgSender(),_referral,"USDT");
        require(
            IERC20(USDT).allowance(_msgSender(), address(this)) >= joiningFee,
            "Dsclab: allowance "
        );
        IERC20(USDT).transferFrom(_msgSender(), address(this), joiningFee);

        IERC20(USDT).approve(address(uniswapRouter), joiningFee);
        address[] memory paths = new address[](2);
        paths[0] = USDT;
        paths[1] = DSC;
        uint256[] memory amounts = uniswapRouter.getAmountsOut(
            joiningFee,
            paths
        );
        uniswapRouter.swapExactTokensForTokens(
            joiningFee,
            amounts[1],
            paths,
            address(this),
            block.timestamp + 10
        );
        // TODO: Swap 10 USDT to DSC  using RouterV2 or RouterV3

        users[_user].userId = lastUserId;
        idToAddress[lastUserId] = _user;
        users[_user].referrer = _referral;
        lastUserId++;
        users[_referral].partnerCount++;

        emit Registration(
            _user,
            _referral,
            users[_user].userId,
            users[_referral].userId,
            "USDT"
        );

    }

    function registerbystDSC(address _user, address _referral) external {
        require(!isUserExists(_user), "Dsclab: User Exists!");
        require(isUserExists(_referral), "Dsclab: Referrer does not exist!");

        registration(_user, _referral, "stDSC");

        uint price = 11200000000000000;

        uint256 DSCCMQty=(joiningFee*1e18)/price; 
        
        require(
            IERC20(stDSC).allowance(_msgSender(), address(this)) >= DSCCMQty,
            "stDsclab: Insufficient allowance"
        );

        IERC20(stDSC).transferFrom(_msgSender(), address(this), DSCCMQty);
        IERC20(stDSC).burn(DSCCMQty);
        
        emit Registration(
            _user,
            _referral,
            users[_user].userId,
            users[_referral].userId,
            "stDSC"
        );
    }

    function registerbyDSC(address _user, address _referral) external
	{ 
        require(!isUserExists(_user), "Dsclab: User Exists!");
        require(isUserExists(_referral), "Dsclab: Referrer not Exists!");
        registration(_msgSender(),_referral,"DSC");
        address[] memory path = new address[](2); // Initialize the array with size 2
        path[0] = USDT;
        path[1] = DSC;
        uint rate = getCurrentPrice(path);
        uint dsctotrans = (joiningFee * rate)/1e18;
        require(
            IERC20(DSC).allowance(_msgSender(), address(this)) >= dsctotrans,
            "DSClab: allowance "
        );
      
      IERC20(DSC).transferFrom(_msgSender(), address(this), dsctotrans);
      emit Registration(
            _user,
            _referral,
            users[_user].userId,
            users[_referral].userId,
            "DSC"
        );
 	}

        function stakeUSDT(uint amount, uint plan, address _referral) public {

        if(!isUserExists(_msgSender())){
        registration(_msgSender(),_referral,"USDT");
        }
        require(isUserExists(_msgSender()), "Dsclab: User not Exists!");
        require(amount >= minStake, "Minimum Activation is $60");
        require(amount <= maxStake, "Maximum Activation is $10000");
        require((plan == 1 || plan == 2), "Select Only Plan Flexi or Fix");
        require(
            IERC20(USDT).allowance(_msgSender(), address(this)) >= amount,
            "usdt : allowance "
        );
        uint lastinvst = users[_msgSender()].lastinvest;
        if(lastinvst > 0){
        require(amount >= lastinvst, "Re Investment Should Equal/Greater than last Investment");    
        }
        
        IERC20(USDT).transferFrom(_msgSender(), address(this), amount);

        IERC20(USDT).approve(address(uniswapRouter), amount);

        address[] memory paths = new address[](2);
        paths[0] = USDT;
        paths[1] = DSC;
        uint rate = getCurrentPrice(paths);
        uint dsctotrans = (amount * rate)/1e18;
        uint256[] memory amounts = uniswapRouter.getAmountsOut(
            amount,
            paths
        );
        uniswapRouter.swapExactTokensForTokens(
            amount,
            amounts[1],
            paths,
            address(this),
            block.timestamp + 10
        );
        // TODO: Swap 10 USDT to DSC  using RouterV2 or RouterV3
        address ref = users[_msgSender()].referrer;
        uint usrstake = users[_msgSender()].totalStake;
        string memory stakeType = (usrstake == 0) ? "New" : "Retopup";
        emit Stake(msg.sender, amount, dsctotrans, "USDT", stakeType, plan );
        users[_msgSender()].lastinvest = amount;
        users[_msgSender()].totalStake += amount;
        uint refStake = users[_msgSender()].totalStake;
        if(refStake == 0){
        users[ref].partnerCount++;
        }
        
    }

        function stakeDSC(uint amount, uint plan, address _referral) public {
        if(!isUserExists(_msgSender())){
        registration(_msgSender(),_referral,"DSC");
        }
        require(isUserExists(_msgSender()), "Dsclab: User not Exists!");
        require(amount >= minStake, "Minimum Activation is $60");
        require(amount <= maxStake, "Maximum Activation is $10000");
        require(plan == 1, "In Fix plan only USDT investment is allowed");
        uint lastinvst = users[_msgSender()].lastinvest;
        if(lastinvst > 0){
        require(amount >= lastinvst, "Re Investment Should Equal/Greater than last Investment");    
        }
        address[] memory path = new address[](2); // Initialize the array with size 2
        path[0] = USDT;
        path[1] = DSC;
        uint rate = getCurrentPrice(path);
        uint dsctotrans = (amount * rate)/1e18;
        require(
            IERC20(DSC).allowance(_msgSender(), address(this)) >= dsctotrans,
            "DSClab: allowance "
        );
      
      IERC20(DSC).transferFrom(_msgSender(), address(this), dsctotrans);
        // TODO: Swap 10 USDT to DSC  using RouterV2 or RouterV3
        address ref = users[_msgSender()].referrer;
        uint usrstake = users[_msgSender()].totalStake;
        string memory stakeType = (usrstake == 0) ? "New" : "Retopup";
        emit Stake(msg.sender, amount, dsctotrans, "DSC", stakeType, plan);
        users[_msgSender()].lastinvest = amount;
        users[_msgSender()].totalStake += amount;
        uint refStake = users[_msgSender()].totalStake;
        if(refStake == 0){
        users[ref].partnerCount++;
        }
        
    }

        function stakestDSC(uint amount, uint plan, address _referral) public {
         if(!isUserExists(_msgSender())){
        registration(_msgSender(),_referral,"stDSC");
        }
        require(isUserExists(_msgSender()), "Dsclab: User not Exists!");
        require(amount >= minStake, "Minimum Activation is $60");
        require(amount <= maxStake, "Maximum Activation is $10000");
        require(plan == 1, "In Fix plan only USDT investment is allowed");
        uint lastinvst = users[_msgSender()].lastinvest;
        if(lastinvst > 0){
        require(amount >= lastinvst, "Re Investment Should Equal/Greater than last Investment");    
        }

        uint price = 11200000000000000;

        uint256 DSCCMQty=(amount*1e18)/price; 
      
        IERC20(stDSC).transferFrom(_msgSender(), address(this), DSCCMQty);
        IERC20(stDSC).burn(DSCCMQty);
        
        address ref = users[_msgSender()].referrer;
        uint usrstake = users[_msgSender()].totalStake;
        string memory stakeType = (usrstake == 0) ? "New" : "Retopup";
        emit Stake(msg.sender, amount, DSCCMQty, "stDSC", stakeType, plan);
        users[_msgSender()].lastinvest = amount;
        users[_msgSender()].totalStake += amount;
        uint refStake = users[_msgSender()].totalStake;
        if(refStake == 0){
        users[ref].partnerCount++;
        }
        
    }

    function sendLevelIncome(address user, uint256 amount) internal {
        address referral = users[user].referrer;

        for (uint i = 1; i <= 25; i++) {
            if (referral != address(0)) {
                User storage refUser = users[referral];
                if (!refUser.onof) {
                    uint levelIncome = 0;

                    if (refUser.partnersCount >= i && i <= 3) {
                        levelIncome = (amount * levelShare[i]) / PERCENT_DIVIDER;
                    } else if (refUser.partnersCount > 7 && i > 5 && i <= 10) {
                        levelIncome = (amount * 300) / PERCENT_DIVIDER;
                    } else if (refUser.partnersCount > 11 && i > 10 && i <= 15) {
                        levelIncome = (amount * 250) / PERCENT_DIVIDER;
                    } else if (refUser.partnersCount > 14 && i > 15 && i <= 20) {
                        levelIncome = (amount * 200) / PERCENT_DIVIDER;
                    } else if (refUser.partnersCount > 17 && i > 20 && i <= 25) {
                        levelIncome = (amount * 100) / PERCENT_DIVIDER;
                    }

                    uint rewcum = refUser.rewTaken + levelIncome;
                    
                        IERC20(USDT).transfer(referral, levelIncome);
                        refUser.levelIncome += levelIncome;
                        refUser.rewTaken += levelIncome;
                       // emit LevelIncome(referral, user, i, levelIncome);
                   
                }
                referral = refUser.referrer;
            }
        }
    }

      function getCurrentPrice(address[] memory path)
        public
        view
        returns (uint256)
    {
        uint256 amountIn = 1 ether; // Adjust as needed
        uint256[] memory amountsOut = IUniswapV2Router01(uniswapRouter)
            .getAmountsOut(amountIn, path);
        return amountsOut[amountsOut.length - 1];
    }

    function isUserExists(address user) public view returns (bool) {
        return (users[user].userId != 0);
    }

    function getPriceFromUniswapV2(uint256 amountUsd)
        public
        view
        returns (uint256)
    {
        address[] memory paths = new address[](2);
        paths[0] = USDT;
        paths[1] = DSC;
        uint256[] memory amounts = uniswapRouter.getAmountsOut(
            amountUsd,
            paths
        );
        return amounts[1];
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
 
}