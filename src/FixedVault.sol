// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title FixedVault
/// @notice Version corrigée de VulnerableVault (checks-effects-interactions,
///         verrou anti-reentrancy, msg.sender au lieu de tx.origin).
contract FixedVault {
    mapping(address => uint256) public balances;
    address public immutable owner;
    uint256 private _locked = 1;

    error NotOwner();
    error InsufficientBalance();
    error TransferFailed();

    modifier nonReentrant() {
        require(_locked == 1, "reentrancy");
        _locked = 2;
        _;
        _locked = 1;
    }

    constructor() {
        owner = msg.sender;
    }

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    // FIX 1 — effects avant interactions + verrou nonReentrant
    function withdraw(uint256 amount) external nonReentrant {
        if (balances[msg.sender] < amount) revert InsufficientBalance();
        balances[msg.sender] -= amount;
        (bool ok, ) = msg.sender.call{value: amount}("");
        if (!ok) revert TransferFailed();
    }

    // FIX 2 — msg.sender au lieu de tx.origin
    function emergencyWithdraw() external {
        if (msg.sender != owner) revert NotOwner();
        payable(owner).transfer(address(this).balance);
    }
}
