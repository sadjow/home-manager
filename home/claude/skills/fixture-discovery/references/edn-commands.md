# EDN Commands for KiNet Discovery

Send commands to the simulator TCP socket (default port `8090`) via:

```bash
cd ../spire-ansible && ssh -F .ssh/config <host> "echo '<EDN>' | nc -w <timeout> localhost 8090"
```

## PDS Health Check (safe, no flicker)

```clojure
{:cmds [{:name :ping-all-pds}]}
```

```clojure
{:cmds [{:name :ping-pds :ip "172.31.166.29"}]}
```

## Full Fixture Discovery (causes flicker)

```clojure
{:cmds [{:name :discover-installation :force true}]}
```

```clojure
{:cmds [{:name :discover-pds :ip "172.31.166.29" :force true}]}
```

## Relay Control

```clojure
{:cmds [{:name :set-pds-relay-on :ip "172.31.166.29"}]}
{:cmds [{:name :set-pds-relay-on :tags #{:lower}}]}
{:cmds [{:name :set-pds-relay-off :ip "172.31.166.29"}]}
```

## Status & Comparison

```clojure
{:cmds [{:name :get-discovery-state}]}
{:cmds [{:name :get-fixture-health}]}
{:cmds [{:name :compare-installation}]}
```

## Timeout Guidelines

- `:ping-all-pds` — 60s
- `:ping-pds` — 30s
- `:discover-installation` — 300s (scans all PDS in parallel, ~90s per PDS)
- `:discover-pds` — 120s
- Relay commands — 30s
- Status commands — 10s
