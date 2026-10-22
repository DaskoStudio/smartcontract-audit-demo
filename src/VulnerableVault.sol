// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title VulnerableVault
/// @notice DÉMO PÉDAGOGIQUE — contient des vulnérabilités VOLONTAIRES.
///         Ne jamais déployer en production.
contract VulnerableVault {
    mapping(address => uint256) public balances;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    // VULN 1 — Reentrancy : l'appel externe a lieu AVANT la mise à jour du solde
    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "solde insuffisant");
        (bool ok, ) = msg.sender.call{value: amount}("");
        require(ok, "transfert echoue");
        balances[msg.sender] -= amount; // mise à jour trop tardive
    }

    // VULN 2 — Autorisation via tx.origin (contournable par phishing de contrat)
    function emergencyWithdraw() external {
        require(tx.origin == owner, "non autorise");
        payable(msg.sender).transfer(address(this).balance);
    }
}
