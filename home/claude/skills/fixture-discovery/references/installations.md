# Installation Network Topology

## SSH Access

All servers are accessed via `../spire-ansible` relative to the docs repo:

```bash
cd ../spire-ansible && ssh -F .ssh/config <host>
```

## Sven

- **SSH Host:** `sven`
- **Server IP:** `172.31.166.44`
- **Socket Port:** `8090` (EDN commands)
- **WebSocket Port:** `9090`
- **nREPL Port:** `7888` (forwarded to local `7889`)
- **Python Discovery:** `~/spireworks-nix/discover-network/Discover_Network.py sven-input.csv`
- **Installation File:** `spireworks-nix/modules/spire-simulator/resources/sven-installation.clj`

### Level Two (Upper - Elevation 751.0) — 488 fixtures

| Position | Side | IP Address | Declared |
|----------|------|------------|----------|
| 1 | South | 172.31.166.28 | 74 |
| 2 | South | 172.31.166.30 | 60 |
| 3 | West | 172.31.166.34 | 73 |
| 4 | — | 172.31.166.32 | 72 |
| 5 | North | 172.31.166.36 | 64 |
| 6 | — | 172.31.166.39 | 70 |
| 7 | East | 172.31.166.41 | 75 |

### Level One (Lower - Elevation 741.17) — 486 fixtures

| Position | Side | IP Address | Declared |
|----------|------|------------|----------|
| 1 | South | 172.31.166.29 | 73 |
| 2 | South | 172.31.166.31 | 59 |
| 3 | West | 172.31.166.35 | 73 |
| 4 | — | 172.31.166.33 | 72 |
| 5 | North | 172.31.166.37 | 64 |
| 6 | — | 172.31.166.38 | 70 |
| 7 | East | 172.31.166.40 | 75 |

**Total: 974 fixtures**

## HLP

- **SSH Host:** `hlp`
- **Server IP:** `172.31.155.3`
- **Python Discovery:** `~/spireworks-nix/discover-network/Discover_Network.py hlp20` and `hlp30`

### HLP20 — 269 fixtures

| Segment | IP Address | Declared |
|---------|------------|----------|
| DE01 | 172.31.155.5 | 56 |
| DE02 | 172.31.155.6 | 70 |
| DE03 | 172.31.155.7 | 59 |
| DE04 | 172.31.155.8 | 84 |

### HLP30 — 327 fixtures

| Segment | IP Address | Declared |
|---------|------------|----------|
| DE01 | 172.31.155.9 | 57 |
| DE02 | 172.31.155.10 | 121 |
| DE03 | 172.31.155.11 | 65 |
| DE04 | 172.31.155.12 | 84 |
