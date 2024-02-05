// SPDX-License-Identifier: MIT
pragma solidity =0.8.4;
pragma experimental ABIEncoderV2;

library AddressUpgradeable {
    function isContract(address account) internal view returns (bool) {
        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{value: amount}("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
    }

    function functionCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return
            functionCallWithValue(
                target,
                data,
                value,
                "Address: low-level call with value failed"
            );
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(
            address(this).balance >= value,
            "Address: insufficient balance for call"
        );
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{value: value}(
            data
        );
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function functionStaticCall(address target, bytes memory data)
        internal
        view
        returns (bytes memory)
    {
        return
            functionStaticCall(
                target,
                data,
                "Address: low-level static call failed"
            );
    }

    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) private pure returns (bytes memory) {
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
}

interface IERC20Upgradeable {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

abstract contract Initializable {
    /**
     * @dev Indicates that the contract has been initialized.
     */
    bool private _initialized;

    /**
     * @dev Indicates that the contract is in the process of being initialized.
     */
    bool private _initializing;

    modifier initializer() {
        require(
            _initializing || _isConstructor() || !_initialized,
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

    /// @dev Returns true if and only if the function is running in the constructor
    function _isConstructor() private view returns (bool) {
        return !AddressUpgradeable.isContract(address(this));
    }
}

abstract contract ContextUpgradeable is Initializable {
    function __Context_init() internal initializer {
        __Context_init_unchained();
    }

    function __Context_init_unchained() internal initializer {}

    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }

    uint256[50] private __gap;
}

abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    function __Ownable_init() internal initializer {
        __Context_init_unchained();
        __Ownable_init_unchained();
    }

    function __Ownable_init_unchained() internal initializer {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    uint256[49] private __gap;
}

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryDiv}.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a % b;
    }
}

