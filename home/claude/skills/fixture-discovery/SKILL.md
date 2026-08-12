---
name: fixture-discovery
description: Run KiNet fixture discovery scans on Spireworks installations (sven, hlp20, hlp30). Use when the user asks to scan fixtures, check PDS health, run discovery, or generate fixture status reports.
---

# Fixture Discovery

## Overview

Scan Spireworks LED fixture installations via KiNet protocol to verify all PDS (Power Data Supply) units and fixtures are responding correctly. Supports both Python network discovery and Clojure simulator EDN commands.

## Workflow

### 1. PDS Health Check (no flicker)

Ping all PDS units to verify reachability before running discovery:

```bash
cd ../spire-ansible && ssh -F .ssh/config <host> "echo '{:cmds [{:name :ping-all-pds}]}' | nc -w 60 localhost 8090"
```

For a single PDS:
```bash
cd ../spire-ansible && ssh -F .ssh/config <host> "echo '{:cmds [{:name :ping-pds :ip \"<ip>\"}]}' | nc -w 30 localhost 8090"
```

### 2. Run Python Discovery

SSH into the server and run the Python discovery script:

```bash
cd ../spire-ansible && ssh -F .ssh/config <host>
cd ~/spireworks-nix/discover-network
python3 Discover_Network.py <input-file>
```

Input files per installation:
- **sven**: `sven-input.csv`
- **hlp20**: `hlp20`
- **hlp30**: `hlp30`

The script outputs a CSV file named `output<MM-DD-YY-HHMMSS>.csv`.

### 3. Run Clojure Discovery (causes flicker)

Trigger full installation discovery via the simulator:

```bash
cd ../spire-ansible && ssh -F .ssh/config <host> "echo '{:cmds [{:name :discover-installation :force true}]}' | nc -w 300 localhost 8090"
```

For a single PDS:
```bash
cd ../spire-ansible && ssh -F .ssh/config <host> "echo '{:cmds [{:name :discover-pds :ip \"<ip>\" :force true}]}' | nc -w 120 localhost 8090"
```

### 4. Copy CSV and Generate Report

Copy the discovery CSV locally:
```bash
cd ../spire-ansible && scp -F .ssh/config <host>:~/spireworks-nix/discover-network/<csv-file> /Users/sadjow/spire/spireworks-docs/reports/infrastructure/
```

Generate a report using the analysis script:
```bash
python3 scripts/analyze_discovery.py <csv_file> <installation> [--previous <prev_csv>]
```

Save the report to `reports/infrastructure/<installation>_fixture_status_<date>.md`.

### 5. Verify with Datadog

After Clojure discovery, check `simulator.kinet.discovery.fixtures` gauge in Datadog to cross-reference counts.

## SSH Hosts

| Installation | SSH Host | Server IP |
|-------------|----------|-----------|
| Sven | `sven` | 172.31.166.44 |
| HLP20/HLP30 | `hlp` | 172.31.155.3 |

All SSH access goes through `../spire-ansible` with `ssh -F .ssh/config <host>`.

## Resources

### scripts/
- `analyze_discovery.py` — Parses discovery CSV files and generates markdown status reports with declared vs discovered comparison

### references/
- `installations.md` — Network topology, IP addresses, and declared fixture counts per PDS
- `edn-commands.md` — EDN command reference with timeout guidelines
