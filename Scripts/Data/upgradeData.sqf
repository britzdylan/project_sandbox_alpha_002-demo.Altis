// ============================================================
// scripts/data/upgradeData.sqf
// Static config for the 4-track, 16-node militia upgrade tree.
//
// Format per node:
//   [nodeId, displayName, description, cost, [prereqNodeIds], track]
//
// Tracks: "support" | "capabilities" | "integration" | "defence"
//
// Linear ordering within each track: 2pt → 4pt → 6pt → 8pt.
// Cross-track prerequisites (arrows):
//   upgrade_support_qrf      requires upgrade_cap_technicals
//   upgrade_def_atdefence    requires upgrade_cap_supportweapons
//   upgrade_int_fob          requires upgrade_cap_heavyvehicles AND upgrade_def_airdefence
//
// Usage:
//   private _nodes = call compile preProcessFileLineNumbers "scripts\data\upgradeData.sqf";
// ============================================================

[
    // ---- Support track — callable support options ----
    [
        "upgrade_support_ammo",
        "Dropoff Ammo Supply at TOC",
        "FIA supply drops deliver ammunition and equipment to the TOC.",
        2,
        [],
        "support"
    ],
    [
        "upgrade_support_transport",
        "Transport Vehicle at TOC",
        "FIA provides a vehicle transport delivered to the TOC.",
        4,
        ["upgrade_support_ammo"],
        "support"
    ],
    [
        "upgrade_support_qrf",
        "QRF to Players Location",
        "A quick reaction force can be called to the player's position. Requires FIA technical vehicles.",
        6,
        ["upgrade_support_transport", "upgrade_cap_technicals"],
        "support"
    ],
    [
        "upgrade_support_mortar",
        "Mortar Support",
        "FIA mortar teams provide indirect fire support on call.",
        8,
        ["upgrade_support_qrf"],
        "support"
    ],

    // ---- Capabilities track — FIA weapons and skill ----
    [
        "upgrade_cap_smallarms",
        "Small Arms",
        "Equip FIA fighters with standard infantry rifles and sidearms.",
        2,
        [],
        "capabilities"
    ],
    [
        "upgrade_cap_supportweapons",
        "Support Weapons",
        "Upgrade FIA with machine guns, RPGs, and crew-served weapons.",
        4,
        ["upgrade_cap_smallarms"],
        "capabilities"
    ],
    [
        "upgrade_cap_technicals",
        "Technicals",
        "FIA acquires armed pickup trucks and light vehicles for mobile operations.",
        6,
        ["upgrade_cap_supportweapons"],
        "capabilities"
    ],
    [
        "upgrade_cap_heavyvehicles",
        "Heavy Vehicles",
        "FIA gains access to armoured vehicles and heavy weapon platforms.",
        8,
        ["upgrade_cap_technicals"],
        "capabilities"
    ],

    // ---- Integration track — NATO strategic locations ----
    // Gated: requires both Heavy Vehicles and Air Defence to be purchased first.
    [
        "upgrade_int_fob",
        "F.O.B",
        "Establish a NATO Forward Operating Base providing supply and light vehicles. Requires full FIA capability and air defence.",
        2,
        ["upgrade_cap_heavyvehicles", "upgrade_def_airdefence"],
        "integration"
    ],
    [
        "upgrade_int_aob",
        "AOB",
        "Advance Operational Base with heavy vehicles and drone support.",
        4,
        ["upgrade_int_fob"],
        "integration"
    ],
    [
        "upgrade_int_farp",
        "FARP",
        "Forward Arming and Refuelling Point enabling helicopter support and anti-air coverage.",
        6,
        ["upgrade_int_aob"],
        "integration"
    ],
    [
        "upgrade_int_carrier",
        "Aircraft Carrier",
        "NATO carrier provides air support, naval gunfire, radar, and anti-air systems.",
        8,
        ["upgrade_int_farp"],
        "integration"
    ],

    // ---- Defence track — sector static defences ----
    [
        "upgrade_def_roadblocks",
        "Roadblocks",
        "FIA establishes vehicle checkpoints on approach routes into liberated sectors.",
        2,
        [],
        "defence"
    ],
    [
        "upgrade_def_roadpatrols",
        "Road Patrols",
        "FIA foot patrols monitor roads and react to enemy movement.",
        4,
        ["upgrade_def_roadblocks"],
        "defence"
    ],
    [
        "upgrade_def_atdefence",
        "AT Defence",
        "Anti-tank teams with RPGs and mines defend sector perimeters. Requires support weapons capability.",
        6,
        ["upgrade_def_roadpatrols", "upgrade_cap_supportweapons"],
        "defence"
    ],
    [
        "upgrade_def_airdefence",
        "Air Defence",
        "MANPADS teams and static AA guns protect liberated sectors from air attack.",
        8,
        ["upgrade_def_atdefence"],
        "defence"
    ]
]
