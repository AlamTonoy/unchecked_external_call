# Unchecked External Call — Smart Contract Vulnerability Dataset

A dataset of **1,000 annotated Solidity smart contracts** demonstrating
*Unchecked External Call* vulnerabilities (DASP-4, class\_id 2) across
**8 distinct subtypes**. Designed for training and benchmarking smart-contract
vulnerability detection models.

---

## Dataset Overview

| # | Subtype Key | Canonical Name | Severity | CWE | SWC | Contracts |
|---|-------------|----------------|----------|-----|-----|-----------|
| 1 | `unchecked_low_level_call` | Unchecked Low-Level Call | High | CWE-252, CWE-703, CWE-754 | SWC-104 | 125 |
| 2 | `unchecked_delegatecall` | Unchecked Delegatecall | Critical | CWE-829, CWE-250 | SWC-112 | 125 |
| 3 | `unchecked_external_contract_call` | Unchecked External Contract Call | High | CWE-252 | SWC-104 | 125 |
| 4 | `unchecked_staticcall` | Unchecked Staticcall | Medium | CWE-252 | SWC-104 | 125 |
| 5 | `unchecked_create` | Unchecked Contract Creation | High | CWE-252 | SWC-104 | 125 |
| 6 | `erc20_no_return_check` | ERC-20 Missing Return Check | High | CWE-252 | SWC-104 | 125 |
| 7 | `forced_ether_acceptance` | Forced Ether Acceptance | Medium | CWE-252, CWE-670 | — | 125 |
| 8 | `assembly_call_unchecked` | Assembly Call Without Return Check | High | CWE-252 | SWC-104 | 125 |
| | **Total** | | | | | **1,000** |

---

## Repository Structure

```
unchecked_external_call/
├── contracts/
│   ├── unchecked_low_level_call/        # 125 × .sol
│   ├── unchecked_delegatecall/          # 125 × .sol
│   ├── unchecked_external_contract_call/# 125 × .sol
│   ├── unchecked_staticcall/            # 125 × .sol
│   ├── unchecked_create/                # 125 × .sol
│   ├── erc20_no_return_check/           # 125 × .sol
│   ├── forced_ether_acceptance/         # 125 × .sol
│   └── assembly_call_unchecked/         # 125 × .sol
└── labels/
    ├── unchecked_low_level_call/        # 125 × .json
    ├── unchecked_delegatecall/          # 125 × .json
    ├── unchecked_external_contract_call/# 125 × .json
    ├── unchecked_staticcall/            # 125 × .json
    ├── unchecked_create/                # 125 × .json
    ├── erc20_no_return_check/           # 125 × .json
    ├── forced_ether_acceptance/         # 125 × .json
    └── assembly_call_unchecked/         # 125 × .json
```

Each contract `contracts/<subtype>/contract_NNN.sol` has a corresponding
label file `labels/<subtype>/contract_NNN.json`.

---

## Subtype Descriptions

### 1. `unchecked_low_level_call`
Solidity's `.call()` and `.send()` return a boolean `success` that is silently
discarded. Covers payment splitters, withdrawal patterns, and multi-recipient
forwarding contracts where failed transfers are never detected.
**Detection tools:** Slither (`unchecked-send`, `unchecked-lowlevel`), Mythril (SWC-104).

### 2. `unchecked_delegatecall`
`delegatecall` executes foreign code in the caller's storage context.
Unchecked `delegatecall` results allow proxy contracts to silently fail,
leaving state inconsistent. Includes user-controlled targets (arbitrary
`delegatecall`) and mutable implementation pointers.
**Detection tools:** Mythril (SWC-112), Slither.

### 3. `unchecked_external_contract_call`
High-level calls to external contract interfaces where the return value is
ignored. Includes ERC-20 distributors, oracle consumers, strategy vaults,
and callback dispatchers.
**Detection tools:** Slither (`unused-return`), Aderyn.

### 4. `unchecked_staticcall`
`staticcall` can fail (e.g., gas exhaustion, reverted view function) and
return `(false, "")`. Contracts that ignore the boolean treat a failed read
as a successful zero result. Covers oracle caches, balance checkers, and
multi-call aggregators.

### 5. `unchecked_create`
Inline assembly `create` / `create2` returns `address(0)` on failure.
Contracts that push the result into registries or mappings without a
`require(addr != address(0))` check break silently.

