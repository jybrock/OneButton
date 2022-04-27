/**
* SPDX-License-Identifier: MIT
* OneOf Solidity Assignment & Fixed amount of ether to call press_button &
* Blocks past three & last participant can claim treasure/rewards/contract balance
*/
pragma solidity ^0.8.11;
/// @title OneOf - OneOfButton (https://www.oneof.com)
/// @author (JAB) 20220425 [E] jybrock@dpro.com [P] +17277127629
contract OneOfButton {
    event Withdrawal(address indexed to, uint amount); event Deposit(address indexed from, uint amount);
	receive() external payable { emit Deposit(msg.sender, msg.value); }
	mapping (address => uint) private balances;
	address payable private lastParticipant;
	uint private startingBlock = block.number; uint private currentBlock; uint private Fee = 0.75 ether; uint private balanceReceived;
	bool private boolEnded = false; bool private boolWinner = false;
    modifier Payout {
	    if (currentBlock >= startingBlock + 3) { boolEnded = true; 
			if (lastParticipant == msg.sender) { boolWinner = true; } else { boolWinner = false; }
		} else { boolEnded = false; lastParticipant = payable(msg.sender); }
		_;
	}
	/**
	* @dev Get total deposits in contract
	* @return Balance as uint
	*/
	function getBalance() private view returns(uint) { return address(this).balance; }
	/**
	* @dev Participants pay a fixed amount of ether to call press_button
	*/
	function claim_treasure() public payable Payout { if (boolWinner == true) { address payable to = payable(msg.sender); to.transfer(getBalance()); } }
	/**
	* @dev Participants pay a fixed amount of ether to call press_button
	*/
    function press_button() public payable Payout() { if (boolEnded == false) { currentBlock = block.number; lastParticipant = payable(msg.sender); balanceReceived += Fee; } }
	/**
	* @dev Test used for seeing positive balance increase on payout with different address
	* @notice Requirement: boolWinner == False
	*/
	function claim_treasure_to(address payable _to) private { _to.transfer(getBalance()); }
}