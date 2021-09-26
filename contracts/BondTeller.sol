// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.6;

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }

    function sqrrt(uint256 a) internal pure returns (uint c) {
        if (a > 3) {
            c = a;
            uint b = add( div( a, 2), 1 );
            while (b < c) {
                c = b;
                b = div( add( div( a, b ), b), 2 );
            }
        } else if (a != 0) {
            c = 1;
        }
    }
}

library Address {

    function isContract(address account) internal view returns (bool) {

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }

    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {
            if (returndata.length > 0) {

                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }

    function addressToString(address _address) internal pure returns(string memory) {
        bytes32 _bytes = bytes32(uint256(_address));
        bytes memory HEX = "0123456789abcdef";
        bytes memory _addr = new bytes(42);

        _addr[0] = '0';
        _addr[1] = 'x';

        for(uint256 i = 0; i < 20; i++) {
            _addr[2+i*2] = HEX[uint8(_bytes[i + 12] >> 4)];
            _addr[3+i*2] = HEX[uint8(_bytes[i + 12] & 0x0f)];
        }

        return string(_addr);

    }
}

interface IERC20 {
    function decimals() external view returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(IERC20 token, address spender, uint256 value) internal {

        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function _callOptionalReturn(IERC20 token, bytes memory data) private {

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

library FullMath {
    function fullMul(uint256 x, uint256 y) private pure returns (uint256 l, uint256 h) {
        uint256 mm = mulmod(x, y, uint256(-1));
        l = x * y;
        h = mm - l;
        if (mm < l) h -= 1;
    }

    function fullDiv(
        uint256 l,
        uint256 h,
        uint256 d
    ) private pure returns (uint256) {
        uint256 pow2 = d & -d;
        d /= pow2;
        l /= pow2;
        l += h * ((-pow2) / pow2 + 1);
        uint256 r = 1;
        r *= 2 - d * r;
        r *= 2 - d * r;
        r *= 2 - d * r;
        r *= 2 - d * r;
        r *= 2 - d * r;
        r *= 2 - d * r;
        r *= 2 - d * r;
        r *= 2 - d * r;
        return l * r;
    }

    function mulDiv(
        uint256 x,
        uint256 y,
        uint256 d
    ) internal pure returns (uint256) {
        (uint256 l, uint256 h) = fullMul(x, y);
        uint256 mm = mulmod(x, y, d);
        if (mm > l) h -= 1;
        l -= mm;
        require(h < d, 'FullMath::mulDiv: overflow');
        return fullDiv(l, h, d);
    }
}

interface IStaking {
    function stake( uint _amount, address _recipient ) external returns ( bool );
}

contract BondTeller {

    /* ========== DEPENDENCIES ========== */

    using SafeMath for uint;
    using SafeERC20 for IERC20;



    /* ========== EVENTS ========== */

    event BondCreated( address indexed bonder, uint payout, uint expires );
    event Redeemed( address indexed bonder, uint payout );



    /* ========== MODIFIERS ========== */

    modifier onlyDepository() {
        require( msg.sender == depository, "Only depository" );
        _;
    }



    /* ========== STRUCTS ========== */

    // Info for bond holder
    struct Bond {
        uint payout; // sOHM remaining to be paid. agnostic balance
        uint vested; // Block when vested
        bool redeemed;
    }



    /* ========== STATE VARIABLES ========== */

    address depository; // contract where users deposit bonds
    address immutable staking; // contract to stake payout
    IERC20 immutable OHM; 
    IERC20 immutable sOHM; // payment token
    ITreasury immutable treasury; 

    mapping( address => Bond[] ) public bonderInfo; // user data



    /* ========== CONSTRUCTOR ========== */

    constructor( address _depository, address _staking, address _OHM ) {
        require( _depository != address(0) );
        depository = _depository;
        require( _staking != address(0) );
        staking = _staking;
        require( _treasury != address(0) );
        treasury = ITreasury( _treasury );
        require( _OHM != address(0) );
        OHM = IERC20( _OHM );
        require( _sOHM != address(0) );
        sOHM = _sOHM;
    }



    /* ========== DEPOSITORY FUNCTIONS ========== */

    /**
     *  @notice add new bond payout to user data
     *  @param _bonder address
     *  @param _payout uint
     *  @param _end uint
     */
    function newBond( address _bonder, uint _payout, uint _vesting ) external onlyDepository() {
        treasury.mintRewards( address(this), _payout );

        OHM.approve( staking, _payout ); // approve staking payout

        // store bond & stake payout
        bonderInfo[ _bonder ].push( Bond({ 
            payout: IStaking( staking ).stake( _payout, address(this), true ),
            vested: block.number.add( _vesting ),
            redeemed: false
        } ) );

        // indexed events are emitted
        emit BondCreated( _bonder, _payout, newVesting );
    }

    /* ========== INTERACTABLE FUNCTIONS ========== */

    /**
     *  @notice redeems all redeemable bonds
     *  @param _bonder address
     *  @return uint
     */
    function redeemAll( address _bonder ) external returns ( uint ) {
        return redeem( _bonder, indexesFor( _bonder ) );
    }

    /** 
     *  @notice redeem bond for user
     *  @param _bonder address
     *  @param _indexes uint[]
     *  @return uint
     */ 
    function redeem( address _bonder, uint[] calldata indexes ) public returns ( uint ) {
        uint dues;
        for( uint i = 0; i < _indexes.length; i++ ) {
            uint index = _indexes[ i ];
            Bond memory info = bonderInfo[ _bonder ][ index ];

            if ( !info.redeemed && percentVestedFor( _bonder, index ) >= 10000 ) {
                bonderInfo[ _bonder ][ index ].redeemed = true; // mark as redeemed
                dues = dues.add( info.payout );
            }
        }

        dues = IStaking( staking ).fromAgnosticAmount( dues );

        emit Redeemed( _bonder, dues );
        pay( _bonder, dues );
        return dues;
    }



    /* ========== INTERNAL FUNCTIONS ========== */

    /**
     *  @notice send payout
     *  @param _amount uint
     *  @return uint
     */
    function pay( address _bonder, uint _amount ) internal {
        sOHM.transfer( _bonder, _amount );
    }



    /* ========== VIEW FUNCTIONS ========== */

    /**
     *  @notice returns indexes of live bonds
     *  @param _bonder address
     *  @return indexes_ uint
     */
    function indexesFor( address _bonder ) public view returns ( uint[] indexes_ ) {
        Bond[] memory info = bonderInfo[ _bonder ];
        for( uint i = 0; i < info.length; i++ ) {
            if( !info[ i ].redeemed ) {
                indexes_.push( i );
            }
        }
    }

    // PAYOUT
    
    /**
     *  @notice calculate amount of OHM available for claim by depositor
     *  @param _depositor address
     *  @return pendingPayout_ uint
     */
    function pendingFor( address _bonder, uint[] calldata _indexes ) external view returns ( uint pendingPayout_ ) {
        for( uint i = 0; i < _indexes.length; i++ ) {
            uint index = _indexes[ i ];
            uint payout = bonderInfo[ _bonder ][ index ].payout;

            if ( percentVestedFor( _bonder, index ) >= 10000 ) {
                pendingPayout_ = pendingPayout_.add( payout );
            }
        }
        
        pendingPayout_ = IStaking( staking ).fromAgnosticAmount( pendingPayout_ );
    }

    /**
     *  @notice pending on all bonds
     *  @param _bonder address
     *  @return uint
     */
    function totalPendingFor( address _bonder ) external view returns ( uint ) {
        return pendingPayoutFor( _bonder, indexesFor( _bonder ) );
    }

    /**
     *  @notice pending payout for each outstanding bond
     *  @param _bonder address
     *  @return pending_ uint[]
     */
    function allPendingFor( address _bonder ) external view returns ( uint[] pending_ ) {
        uint[] memory indexes = indexesFor( _bonder );

        for( uint i = 0; i < indexes.length; i++ ) {
            pending_.push( pendingFor( _bonder, indexes[i] ) );
        }
    }

    // VESTING

    /**
     *  @notice calculate how far into vesting a depositor is
     *  @param _depositor address
     *  @return percentVested_ uint
     */
    function percentVestedFor( address _bonder, uint _index ) public view returns ( uint percentVested_ ) {
        Bond memory bond = bonderInfo[ _bonder ][ _index ];

        uint blocksRemaining = bond.vested.sub( bond.lastInteraction );
        uint blocksSince = block.number.sub( bond.lastInteraction );

        percentVested_ = blocksSince.mul( 10000 ).div( blocksRemaining );
    }

    /**
     *  @notice vested percent for each outstanding bond
     *  @param _bonder address
     *  @return percents_ uint[]
     */
    function allPercentVestedFor( address _bonder ) external view returns ( uint[] percents_ ) {
        uint[] memory indexes = indexesFor( _bonder );

        for( uint i = 0; i < indexes.length; i++ ) {
            percents_.push( percentVestedFor( _bonder, indexes[i] ) );
        }
    }
}