### 6. `erc20_no_return_check`
Non-standard tokens (USDT, BNB, etc.) don't return a boolean from
`transfer()` / `transferFrom()`. Using the standard `IERC20` ABI on these
tokens causes a revert (return data too short) or a silent no-op depending
on the Solidity version.

### 7. `forced_ether_acceptance`
Any contract can receive ETH via `selfdestruct` or miner coinbase rewards,
bypassing `receive()` / `fallback()`. Contracts that rely on
`address(this).balance` for invariants or milestone checks can be
manipulated.

### 8. `assembly_call_unchecked`
Inline Yul/assembly `call` instructions whose return value (`success`) is
computed but never acted upon with `if iszero(success) { revert(0,0) }`.
Covers gas-optimised ETH dispatch libraries, routers, and vaults.

---

## Label Schema

Each `.json` label file follows this structure:

```jsonc
{
  "contract_id": "0x<40-hex-chars>",          // pseudo-address or on-chain address
  "collection_source": "etherscan_verified",   // data origin
  "compiler_version": "0.8.19",
  "solidity_version": "^0.8.0",
  "optimization_enabled": true,
  "optimization_runs": 200,
  "protocol_type": "AMM",
  "protocol_name": "UniswapV2Fork",
  "total_value_locked_usd": 5000000,
  "deployment_date": "2024-03-15",
  "audit_status": "Trail_of_Bits_2024",

  "exploit_history": {
    "exploited": true,
    "exploit_date": "2024-06-20",
    "exploit_value_usd": 1200000,
    "exploit_tx": "0x<64-hex-chars>"
  },

  "vulnerability_labels": {
    "<subtype_key>": {
      "present": true,
      "severity": "high",          // critical | high | medium | low
      "confidence": 0.95,          // [0.75, 1.0]
      "line_numbers": [45, 67],    // lines containing the vulnerable code
      "cwe": ["CWE-252"],
      "swc": ["SWC-104"]
    }
  }
}
```

---

## Taxonomy Reference

```python
UNCHECKED_EXTERNAL_CALL_TAXONOMY = {
    "class_id": 2,
    "class_name": "Unchecked External Calls",
    "description": (
        "Failures in handling boolean return values of low-level calls, "
        "leading to silent failures."
    ),
    "dasp_id": "DASP-4",
    "mapping_confidence": 1.0,
    "tools_detection": {
        "slither":    ["unchecked-send", "unchecked-lowlevel", "unused-return"],
        "mythril":    ["SWC-104"],
        "securify":   ["UncheckedCall"],
        "smartcheck": ["SOLIDITY_UNCHECKED_CALL"],
        "4nalyzer":   ["unchecked-return"],
        "aderyn":     ["unchecked-external-call"],
    },
}
```

---

## Usage

### Load a contract + its label (Python)

```python
import json, pathlib

BASE = pathlib.Path(".")
subtype = "unchecked_low_level_call"
idx = 1

sol_src = (BASE / "contracts" / subtype / f"contract_{idx:03d}.sol").read_text()
label   = json.loads((BASE / "labels" / subtype / f"contract_{idx:03d}.json").read_text())

print(sol_src)
print(label["vulnerability_labels"])
```

### Iterate all 1 000 samples

```python
import json, pathlib

BASE = pathlib.Path(".")
samples = []
for sol_file in sorted((BASE / "contracts").rglob("*.sol")):
    subtype = sol_file.parent.name
    json_file = BASE / "labels" / subtype / (sol_file.stem + ".json")
    samples.append({
        "subtype": subtype,
        "source": sol_file.read_text(),
        "label": json.loads(json_file.read_text()),
    })

print(f"Loaded {len(samples)} samples")
```

---

## Detection Tool Commands

Run the static analysis tools against any contract to reproduce findings:

```bash
# Slither
slither contracts/unchecked_low_level_call/contract_001.sol \
    --detect unchecked-send,unchecked-lowlevel,unused-return

# Mythril
myth analyze contracts/unchecked_delegatecall/contract_001.sol \
    --swc-blacklist SWC-112

# Aderyn
aderyn contracts/assembly_call_unchecked/contract_001.sol
```

---

## Statistics

- **Total contracts:** 1,000  
- **Contracts per subtype:** 125  
- **Approximate exploit rate in dataset:** ~35 % (probabilistic, seeded)  
- **Solidity versions covered:** 0.6.x – 0.8.x  
- **Protocol types covered:** AMM, Lending, NFT, DAO, Bridge, Staking, Vault, Lottery, Payment, Escrow, Auction, Yield, Insurance, Options, Perpetuals