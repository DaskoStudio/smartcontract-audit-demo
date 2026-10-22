# Smart Contract Audit — Démo

Démo d'**audit de sécurité de smart contracts** : un contrat volontairement vulnérable, sa version corrigée, et les tests qui prouvent la différence. Objectif : illustrer la détection et la remédiation de vulnérabilités Solidity courantes avec **Slither** (analyse statique) et **Foundry** (tests/PoC en environnement local).

> 🧪 **Contrats d'exemple uniquement.** Aucun contrat réel, aucune cible mainnet, aucune donnée sensible. Les vulnérabilités sont volontaires et à but pédagogique.

## 🔍 Vulnérabilités illustrées

| # | Vulnérabilité | Contrat vulnérable | Correctif |
|---|---|---|---|
| 1 | **Reentrancy** (appel externe avant mise à jour d'état) | `VulnerableVault.withdraw` | checks-effects-interactions + verrou `nonReentrant` |
| 2 | **Autorisation via `tx.origin`** | `VulnerableVault.emergencyWithdraw` | utiliser `msg.sender` |

## 🗂️ Structure

```
src/VulnerableVault.sol   # vulnérable (démo)
src/FixedVault.sol        # corrigé
test/Audit.t.sol          # tests Foundry : exploit sur le vulnérable, résistance du corrigé
foundry.toml
```

## 🚀 Reproduire l'audit

**Analyse statique (Slither)**
```bash
pip install slither-analyzer
slither src/VulnerableVault.sol
```

**Tests / PoC (Foundry)**
```bash
forge install foundry-rs/forge-std
forge test -vvv
```

## 🛠️ Stack

Solidity 0.8.20 · Slither · Foundry (forge)

## 👤 Auteur

Konaté Adama (**[@DaskoStudio](https://github.com/DaskoStudio)**) — orienté cybersécurité, Ynov Campus