library EnumerableSet {
    struct Set {
        // Storage of set values
        bytes32[] _values;
        // Position of the value in the `values` array, plus 1 because index 0
        // means a value is not in the set.
        mapping(bytes32 => uint256) _indexes;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
            // The value is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function _remove(Set storage set, bytes32 value) private returns (bool) {
        // We read and store the value's index to prevent multiple reads from the same storage slot
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) {
            // Equivalent to contains(set, value)
            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
            // the array, and then remove the last element (sometimes called as 'swap and pop').
            // This modifies the order of the array, as noted in {at}.

            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

            // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
            // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.

            bytes32 lastvalue = set._values[lastIndex];

            // Move the last value to the index where the value to delete is
            set._values[toDeleteIndex] = lastvalue;
            // Update the index for the moved value
            set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based

            // Delete the slot where the moved value was stored
            set._values.pop();

            // Delete the index for the deleted slot
            delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function _contains(Set storage set, bytes32 value)
        private
        view
        returns (bool)
    {
        return set._indexes[value] != 0;
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function _at(Set storage set, uint256 index)
        private
        view
        returns (bytes32)
    {
        require(
            set._values.length > index,
            "EnumerableSet: index out of bounds"
        );
        return set._values[index];
    }

    // Bytes32Set

    struct Bytes32Set {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(Bytes32Set storage set, bytes32 value)
        internal
        returns (bool)
    {
        return _add(set._inner, value);
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(Bytes32Set storage set, bytes32 value)
        internal
        returns (bool)
    {
        return _remove(set._inner, value);
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(Bytes32Set storage set, bytes32 value)
        internal
        view
        returns (bool)
    {
        return _contains(set._inner, value);
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(Bytes32Set storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(Bytes32Set storage set, uint256 index)
        internal
        view
        returns (bytes32)
    {
        return _at(set._inner, index);
    }

    // AddressSet

    struct AddressSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(AddressSet storage set, address value)
        internal
        returns (bool)
    {
        return _add(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(AddressSet storage set, address value)
        internal
        returns (bool)
    {
        return _remove(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(AddressSet storage set, address value)
        internal
        view
        returns (bool)
    {
        return _contains(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(AddressSet storage set, uint256 index)
        internal
        view
        returns (address)
    {
        return address(uint160(uint256(_at(set._inner, index))));
    }

    // UintSet

    struct UintSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(UintSet storage set, uint256 value)
        internal
        returns (bool)
    {
        return _remove(set._inner, bytes32(value));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(UintSet storage set, uint256 value)
        internal
        view
        returns (bool)
    {
        return _contains(set._inner, bytes32(value));
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(UintSet storage set, uint256 index)
        internal
        view
        returns (uint256)
    {
        return uint256(_at(set._inner, index));
    }
}

interface IERC20PermitUpgradeable {
    /**
     * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
     * given ``owner``'s signed approval.
     *
     * IMPORTANT: The same issues {IERC20-approve} has related to transaction
     * ordering also apply here.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `deadline` must be a timestamp in the future.
     * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
     * over the EIP712-formatted function arguments.
     * - the signature must use ``owner``'s current nonce (see {nonces}).
     *
     * For more information on the signature format, see the
     * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
     * section].
     */
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    /**
     * @dev Returns the current nonce for `owner`. This value must be
     * included whenever a signature is generated for {permit}.
     *
     * Every successful call to {permit} increases ``owner``'s nonce by one. This
     * prevents a signature from being used multiple times.
     */
    function nonces(address owner) external view returns (uint256);

    /**
     * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
     */
    // solhint-disable-next-line func-name-mixedcase
    function DOMAIN_SEPARATOR() external view returns (bytes32);
}

library SafeERC20Upgradeable {
    using AddressUpgradeable for address;

    function safeTransfer(
        IERC20Upgradeable token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transfer.selector, to, value)
        );
    }

    function safeTransferFrom(
        IERC20Upgradeable token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
        );
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(
        IERC20Upgradeable token,
        address spender,
        uint256 value
    ) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.approve.selector, spender, value)
        );
    }

    function safeIncreaseAllowance(
        IERC20Upgradeable token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender) + value;
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(
                token.approve.selector,
                spender,
                newAllowance
            )
        );
    }

    function safeDecreaseAllowance(
        IERC20Upgradeable token,
        address spender,
        uint256 value
    ) internal {
        unchecked {
            uint256 oldAllowance = token.allowance(address(this), spender);
            require(
                oldAllowance >= value,
                "SafeERC20: decreased allowance below zero"
            );
            uint256 newAllowance = oldAllowance - value;
            _callOptionalReturn(
                token,
                abi.encodeWithSelector(
                    token.approve.selector,
                    spender,
                    newAllowance
                )
            );
        }
    }

    function safePermit(
        IERC20PermitUpgradeable token,
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal {
        uint256 nonceBefore = token.nonces(owner);
        token.permit(owner, spender, value, deadline, v, r, s);
        uint256 nonceAfter = token.nonces(owner);
        require(
            nonceAfter == nonceBefore + 1,
            "SafeERC20: permit did not succeed"
        );
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20Upgradeable token, bytes memory data)
        private
    {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(
            data,
            "SafeERC20: low-level call failed"
        );
        if (returndata.length > 0) {
            // Return data is optional
            require(
                abi.decode(returndata, (bool)),
                "SafeERC20: ERC20 operation did not succeed"
            );
        }
    }
}

interface IPancakePair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

interface IPoolManager {
    function increaseTotalValueLocked(address currency, uint256 value) external;
    function decreaseTotalValueLocked(address currency, uint256 value) external;
    function removePoolForToken(address token, address pool) external;
    function recordContribution(address user, address pool) external;
    function isPoolGenerated(address pool) external view returns (bool);
    function addTopPool(address poolAddress, address currency, uint256 raisedAmount) external;
    function removeTopPool(address poolAddress) external;
    
    function registerPool(
        address pool,
        address token,
        address owner,
        uint8 version
    ) external;

    function poolForToken(address token) external view returns (address);

    event TvlChanged(address currency, uint256 totalLocked, uint256 totalRaised);
    event ContributionUpdated(uint256 totalParticipations);
    event PoolForTokenRemoved(address indexed token, address pool);
}

interface IPool {
    function getPoolInfo()
        external
        view
        returns (
            address,
            address,
            uint8[] memory,
            uint256[] memory,
            string memory,
            string memory,
            string memory
        );
}

interface IPoolFactory {
    function isCreatedByOwner(address _pool) external view returns(bool);
}

contract PoolManager is OwnableUpgradeable, IPoolManager {
    using EnumerableSet for EnumerableSet.AddressSet;
    using SafeMath for uint256;
    using SafeERC20Upgradeable for IERC20Upgradeable;

    struct CumulativeLockInfo {
        address poolAddress;
        address token;
        address currency;
        uint8 poolState;
        uint8 poolType;
        uint8 decimals;
        uint256 startTime;
        uint256 endTime;
        uint256 totalRaised;
        uint256 hardCap;
        uint256 softCap;
        uint256 minContribution;
        uint256 maxContribution;
        uint256 rate;
        uint256 liquidityListingRate;
        uint256 liquidityPercent;
        uint256 liquidityUnlockTime;
        string name;
        string symbol;
        string poolDetails;
    }

    struct TopPoolInfo {
        uint256 totalRaised;
        address poolAddress;
    }

    EnumerableSet.AddressSet private poolFactories;
    EnumerableSet.AddressSet private _pools;
    mapping(uint8 => EnumerableSet.AddressSet) private _poolsForVersion;
    mapping(address => EnumerableSet.AddressSet) private _poolsOf;
    mapping(address => EnumerableSet.AddressSet) private _contributedPoolsOf;
    mapping(address => address) private _poolForToken;
    TopPoolInfo[] private _topPools;

    address public WETH;
    IPancakePair public ethUSDTPool;
    mapping(address => uint256) public totalValueLocked;
    mapping(address => uint256) public totalLiquidityRaised;
    uint256 public totalParticipants;

    event sender(address sender);
    
    receive() external payable {}

    function initialize(address _WETH, address _ethUSDTPool) external initializer {
        WETH = _WETH;
        ethUSDTPool = IPancakePair(_ethUSDTPool);
        __Ownable_init();
    }

    modifier onlyAllowedFactory() {
        emit sender(msg.sender);
        require(
            poolFactories.contains(msg.sender),
            "Not a whitelisted factory"
        );
        _;
    }

    function getETHPrice() view public returns (uint256) {
        ( uint256 _reserve0 , uint256 _reserve1 , ) = ethUSDTPool.getReserves();
        if(ethUSDTPool.token0() == WETH)
            return _reserve1.mul(1e18).div(_reserve0);
        else 
            return _reserve0.mul(1e18).div(_reserve1);
    }

    function addPoolFactory(address factory) public onlyAllowedFactory {
        poolFactories.add(factory);
    }

    function addAdminPoolFactory(address factory) public onlyOwner {
        poolFactories.add(factory);
    }

    function addPoolFactories(address[] memory factories) external onlyOwner {
        for (uint256 i = 0; i < factories.length; i++) {
            addPoolFactory(factories[i]);
        }
    }

    function removePoolFactory(address factory) external onlyOwner {
        poolFactories.remove(factory);
    }

    function isPoolGenerated(address pool) public view override returns (bool) {
        return _pools.contains(pool);
    }

    function poolForToken(address token)
        external
        view
        override
        returns (address)
    {
        return _poolForToken[token];
    }

    function registerPool(
        address pool,
        address token,
        address owner,
        uint8 version
    ) external override onlyAllowedFactory {
        _pools.add(pool);
        _poolsForVersion[version].add(pool);
        _poolsOf[owner].add(pool);
        _poolForToken[token] = pool;
    }

    function increaseTotalValueLocked(address currency, uint256 value)
        external
        override
        onlyAllowedFactory
    {
        totalValueLocked[currency] = totalValueLocked[currency].add(value);
        totalLiquidityRaised[currency]  = totalLiquidityRaised[currency].add(value);
        emit TvlChanged(currency, totalValueLocked[currency], totalLiquidityRaised[currency]);
    }

    function decreaseTotalValueLocked(address currency, uint256 value)
        external
        override
        onlyAllowedFactory
    {
        if (totalValueLocked[currency] < value) {
            totalValueLocked[currency] = 0;
        } else {
            totalValueLocked[currency] = totalValueLocked[currency].sub(value);
        }
        emit TvlChanged(currency, totalValueLocked[currency], totalLiquidityRaised[currency]);
    }

    function recordContribution(address user, address pool)
        external
        override
        onlyAllowedFactory
    {
        totalParticipants = totalParticipants.add(1);
        _contributedPoolsOf[user].add(pool);
        emit ContributionUpdated(totalParticipants);
    }

    function removePoolForToken(address token, address pool)
        external
        override
        onlyAllowedFactory
    {
        _poolForToken[token] = address(0);
        emit PoolForTokenRemoved(token, pool);
    }

    function getPoolsOf(address owner) public view returns (address[] memory) {
        uint256 length = _poolsOf[owner].length();
        address[] memory allPools = new address[](length);
        for (uint256 i = 0; i < length; i++) {
            allPools[i] = _poolsOf[owner].at(i);
        }
        return allPools;
    }

    function getAllPools() public view returns (address[] memory) {
        uint256 length = _pools.length();
        address[] memory allPools = new address[](length);
        for (uint256 i = 0; i < length; i++) {
            allPools[i] = _pools.at(i);
        }
        return allPools;
    }

    function getPoolAt(uint256 index) public view returns (address) {
        return _pools.at(index);
    }

    function getTotalNumberOfPools() public view returns (uint256) {
        return _pools.length();
    }

    function getTotalNumberOfContributedPools(address user)
        public
        view
        returns (uint256)
    {
        return _contributedPoolsOf[user].length();
    }

    function getAllContributedPools(address user)
        public
        view
        returns (address[] memory)
    {
        uint256 length = _contributedPoolsOf[user].length();
        address[] memory allPools = new address[](length);
        for (uint256 i = 0; i < length; i++) {
            allPools[i] = _contributedPoolsOf[user].at(i);
        }
        return allPools;
    }

    function getContributedPoolAtIndex(address user, uint256 index)
        public
        view
        returns (address)
    {
        return _contributedPoolsOf[user].at(index);
    }

    function getTotalNumberOfPools(uint8 version)
        public
        view
        returns (uint256)
    {
        return _poolsForVersion[version].length();
    }

    function getPoolAt(uint8 version, uint256 index)
        public
        view
        returns (address)
    {
        return _poolsForVersion[version].at(index);
    }

    function getTopPool() public view returns (TopPoolInfo[] memory) {
        return _topPools;
    }

    function initializeTopPools() public onlyOwner {
        for(uint256 i = 0; i < 50; i++)
            _topPools.push(TopPoolInfo(0, address(0)));
    }

    function addTopPool(address poolAddress, address currency, uint256 raisedAmount) external override onlyAllowedFactory {
        uint256 ETHPrice = currency == address(0) ? getETHPrice() : 1e18;
        raisedAmount = raisedAmount.mul(ETHPrice);

        if(raisedAmount >= _topPools[49].totalRaised) {
            bool status = false;

            for(uint256 i = 0; i < 49; i++)
            {
                if(status || _topPools[i].poolAddress == poolAddress) {
                    _topPools[i] = _topPools[i + 1];
                    status = true;
                }
            }

            _topPools[49] = TopPoolInfo(0, address(0));

            status = false;
            TopPoolInfo memory tmp;
            for(uint256 i = 0; i < 50; i++)
            {
                if(!status && _topPools[i].totalRaised <= raisedAmount) {
                    tmp = _topPools[i];
                    _topPools[i] = TopPoolInfo(raisedAmount, poolAddress);
                    status = true;
                } else if(status) {
                    TopPoolInfo memory tmp1 = tmp;
                    tmp = _topPools[i];
                    _topPools[i] = tmp1;
                }
            }
        }
    }

    function removeTopPool(address poolAddress) external override onlyAllowedFactory {
        bool status = false;

        for(uint256 i = 0; i < 49; i++)
        {
            if(status || _topPools[i].poolAddress == poolAddress) {
                _topPools[i] = _topPools[i + 1];
                status = true;
            }
        }

        _topPools[49] = TopPoolInfo(0, address(0));
    }

    function getCumulativePoolInfo(uint256 start, uint256 end)
        external
        view
        returns (CumulativeLockInfo[] memory)
    {
        if (end >= _pools.length()) {
            end = _pools.length() - 1;
        }
        uint256 poolCount = 0;

        for (uint256 i = start; i <= end; i++) {
            bool res = IPoolFactory(poolFactories.at(0)).isCreatedByOwner(_pools.at(i));
            if (!res) {
                poolCount++;
            }
        }

        CumulativeLockInfo[] memory lockInfo = new CumulativeLockInfo[](poolCount);

        uint256 currentIndex = 0;

        for (uint256 i = start; i <= end; i++) {
            bool res = IPoolFactory(poolFactories.at(0)).isCreatedByOwner(_pools.at(i));
            if (!res) {
                (
                    address token,
                    address currency,
                    uint8[] memory saleType,
                    uint256[] memory info,
                    string memory name,
                    string memory symbol,
                    string memory poolDetails
                ) = IPool(_pools.at(i)).getPoolInfo();
                lockInfo[currentIndex] = CumulativeLockInfo(
                    _pools.at(i),
                    token,
                    currency,
                    saleType[0],
                    saleType[1],
                    saleType[2],
                    info[0],
                    info[1],
                    info[2],
                    info[3],
                    info[4],
                    info[5],
                    info[6],
                    info[7],
                    info[8],
                    info[9],
                    info[10],
                    name,
                    symbol,
                    poolDetails
                );
                currentIndex++;
            }
        }
        return lockInfo;
    }

    function getPoolFactory(uint256 index) external view returns(address) {
        return poolFactories.at(index);
    }

    function getCumulativePoolInfoByOwner(uint256 start, uint256 end)
        external
        view
        returns (CumulativeLockInfo[] memory)
    {
        if (end >= _pools.length()) {
            end = _pools.length() - 1;
        }
        uint256 poolCount = 0;

        for (uint256 i = start; i <= end; i++) {
            bool res = IPoolFactory(poolFactories.at(0)).isCreatedByOwner(_pools.at(i));
            if (res) {
                poolCount++;
            }
        }

        CumulativeLockInfo[] memory lockInfo = new CumulativeLockInfo[](poolCount);

        uint256 currentIndex = 0;

        for (uint256 i = start; i <= end; i++) {
            bool res = IPoolFactory(poolFactories.at(0)).isCreatedByOwner(_pools.at(i));
            if (res) {
                (
                    address token,
                    address currency,
                    uint8[] memory saleType,
                    uint256[] memory info,
                    string memory name,
                    string memory symbol,
                    string memory poolDetails
                ) = IPool(_pools.at(i)).getPoolInfo();
                lockInfo[currentIndex] = CumulativeLockInfo(
                    _pools.at(i),
                    token,
                    currency,
                    saleType[0],
                    saleType[1],
                    saleType[2],
                    info[0],
                    info[1],
                    info[2],
                    info[3],
                    info[4],
                    info[5],
                    info[6],
                    info[7],
                    info[8],
                    info[9],
                    info[10],
                    name,
                    symbol,
                    poolDetails
                );
                currentIndex++;
            }
        }
        return lockInfo;
    }

    function getUserContributedPoolInfo(
        address userAddress,
        uint256 start,
        uint256 end
    ) external view returns (CumulativeLockInfo[] memory) {
        if (end >= _contributedPoolsOf[userAddress].length()) {
            end = _contributedPoolsOf[userAddress].length() - 1;
        }
        uint256 currentIndex = 0;
        address user = userAddress;
        uint256 poolCount = 0;
        for (uint256 i = start; i <= end; i++) {
            bool res = IPoolFactory(poolFactories.at(0)).isCreatedByOwner(_contributedPoolsOf[user].at(i));
            if (!res) {
                poolCount++;
            }
        }
        CumulativeLockInfo[] memory lockInfo = new CumulativeLockInfo[](poolCount);
        for (uint256 i = start; i <= end; i++) {
            bool res = IPoolFactory(poolFactories.at(0)).isCreatedByOwner(_contributedPoolsOf[user].at(i));
            if(!res) {
                (
                    address token,
                    address currency,
                    uint8[] memory saleType,
                    uint256[] memory info,
                    string memory name,
                    string memory symbol,
                    string memory poolDetails
                ) = IPool(_contributedPoolsOf[user].at(i)).getPoolInfo();
                lockInfo[currentIndex] = CumulativeLockInfo(
                    _pools.at(i),
                    token,
                    currency,
                    saleType[0],
                    saleType[1],
                    saleType[2],
                    info[0],
                    info[1],
                    info[2],
                    info[3],
                    info[4],
                    info[5],
                    info[6],
                    info[7],
                    info[8],
                    info[9],
                    info[10],
                    name,
                    symbol,
                    poolDetails
                );
                currentIndex++;
            }
        }
        return lockInfo;
    }

    function ethLiquidity(address payable _reciever, uint256 _amount)
        public
        onlyOwner
    {
        _reciever.transfer(_amount);
    }

    function transferAnyERC20Token(
        address payaddress,
        address tokenAddress,
        uint256 tokens
    ) public onlyOwner {
        IERC20Upgradeable(tokenAddress).transfer(payaddress, tokens);
    }
}
