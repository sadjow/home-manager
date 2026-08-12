#!/usr/bin/env python3
"""Analyze a discovery CSV and generate a fixture status report.

Usage:
    python3 analyze_discovery.py <csv_file> <installation> [--previous <prev_csv>]

Arguments:
    csv_file       Path to the discovery output CSV
    installation   Installation name: sven, hlp20, hlp30
    --previous     Optional previous CSV for comparison
"""

import csv
import sys
import os
from collections import defaultdict
from datetime import date

INSTALLATIONS = {
    "sven": {
        "upper": {
            "label": "Level Two (Upper - Elevation 751.0)",
            "positions": [
                {"pos": 1, "side": "South", "ip": "172.31.166.28", "declared": 74},
                {"pos": 2, "side": "South", "ip": "172.31.166.30", "declared": 60},
                {"pos": 3, "side": "West", "ip": "172.31.166.34", "declared": 73},
                {"pos": 4, "side": "—", "ip": "172.31.166.32", "declared": 72},
                {"pos": 5, "side": "North", "ip": "172.31.166.36", "declared": 64},
                {"pos": 6, "side": "—", "ip": "172.31.166.39", "declared": 70},
                {"pos": 7, "side": "East", "ip": "172.31.166.41", "declared": 75},
            ],
        },
        "lower": {
            "label": "Level One (Lower - Elevation 741.17)",
            "positions": [
                {"pos": 1, "side": "South", "ip": "172.31.166.29", "declared": 73},
                {"pos": 2, "side": "South", "ip": "172.31.166.31", "declared": 59},
                {"pos": 3, "side": "West", "ip": "172.31.166.35", "declared": 73},
                {"pos": 4, "side": "—", "ip": "172.31.166.33", "declared": 72},
                {"pos": 5, "side": "North", "ip": "172.31.166.37", "declared": 64},
                {"pos": 6, "side": "—", "ip": "172.31.166.38", "declared": 70},
                {"pos": 7, "side": "East", "ip": "172.31.166.40", "declared": 75},
            ],
        },
    },
    "hlp20": {
        "segments": {
            "label": "HLP20",
            "positions": [
                {"pos": "DE01", "side": "", "ip": "172.31.155.5", "declared": 56},
                {"pos": "DE02", "side": "", "ip": "172.31.155.6", "declared": 70},
                {"pos": "DE03", "side": "", "ip": "172.31.155.7", "declared": 59},
                {"pos": "DE04", "side": "", "ip": "172.31.155.8", "declared": 84},
            ],
        },
    },
    "hlp30": {
        "segments": {
            "label": "HLP30",
            "positions": [
                {"pos": "DE01", "side": "", "ip": "172.31.155.9", "declared": 57},
                {"pos": "DE02", "side": "", "ip": "172.31.155.10", "declared": 121},
                {"pos": "DE03", "side": "", "ip": "172.31.155.11", "declared": 65},
                {"pos": "DE04", "side": "", "ip": "172.31.155.12", "declared": 84},
            ],
        },
    },
}


def count_by_ip(csv_path):
    counts = defaultdict(int)
    dmx_by_ip = defaultdict(list)
    with open(csv_path) as f:
        reader = csv.DictReader(f)
        for row in reader:
            ip = row["IP Address/Device Serial Number"]
            dmx = int(row["DMX Address"])
            counts[ip] += 1
            dmx_by_ip[ip].append(dmx)
    return counts, dmx_by_ip


def find_duplicates(dmx_by_ip):
    duplicates = {}
    for ip, addresses in dmx_by_ip.items():
        seen = defaultdict(int)
        for addr in addresses:
            seen[addr] += 1
        dups = {addr: count for addr, count in seen.items() if count > 1}
        if dups:
            duplicates[ip] = dups
    return duplicates


def status_icon(declared, discovered):
    if discovered == declared:
        return "✅ Match"
    elif discovered == 0:
        return "❌ **No PDS Found**"
    elif discovered > declared:
        return f"⚠️ +{discovered - declared} extra"
    else:
        return f"❌ **Missing {declared - discovered}**"


