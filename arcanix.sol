/**
 *Submitted for verification at opbnb-testnet.bscscan.com on 2025-08-11
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Initializable {
    bool private _initialized;

    bool private _initializing;

    modifier initializer() {
        require(
            _initializing || !_initialized,
            "Initializable: contract is already initialized"
        );

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

// Full ERC20 Interface
interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract ArcanixICO is Initializable {
    address public owner;
    uint256 public constant RATE = 2; // 2 tokens per 1 USDT
    IERC20 public usdtToken;
    IERC20 public realToken;
    uint public lastUserId;
    uint ETHER;
    uint LEVEL;

    struct Details {
        uint256 usdtAmount;
        uint256 plan;
        uint256 timestamp;
        uint256 roiPercent; 
        uint256 claimedROI;
        bool stakestatus; 
    }

    struct DetailsICO {
        uint256 usdt;
        uint256 arx;
        uint256 timestamp;
    }

    struct Purchase {
        uint256 id;
        address invst_ref;
        address ico_ref;
        uint256 partnerCount;
        uint256 usdtSpentico;
        uint256 usdtSpentinvst;
        uint256 tokensReceived;
        uint256 totalROIClaimed;
        uint256 targetROI;
        uint256 lastClaimedAt;  
        bool distributed;
        uint256 refToken;
        uint256 teambusiness;
        mapping(uint256 => Details[]) _detail;
        DetailsICO[] _detailarx;
    }

    mapping(address => Purchase) public purchases;
    mapping(uint => address) public idToAddress;

    event TokensPurchased(address indexed buyer, uint256 usdtAmount, uint256 virtualTokens);
    event Investment(address indexed buyer, uint256 usdtAmount, uint8 plan);
    event RealTokensDistributed(address indexed user, uint256 amount);
    event Registrationico(
        address indexed user,
        address indexed referrer,
        uint id,
        uint referrerId
    );
    event Registrationinvst(
        address indexed user,
        address indexed referrer,
        uint id,
        uint referrerId
    );
    
    event ReferralIncome(address indexed sender, address indexed receiver, uint256 tokens);
    event DailyROIClaimed(address indexed user, uint256 amount);
    event LevelIncome(address indexed sender , address indexed receiver, uint8 level, uint levelIncome);


    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    function initialize(address _usdtAddress) public initializer {
        require(_usdtAddress != address(0), "Invalid USDT address");
        owner = msg.sender;
        usdtToken = IERC20(_usdtAddress);
        lastUserId = 1;
        purchases[msg.sender].id = lastUserId;
        lastUserId++;

        ETHER = 10 ** 18;
        LEVEL = 100;
    }

    function registration(
        address userAddress,
        address referrerAddress
    ) internal {
        require(!isUserExists(userAddress), "user exists");
        require(isUserExists(referrerAddress), "referrer not exists");
        purchases[userAddress].id = lastUserId;
        purchases[userAddress].ico_ref = referrerAddress;
        idToAddress[lastUserId] = userAddress;
        lastUserId++;
        //purchases[purchases[userAddress].referrer].partnerCount++;
        
        emit Registrationico(
            userAddress,
            referrerAddress,
            purchases[userAddress].id,
            purchases[referrerAddress].id
        );

    }

    function registrationinvst(
        address userAddress,
        address referrerAddress
    ) internal {
        require(isUserExists(referrerAddress), "referrer not exists");
        require(purchases[userAddress].invst_ref == address(0), "Referral Already Set");
        purchases[userAddress].invst_ref = referrerAddress;
        purchases[purchases[userAddress].invst_ref].partnerCount++;
        
        emit Registrationinvst(
            userAddress,
            referrerAddress,
            purchases[userAddress].id,
            purchases[referrerAddress].id
        );

    }

    function registrationEx(address _referrer) external {
        registration(msg.sender, _referrer);
    }

     function registrationExInvst(address _referrer) external {
        registrationinvst(msg.sender, _referrer);
    }

    function arxinvest(uint256 usdtAmount, uint8 plan) external {
        require(isUserExistsInvst(msg.sender), "User not registered");
        //require(purchases[msg.sender].invst_ref != address(0), "Investor referrer not set");
        require(plan > 0 && plan < 6, "Invalid Investment Plan");
        uint256 roiPercent;
        if(plan == 1){
            if(usdtAmount < 50 * ETHER){
            revert("Invalid investment range");
            } else if(usdtAmount > 500 * ETHER && usdtAmount < 600 * ETHER){
            revert("Invalid investment range");
            } else if(usdtAmount > 3000 * ETHER && usdtAmount < 3500 * ETHER){
            revert("Invalid investment range");
            } else if(usdtAmount > 9900 * ETHER && usdtAmount < 10000 * ETHER){
            revert("Invalid investment range");
            } else if (usdtAmount >= 50 * ETHER && usdtAmount <= 500 * ETHER) roiPercent = 60;     // 0.5%
        else if (usdtAmount >= 600 * ETHER && usdtAmount <= 3000 * ETHER) roiPercent = 70;  // 0.6%
        else if (usdtAmount >= 3500 * ETHER && usdtAmount <= 9900 * ETHER) roiPercent = 90; // 0.7%
        else if (usdtAmount >= 10000 * ETHER) roiPercent = 100;
        } else if(plan == 2){
            if(usdtAmount < 100 * ETHER){
            revert("Invalid investment range");
            } else if(usdtAmount > 100000 * ETHER){
            revert("Invalid investment range");
            } else if(usdtAmount >= 100 * ETHER && usdtAmount <= 100000 * ETHER){
             roiPercent = 50;
            }
        } else if(plan == 3){
            if(usdtAmount < 1 * ETHER){
            revert("Invalid investment range");
            } else if(usdtAmount >= 1 * ETHER){
             roiPercent = 30;
            }
        } else if(plan == 4){
            if(usdtAmount < 1 * ETHER){
            revert("Invalid investment range");
            } else if(usdtAmount >= 1 * ETHER){
             roiPercent = 30;
            }
        } else if(plan == 5){
            if(usdtAmount < 1 * ETHER){
            revert("Invalid investment range");
            } else if(usdtAmount >= 1 * ETHER){
             roiPercent = 35;
            }
        }
        require(usdtToken.transferFrom(msg.sender, address(this), usdtAmount), "USDT transfer failed");


        Purchase storage p = purchases[msg.sender];
        p.usdtSpentinvst += usdtAmount;
        p.targetROI += usdtAmount * 2; // 2x ROI
        p.lastClaimedAt = block.timestamp;

        p._detail[plan].push(
        Details(usdtAmount, plan, block.timestamp, roiPercent, 0, true)
        );

        emit Investment(msg.sender, usdtAmount, plan);

        _updateTeamBusiness(usdtAmount, msg.sender);

        _sendLevelIncome(usdtAmount, msg.sender);
    }

    function _updateTeamBusiness(uint256 amount, address user) internal {
        address upline = purchases[user].invst_ref;

        for (uint8 i = 0; i < LEVEL; i++) {
            if (upline == address(0)) {
                break;
            }

            purchases[upline].teambusiness += amount;

            // Move to next upline
            upline = purchases[upline].invst_ref;
        }
    }

            function _sendLevelIncome(uint256 amount, address fromUser) internal {
            address upline = purchases[fromUser].invst_ref;

            for (uint8 level = 1; level <= 30; level++) {
                if (upline == address(0)) break;

                uint256 percentage = _getLevelPercentage(level, upline);
                uint256 income = (amount * percentage) / 100;

                if (income > 0) {
                    usdtToken.transfer(upline,income);

                    emit LevelIncome(fromUser, upline, level, income);
                }

                upline = purchases[upline].invst_ref;
            }
        }

        function _getLevelPercentage(uint8 level, address upline) internal view returns (uint256) {
            uint256 direct = purchases[upline].partnerCount;
            uint256 teamBiz = purchases[upline].teambusiness;

            // Special boosted conditions
            if (direct >= 4) {
                if (level == 1 && teamBiz >= 1600) return 25;
                if (level == 2 && teamBiz >= 5000) return 20;
                if (level == 3 && teamBiz >= 10000) return 20;
            }

            // Base logic
            if (level == 1) return 12;
            if (level >= 2 && level <= 4) return 10;
            if (level >= 5 && level <= 6) return 5;
            if (level >= 7 && level <= 12) return 3;
            if (level >= 13 && level <= 20) return 2;
            if (level >= 21 && level <= 25) return 1;
            if (level >= 26 && level <= 30) return 4;

            return 0;
        }

    function buyTokens(uint256 usdtAmount) external {
        
        require(isUserExists(msg.sender), "User not registered");
       
        require(usdtAmount > 0, "Amount must be > 0");

        require(usdtToken.transferFrom(msg.sender, address(this), usdtAmount), "USDT transfer failed");

        uint256 tokenAmount = usdtAmount * RATE;

        purchases[msg.sender].usdtSpentico += usdtAmount;
        purchases[msg.sender].tokensReceived += tokenAmount;

        purchases[purchases[msg.sender].ico_ref].tokensReceived += (tokenAmount*5) / 100;
        purchases[purchases[msg.sender].ico_ref].refToken += (tokenAmount*5) / 100;
        emit ReferralIncome(msg.sender,purchases[msg.sender].ico_ref,(tokenAmount*5) / 100);

        purchases[msg.sender]._detailarx.push(DetailsICO(usdtAmount, tokenAmount, block.timestamp));

        emit TokensPurchased(msg.sender, usdtAmount, tokenAmount);
    }
                                  
        function claimDailyROI() external {
            Purchase storage p = purchases[msg.sender];
            require(p.usdtSpentinvst > 0, "No investment");

            uint256 totalClaim = 0;
           
            
            for (uint8 j = 1; j <= 5; j++) {
                 Details[] storage details = p._detail[j];
            for (uint256 i = 0; i < details.length; i++) {
                Details storage d = details[i];
                
                if (!d.stakestatus) {
                    continue;
                }

                // For testing, claim every 10 minutes
                uint256 minutesPassed = (block.timestamp - d.timestamp) / 1 days;
                uint256 dailyROI = (d.usdtAmount * d.roiPercent) / 10000; // e.g., 50 = 0.5%
                uint256 totalEligible = dailyROI * minutesPassed;

                // Allow unlimited ROI, just accumulate
                if (totalEligible > d.claimedROI) {
                    uint256 actualClaim = totalEligible - d.claimedROI;
                    d.claimedROI += actualClaim;
                    d.timestamp = block.timestamp;
                    totalClaim += actualClaim;
                }
            }
            }
            require(totalClaim >= 100 * ETHER, "Minimum 100 USDT required to claim");
            uint256 amountAfterDeduction = (totalClaim * 96) / 100;
            require(usdtToken.transfer(msg.sender, amountAfterDeduction), "Transfer failed");

            p.totalROIClaimed += totalClaim;
            p.lastClaimedAt = block.timestamp;
            

            emit DailyROIClaimed(msg.sender, totalClaim);
        }

        function claimDailyROI2(uint256 plan) external {
            require(plan == 3, "Invalid Claim Plan");
            Purchase storage p = purchases[msg.sender];
            require(p.usdtSpentinvst > 0, "No investment");

            uint256 totalClaim = 0;
            Details[] storage details = p._detail[plan];

            for (uint256 i = 0; i < details.length; i++) {
                Details storage d = details[i];
                
                if (!d.stakestatus) {
                    continue;
                }
                // For testing, claim every 10 minutes
                uint256 minutesPassed = (block.timestamp - d.timestamp) / 1 days;

                uint256 dailyROI = (d.usdtAmount * d.roiPercent) / 10000; // e.g., 50 = 0.5%
                uint256 totalEligible = dailyROI * minutesPassed;

                // Allow unlimited ROI, just accumulate
                if (totalEligible > d.claimedROI) {
                    uint256 actualClaim = totalEligible - d.claimedROI;
                    d.claimedROI += actualClaim;
                    totalClaim += actualClaim;
                }
            }

            require(usdtToken.transfer(msg.sender, totalClaim), "Transfer failed");

            p.totalROIClaimed += totalClaim;
            p.lastClaimedAt = block.timestamp;

            emit DailyROIClaimed(msg.sender, totalClaim);
        }

        function claimDailyROI3(uint256 plan) external {
            require(plan == 4 || plan == 5, "Invalid Claim Plan");
            Purchase storage p = purchases[msg.sender];
            require(p.usdtSpentinvst > 0, "No investment");

            uint256 totalClaim = 0;
            Details[] storage details = p._detail[plan];

            for (uint256 i = 0; i < details.length; i++) {
                Details storage d = details[i];
                
                if (!d.stakestatus) {
                    continue;
                }
                // For testing, claim every 10 minutes
                uint256 minutesPassed = (block.timestamp - d.timestamp) / 1 days;

                uint256 dailyROI = (d.usdtAmount * d.roiPercent) / 10000; // e.g., 50 = 0.5%
                uint256 totalEligible = dailyROI * minutesPassed;

                // Allow unlimited ROI, just accumulate
                if (totalEligible > d.claimedROI) {
                    uint256 actualClaim = totalEligible - d.claimedROI;
                    d.claimedROI += actualClaim;
                    totalClaim += actualClaim;
                }
            }

            require(usdtToken.transfer(msg.sender, totalClaim), "Transfer failed");

            p.totalROIClaimed += totalClaim;
            p.lastClaimedAt = block.timestamp;

            emit DailyROIClaimed(msg.sender, totalClaim);
        }

        function getROIBreakdown(address user, uint plan) external view returns (
            uint256[] memory usdtAmounts,
            uint256[] memory claimedROIs,
            uint256[] memory claimableROIs,
            uint256[] memory timestamps,
            uint256[] memory roiPercents
        ) {
            Purchase storage p = purchases[user];
            uint256 len = p._detail[plan].length;

            usdtAmounts = new uint256[](len);
            claimedROIs = new uint256[](len);
            claimableROIs = new uint256[](len);
            timestamps = new uint256[](len);
            roiPercents = new uint256[](len);

            for (uint i = 0; i < len; i++) {
                Details storage d = p._detail[plan][i];

                usdtAmounts[i] = d.usdtAmount;
                claimedROIs[i] = d.claimedROI;
                timestamps[i] = d.timestamp;
                roiPercents[i] = d.roiPercent;

                 if (!d.stakestatus) {
                    claimableROIs[i] = 0;
                    continue;
                }

                // Calculate claimable ROI (10-minute intervals)
                uint256 minutesPassed = (block.timestamp - d.timestamp) / 1 days;

                uint256 dailyROI = (d.usdtAmount * d.roiPercent) / 10000;
                uint256 totalEligible = dailyROI * minutesPassed;

                // Unlimited ROI – just subtract already claimed ROI
                uint256 claimable = totalEligible > d.claimedROI
                    ? totalEligible - d.claimedROI
                    : 0;

                claimableROIs[i] = claimable;
            }
        }

        function getCurrentClaimableROI(address _user) external view returns (uint256) {
                Purchase storage p = purchases[_user];
                if (p.usdtSpentinvst == 0) {
                    return 0;
                }

                uint256 totalClaim = 0;

                for (uint8 j = 1; j <= 5; j++) {
                    for (uint i = 0; i < p._detail[j].length; i++) {
                        Details storage d = p._detail[j][i];

                        if (!d.stakestatus) {
                            continue;
                        }

                        uint256 minutesPassed = (block.timestamp - d.timestamp) / 1 days;

                        // Calculate how much ROI should be available
                        uint256 dailyROI = (d.usdtAmount * d.roiPercent) / 10000;
                        uint256 totalEligible = dailyROI * minutesPassed;

                        // Remove maxROI cap – just subtract what has already been claimed
                        uint256 actualClaim = totalEligible > d.claimedROI
                            ? totalEligible - d.claimedROI
                            : 0;

                        if (actualClaim > 0) {
                            totalClaim += actualClaim;
                        }
                    }
                }

                return totalClaim;
        }

    function claimCapital(uint8 plan, uint investId) external {
        require(plan == 3 || plan == 4 || plan == 5, "You cannot withdraw capital amount");

        Purchase storage p = purchases[msg.sender];
        Details storage d = p._detail[plan][investId];

        // Time restriction for plan 4 and 5
        if (plan == 4) {
            require(block.timestamp >= d.timestamp + 365 days, "Plan 4: Lock period is 12 months");
        }
        if (plan == 5) {
            require(block.timestamp >= d.timestamp + 730 days, "Plan 5: Lock period is 24 months");
        }
        d.stakestatus = false;
        uint256 minutesPassed = (block.timestamp - d.timestamp) / 1 days;
        uint256 totalClaim = 0;

        // Calculate how much ROI should be available
        uint256 dailyROI = (d.usdtAmount * d.roiPercent) / 10000;
        uint256 totalEligible = dailyROI * minutesPassed;

        // Unlimited ROI – subtract already claimed
        uint256 actualClaim = totalEligible > d.claimedROI
            ? totalEligible - d.claimedROI
            : 0;

        if (actualClaim > 0) {
            totalClaim += actualClaim;
            d.claimedROI += actualClaim;
            p.totalROIClaimed += actualClaim;
        }

        usdtToken.transfer(msg.sender, (totalClaim + d.usdtAmount));
    }

    function getPurchase(address user) external view returns (uint256 usdtSpent, uint256 tokensReceived, bool distributed) {
        Purchase storage p = purchases[user];
        return (p.usdtSpentinvst, p.tokensReceived, p.distributed);
    }

    function withdrawUSDT() external onlyOwner {
        uint256 balance = usdtToken.balanceOf(address(this));
        require(balance > 0, "Nothing to withdraw");
        require(usdtToken.transfer(owner, balance), "Withdraw failed");
    }

    /// @notice Set the real token address (only once)
    function setRealToken(address _realToken) external onlyOwner {
        require(address(realToken) == address(0), "Already set");
        require(_realToken != address(0), "Invalid address");
        realToken = IERC20(_realToken);
    }

    /// @notice Distribute real tokens to a specific user
    function adminDistributeRealTokens(address user) external onlyOwner {
        Purchase storage p = purchases[user];
        require(!p.distributed, "Already distributed");
        require(p.tokensReceived > 0, "No tokens to distribute");
        require(address(realToken) != address(0), "Real token not set");

        p.distributed = true;
        require(realToken.transfer(user, p.tokensReceived), "Real token transfer failed");

        emit RealTokensDistributed(user, p.tokensReceived);
    }

    /// @notice Batch distribute real tokens to multiple users
    function batchDistribute(address[] calldata users) external onlyOwner {
        require(address(realToken) != address(0), "Real token not set");

        for (uint256 i = 0; i < users.length; i++) {
            address user = users[i];
            Purchase storage p = purchases[user];
            if (!p.distributed && p.tokensReceived > 0) {
                p.distributed = true;
                require(realToken.transfer(user, p.tokensReceived), "Transfer failed");
                emit RealTokensDistributed(user, p.tokensReceived);
            }
        }
    }

    function isUserExists(address _user) public view returns (bool) {
        return purchases[_user].id != 0;
    }

    function isUserExistsInvst(address _user) public view returns (bool) {
        if(purchases[_user].invst_ref != address(0)){
            return true;
        } else if(_user == owner){
            return true;
        }
        return false;
    }

    function seeHistroyInvst(address useradd, uint plan) external view returns (Details[] memory) {
        return purchases[useradd]._detail[plan];
    }

    function seeHistroyArx(address useradd) external view returns (DetailsICO[] memory) {
        return purchases[useradd]._detailarx;
    }
}