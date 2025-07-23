# Oracle Manipulation Example with Flash Loans 📉

Oracle manipulation is one of the most common and dangerous attack vectors in the world of DeFi. In this demo, we'll walk through how someone can manipulate token prices by messing with DEX reserves, and use that fake price to exploit a protocol that naively relies on manipulated pricing.

## Scenario Overview

We’ll simulate a DeFi ecosystem with the following components:

* **Uniswap** a DEX with a trading pair `USDT/cNGN`
* **A Flash Loan Receiver** contract used to initiate a flash loan
* **NFT Marketplace** that prices each NFT based on the price of `USDT/cNGN` from our DEX.
* **AAVE** a lending protocol that borrows the `FlashLoan` contract to execute it's trade.

### Attack Vector Explained 🥷🏻

The `NftMarketplace` contract uses the Uniswap-like DEX as a price oracle by relying on the reserve ratio of `cNGN/USDT` to determine the value of cNGN. The NFT price is fixed at **10 cNGN**, assuming this reflects a stable value.

### The Exploit 💀:

Using a flash loan contract, we borrowed `900 cNGN` and swapped it for USDT on the DEX, drastically altering the reserve ratio:

* **Before Swap (Normal Market):**
  `100 cNGN : 10 USDT` → 1 USDT = 10 cNGN (Expected market rate)

* **After Swap (Manipulated Market):**
  `1000 cNGN : 1 USDT` → 1 USDT = 1000 cNGN (Manipulated rate)
  Now, **10 cNGN ≈ 0.01 USDT**, effectively devaluing the NFT price.

### Attack Execution 

1. **Initiate a flash loan** of `900 cNGN` from the AAVE protocol.
2. **Swap** the borrowed `cNGN` for `USDT` on Uniswap, significantly distorting the `cNGN/USDT` price ratio.
3. **Purchase NFTs** from `NftMarketplace`, which now appear severely undervalued due to the manipulated exchange rate.
4. **Reverse the swap**: Trade `USDT` back for `cNGN` on Uniswap to restore the initial price ratio.
5. **Sell the NFTs** either back to the marketplace or externally at the corrected market price.
6. **Repay** the flash loan all within a single atomic transaction.
7. **Profit** from the arbitrage created through oracle price manipulation.

# Test logs

```javascript
[PASS] testExploit() (gas: 15955472)
Logs:
  Initial cNGN balance of Aave Lending Pool: 1000000000000000000000 (1000cNGN) tokens
  Initial cNGN balance of FlashContract: 1 // We use this token to buy the NFT multiple times
  Initial NFT price (cNGN): 0
  Price of an NFT before swap 1000000000000000000
  Price of an NFT after swap 10000000000000000
  Final cNGN balance of Aave Lending Pool: 1081000000000000000000
  Final cNGN balance of FlashContract: 19 // Profit made from arbitrage
```

You can run the test in by
```bash
forge build && forge install
forge test --mt testExploit
```

## Contracts Involved

There are **four main smart contracts** involved in this simulation:

| Contract         | Description                                                                               |
| ---------------- | ----------------------------------------------------------------------------------------- |
| `FlashContract`  | Executes the flash loan and orchestrates the attack sequence.                             |
| `Uniswap`        | The decentralized exchange (DEX) used by `NftMarketplace` as a price oracle for `cNGN`.   |
| `NftMarketplace` | The vulnerable contract that determines NFT prices based on the manipulated `cNGN` price. |
| `MockAavePool`   | Simulates a lending protocol that provides the flash loan of `cNGN` tokens.               |


## 🤝 Contributions Welcome!
Want to contribute? 

* Add a second NFT marketplace that reflects true price
* Deploy the contract to a testnet using AAVE lending contracts
* Or any idea you have to improve this repo

PRs and forks are welcome!

## Read and Learn More About Oracle Manipulation Hacks

Explore these notable case studies and resources to deepen your understanding of oracle manipulation vulnerabilities:

* [Cream Finance – Case Study](https://rekt.news/cream-rekt-2/)
  A real-world example of how price oracles can be exploited for massive profit.

* [Damn Vulnerable DeFi – The Rewarder Challenge](https://www.damnvulnerabledefi.xyz/challenges/the-rewarder/)
  A hands-on challenge designed to teach DeFi exploit patterns including oracle issues.

* [Cyfrin – Smart Contract Exploits (Minimized)](https://github.com/Cyfrin/sc-exploits-minimized?tab=readme-ov-file)
  A curated repo of simplified real-world exploit examples maintained by Cyfrin.


## ⚠️ Disclaimer

> This repository is for **educational purposes only**.
> Oracle manipulation is a well-documented vulnerability in DeFi.
> Understanding how it works is essential to building more **secure**, **robust**, and **decentralized** financial systems.

Use this knowledge **ethically**—to **audit**, **secure**, and **improve** smart contracts—not to exploit them.