def generate_report(csv_path, installation, prev_csv=None):
    counts, dmx_by_ip = count_by_ip(csv_path)
    prev_counts = count_by_ip(prev_csv)[0] if prev_csv else None
    duplicates = find_duplicates(dmx_by_ip)
    inst = INSTALLATIONS[installation]
    today = date.today().isoformat()
    csv_filename = os.path.basename(csv_path)

    lines = [f"# {installation.upper()} Fixture Status Report", "",
             f"**Date:** {today}", f"**Discovery File:** `{csv_filename}`", ""]

    total_declared = 0
    total_discovered = 0

    for level_key, level in inst.items():
        level_declared = sum(p["declared"] for p in level["positions"])
        level_discovered = sum(counts.get(p["ip"], 0) for p in level["positions"])
        total_declared += level_declared
        total_discovered += level_discovered

    all_match = total_declared == total_discovered
    lines += ["## Summary", "",
              "| Level | Declared | Discovered | Status |",
              "|-------|----------|------------|--------|"]

    for level_key, level in inst.items():
        ld = sum(p["declared"] for p in level["positions"])
        ldisc = sum(counts.get(p["ip"], 0) for p in level["positions"])
        lines.append(f"| {level['label']} | {ld} | {ldisc} | {status_icon(ld, ldisc)} |")

    lines.append(f"| **Total** | **{total_declared}** | **{total_discovered}** | {'✅ All match' if all_match else f'⚠️ Missing {total_declared - total_discovered}'} |")
    lines += ["", "---", ""]

    for level_key, level in inst.items():
        lines += [f"## {level['label']}", "",
                  "| Position | Side | IP Address | Declared | Discovered | Status |",
                  "|----------|------|------------|----------|------------|--------|"]
        ld_total = 0
        ldisc_total = 0
        for p in level["positions"]:
            disc = counts.get(p["ip"], 0)
            ld_total += p["declared"]
            ldisc_total += disc
            lines.append(f"| {p['pos']} | {p['side']} | {p['ip']} | {p['declared']} | {disc} | {status_icon(p['declared'], disc)} |")
        lines.append(f"| **Total** | | | **{ld_total}** | **{ldisc_total}** | {status_icon(ld_total, ldisc_total)} |")
        lines += ["", "---", ""]

    if duplicates:
        lines += ["## Duplicate DMX Addresses", ""]
        for ip, dups in duplicates.items():
            lines.append(f"**{ip}:** DMX addresses {', '.join(str(d) for d in sorted(dups.keys()))}")
        lines += ["", "---", ""]
    else:
        lines += ["## Duplicate DMX Addresses", "", "No duplicate DMX addresses were found.", "", "---", ""]

    if prev_counts:
        lines += ["## Comparison with Previous Scan", "",
                  "| IP Address | Previous | Current | Change |",
                  "|------------|----------|---------|--------|"]
        for level_key, level in inst.items():
            for p in level["positions"]:
                prev = prev_counts.get(p["ip"], 0)
                curr = counts.get(p["ip"], 0)
                change = curr - prev
                change_str = f"**+{change}**" if change > 0 else (f"**{change}**" if change < 0 else "—")
                if change != 0:
                    lines.append(f"| {p['ip']} | {prev} | {curr} | {change_str} |")
        prev_total = sum(prev_counts.get(p["ip"], 0) for lk, lv in inst.items() for p in lv["positions"])
        if prev_total != total_discovered:
            lines.append(f"| **Total** | **{prev_total}** | **{total_discovered}** | **{total_discovered - prev_total:+d}** |")
        else:
            lines.append("No changes from previous scan.")
        lines += ["", "---", ""]

    print("\n".join(lines))


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print(__doc__)
        sys.exit(1)

    csv_file = sys.argv[1]
    installation = sys.argv[2].lower()
    prev_csv = None

    if "--previous" in sys.argv:
        idx = sys.argv.index("--previous")
        prev_csv = sys.argv[idx + 1]

    if installation not in INSTALLATIONS:
        print(f"Unknown installation: {installation}. Valid: {', '.join(INSTALLATIONS.keys())}")
        sys.exit(1)

    generate_report(csv_file, installation, prev_csv)
