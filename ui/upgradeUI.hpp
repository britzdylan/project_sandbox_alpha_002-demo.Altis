// ============================================================
// ui/upgradeUI.hpp
// OSF_UpgradeUI — FIA Upgrade Command
// IDD 9002
//
// IDC reference:
//   9400 — CP counter label  (top-right header)
//   9401 — node description panel  (bottom)
//   9402 — Close button
//
// Node button IDCs — ordered by track, then tier (2CP first):
//   Support:       9410 (ammo/2CP)   9411 (transport/4CP)  9412 (qrf/6CP)      9413 (mortar/8CP)
//   Capabilities:  9420 (smallarms)  9421 (suppweapons/4CP) 9422 (tech/6CP)    9423 (heavyveh/8CP)
//   Integration:   9430 (fob/2CP)    9431 (aob/4CP)        9432 (farp/6CP)     9433 (carrier/8CP)
//   Defence:       9440 (roadblocks) 9441 (roadpatrols/4CP) 9442 (atdef/6CP)   9443 (airdef/8CP)
//
// Visual layout — top row = most expensive (8CP), bottom = cheapest (2CP):
//   Row 1 (y~0.18): 9413  9423  9433  9443
//   Row 2 (y~0.27): 9412  9422  9432  9442
//   Row 3 (y~0.36): 9411  9421  9431  9441
//   Row 4 (y~0.46): 9410  9420  9430  9440
//
// Column x positions (safeZoneW fractions):
//   Col 1 Support:       0.105 – 0.290  (w 0.185)
//   Col 2 Capabilities:  0.300 – 0.485  (w 0.185)
//   Col 3 Integration:   0.495 – 0.680  (w 0.185)
//   Col 4 Defence:       0.690 – 0.875  (w 0.185)
//
// Logic (node coloring, click handlers, CP display) wired in fn_tocMilitiaUI.
// ============================================================

class OSF_UpgradeUI
{
    idd = 9002;
    movingEnable = false;
    enableSimulation = false;
    onLoad = "";
    onUnload = "";

    class controlsBackground
    {
        // Main panel
        class BG_Main : RscText
        {
            idc = -1;
            x = "safeZoneX + safeZoneW * 0.10";
            y = "safeZoneY + safeZoneH * 0.05";
            w = "safeZoneW * 0.80";
            h = "safeZoneH * 0.72";
            text = "";
            colorBackground[] = {0.04, 0.05, 0.04, 0.97};
        };
        // Header accent strip
        class BG_Header : RscText
        {
            idc = -1;
            x = "safeZoneX + safeZoneW * 0.10";
            y = "safeZoneY + safeZoneH * 0.05";
            w = "safeZoneW * 0.80";
            h = "safeZoneH * 0.058";
            text = "";
            colorBackground[] = {0.06, 0.10, 0.06, 1.0};
        };
    };

    class controls
    {
        // ── Header ───────────────────────────────────────────────────────

        class OSF_UpUI_OpName : RscText
        {
            idc = -1;
            x = "safeZoneX + safeZoneW * 0.105";
            y = "safeZoneY + safeZoneH * 0.054";
            w = "safeZoneW * 0.370";
            h = "safeZoneH * 0.018";
            text = "OPERATION SOVEREIGN FURY";
            sizeEx = 0.020;
            colorBackground[] = {0, 0, 0, 0};
            colorText[] = {0.95, 0.78, 0.30, 1.0};
        };
        class OSF_UpUI_Classification : RscText
        {
            idc = -1;
            x = "safeZoneX + safeZoneW * 0.783";
            y = "safeZoneY + safeZoneH * 0.054";
            w = "safeZoneW * 0.112";
            h = "safeZoneH * 0.018";
            text = "CLASSIFIED // OSF";
            sizeEx = 0.018;
            colorBackground[] = {0, 0, 0, 0};
            colorText[] = {0.88, 0.22, 0.22, 1.0};
        };
        class OSF_UpUI_Title : RscText
        {
            idc = -1;
            x = "safeZoneX + safeZoneW * 0.105";
            y = "safeZoneY + safeZoneH * 0.074";
            w = "safeZoneW * 0.370";
            h = "safeZoneH * 0.030";
            text = "FIA UPGRADE COMMAND";
            sizeEx = 0.030;
            colorBackground[] = {0, 0, 0, 0};
            colorText[] = {0.62, 0.80, 0.42, 1.0};
        };
        // IDC 9400 — updated at runtime by fn_tocMilitiaUI
        class OSF_UpUI_CPCounter : RscText
        {
            idc = 9400;
            x = "safeZoneX + safeZoneW * 0.555";
            y = "safeZoneY + safeZoneH * 0.074";
            w = "safeZoneW * 0.335";
            h = "safeZoneH * 0.030";
            text = "COMMAND POINTS: --";
            sizeEx = 0.028;
            style = 2;  // right-align
            colorBackground[] = {0, 0, 0, 0};
            colorText[] = {0.95, 0.78, 0.30, 1.0};
        };
        class OSF_UpUI_Sep1 : RscText
        {
            idc = -1;
            x = "safeZoneX + safeZoneW * 0.105";
            y = "safeZoneY + safeZoneH * 0.108";
            w = "safeZoneW * 0.690";
            h = "safeZoneH * 0.002";
            text = "";
            colorBackground[] = {0.95, 0.78, 0.30, 0.85};
        };

        // ── Track header titles ───────────────────────────────────────────

        class OSF_UpUI_TrackTitle_Sup : RscText
        {
            idc = -1;
            x = "safeZoneX + safeZoneW * 0.105";
            y = "safeZoneY + safeZoneH * 0.113";
            w = "safeZoneW * 0.185";
            h = "safeZoneH * 0.022";
            text = "SUPPORT";
            sizeEx = 0.026;
            colorBackground[] = {0, 0, 0, 0};
            colorText[] = {0.62, 0.80, 0.42, 1.0};
        };
        class OSF_UpUI_TrackTitle_Cap : RscText
        {
            idc = -1;
            x = "safeZoneX + safeZoneW * 0.300";
            y = "safeZoneY + safeZoneH * 0.113";
            w = "safeZoneW * 0.185";
            h = "safeZoneH * 0.022";
            text = "CAPABILITIES";
            sizeEx = 0.026;
            colorBackground[] = {0, 0, 0, 0};
            colorText[] = {0.62, 0.80, 0.42, 1.0};
        };
        class OSF_UpUI_TrackTitle_Int : RscText
        {
            idc = -1;
            x = "safeZoneX + safeZoneW * 0.495";
            y = "safeZoneY + safeZoneH * 0.113";
            w = "safeZoneW * 0.185";
            h = "safeZoneH * 0.022";
            text = "INTEGRATION";
            sizeEx = 0.026;
            colorBackground[] = {0, 0, 0, 0};
            colorText[] = {0.62, 0.80, 0.42, 1.0};
        };
        class OSF_UpUI_TrackTitle_Def : RscText
        {
            idc = -1;
            x = "safeZoneX + safeZoneW * 0.690";
            y = "safeZoneY + safeZoneH * 0.113";
            w = "safeZoneW * 0.185";
            h = "safeZoneH * 0.022";
            text = "DEFENCE";
            sizeEx = 0.026;
            colorBackground[] = {0, 0, 0, 0};
            colorText[] = {0.62, 0.80, 0.42, 1.0};
        };

        // ── Track descriptions ────────────────────────────────────────────

        class OSF_UpUI_TrackDesc_Sup : RscText
        {
            idc = -1;
            x = "safeZoneX + safeZoneW * 0.105";
            y = "safeZoneY + safeZoneH * 0.137";
            w = "safeZoneW * 0.185";
            h = "safeZoneH * 0.030";
            text = "Callable support options";
            sizeEx = 0.019;
            colorBackground[] = {0, 0, 0, 0};
            colorText[] = {0.45, 0.52, 0.38, 0.90};
        };
        class OSF_UpUI_TrackDesc_Cap : RscText
        {
            idc = -1;
            x = "safeZoneX + safeZoneW * 0.300";
            y = "safeZoneY + safeZoneH * 0.137";
            w = "safeZoneW * 0.185";
            h = "safeZoneH * 0.030";
            text = "FIA weapons and skill";
            sizeEx = 0.019;
            colorBackground[] = {0, 0, 0, 0};
            colorText[] = {0.45, 0.52, 0.38, 0.90};
        };
        class OSF_UpUI_TrackDesc_Int : RscText
        {
            idc = -1;
            x = "safeZoneX + safeZoneW * 0.495";
            y = "safeZoneY + safeZoneH * 0.137";
            w = "safeZoneW * 0.185";
            h = "safeZoneH * 0.030";
            text = "NATO strategic locations";
            sizeEx = 0.019;
            colorBackground[] = {0, 0, 0, 0};
            colorText[] = {0.45, 0.52, 0.38, 0.90};
        };
        class OSF_UpUI_TrackDesc_Def : RscText
        {
            idc = -1;
            x = "safeZoneX + safeZoneW * 0.690";
            y = "safeZoneY + safeZoneH * 0.137";
            w = "safeZoneW * 0.185";
            h = "safeZoneH * 0.030";
            text = "Sector static defences";
            sizeEx = 0.019;
            colorBackground[] = {0, 0, 0, 0};
            colorText[] = {0.45, 0.52, 0.38, 0.90};
        };

        // ── Vertical column dividers (span full node area) ────────────────

        class OSF_UpUI_VDiv1 : RscText
        {
            idc = -1;
            x = "safeZoneX + safeZoneW * 0.294";
            y = "safeZoneY + safeZoneH * 0.112";
            w = "safeZoneW * 0.002";
            h = "safeZoneH * 0.442";
            text = "";
            colorBackground[] = {0.28, 0.40, 0.20, 0.35};
        };
        class OSF_UpUI_VDiv2 : RscText
        {
            idc = -1;
            x = "safeZoneX + safeZoneW * 0.489";
            y = "safeZoneY + safeZoneH * 0.112";
            w = "safeZoneW * 0.002";
            h = "safeZoneH * 0.442";
            text = "";
            colorBackground[] = {0.28, 0.40, 0.20, 0.35};
        };
        class OSF_UpUI_VDiv3 : RscText
        {
            idc = -1;
            x = "safeZoneX + safeZoneW * 0.684";
            y = "safeZoneY + safeZoneH * 0.112";
            w = "safeZoneW * 0.002";
            h = "safeZoneH * 0.442";
            text = "";
            colorBackground[] = {0.28, 0.40, 0.20, 0.35};
        };

        // Sep below track headers
        class OSF_UpUI_Sep2 : RscText
        {
            idc = -1;
            x = "safeZoneX + safeZoneW * 0.105";
            y = "safeZoneY + safeZoneH * 0.170";
            w = "safeZoneW * 0.690";
            h = "safeZoneH * 0.002";
            text = "";
            colorBackground[] = {0.95, 0.78, 0.30, 0.85};
        };

        // ═══════════════════════════════════════════════════════════════════
        // NODE BUTTONS — Default colors are set here; fn_tocMilitiaUI
        // overrides them at runtime based on purchase state:
        //   Purchased : bg {0.06, 0.22, 0.06}  text {0.35, 0.85, 0.35}
        //   Available : bg {0.10, 0.16, 0.08}  text {0.72, 0.88, 0.55}
        //   Locked    : bg {0.06, 0.08, 0.06}  text {0.30, 0.36, 0.26}
        // ═══════════════════════════════════════════════════════════════════

        // ── Row 1 — Tier 8CP (top) ────────────────────────────────────────

        class OSF_UpUI_Node_9413 : RscButton
        {
            idc = 9413;
            x = "safeZoneX + safeZoneW * 0.107";
            y = "safeZoneY + safeZoneH * 0.176";
            w = "safeZoneW * 0.181";
            h = "safeZoneH * 0.068";
            text = "MORTAR SUPPORT";
            sizeEx = 0.022;
            colorBackground[] = {0.06, 0.08, 0.06, 1.0};
            colorText[] = {0.30, 0.36, 0.26, 1.0};
            colorActive[] = {0.08, 0.12, 0.06, 1.0};
            action = "";
        };
        class OSF_UpUI_Node_9423 : RscButton
        {
            idc = 9423;
            x = "safeZoneX + safeZoneW * 0.302";
            y = "safeZoneY + safeZoneH * 0.176";
            w = "safeZoneW * 0.181";
            h = "safeZoneH * 0.068";
            text = "HEAVY VEHICLES";
            sizeEx = 0.022;
            colorBackground[] = {0.06, 0.08, 0.06, 1.0};
            colorText[] = {0.30, 0.36, 0.26, 1.0};
            colorActive[] = {0.08, 0.12, 0.06, 1.0};
            action = "";
        };
        class OSF_UpUI_Node_9433 : RscButton
        {
            idc = 9433;
            x = "safeZoneX + safeZoneW * 0.497";
            y = "safeZoneY + safeZoneH * 0.176";
            w = "safeZoneW * 0.181";
            h = "safeZoneH * 0.068";
            text = "AIRCRAFT CARRIER";
            sizeEx = 0.022;
            colorBackground[] = {0.06, 0.08, 0.06, 1.0};
            colorText[] = {0.30, 0.36, 0.26, 1.0};
            colorActive[] = {0.08, 0.12, 0.06, 1.0};
            action = "";
        };
        class OSF_UpUI_Node_9443 : RscButton
        {
            idc = 9443;
            x = "safeZoneX + safeZoneW * 0.692";
            y = "safeZoneY + safeZoneH * 0.176";
            w = "safeZoneW * 0.181";
            h = "safeZoneH * 0.068";
            text = "AIR DEFENCE";
            sizeEx = 0.022;
            colorBackground[] = {0.06, 0.08, 0.06, 1.0};
            colorText[] = {0.30, 0.36, 0.26, 1.0};
            colorActive[] = {0.08, 0.12, 0.06, 1.0};
            action = "";
        };
        // Cost labels — Tier 8CP
        class OSF_UpUI_Cost_9413 : RscText
        {
            idc = -1; x = "safeZoneX + safeZoneW * 0.107"; y = "safeZoneY + safeZoneH * 0.246";
            w = "safeZoneW * 0.181"; h = "safeZoneH * 0.016"; text = "8 CP";
            sizeEx = 0.017; style = 1; colorBackground[] = {0,0,0,0}; colorText[] = {0.55, 0.62, 0.45, 0.80};
        };
        class OSF_UpUI_Cost_9423 : RscText
        {
            idc = -1; x = "safeZoneX + safeZoneW * 0.302"; y = "safeZoneY + safeZoneH * 0.246";
            w = "safeZoneW * 0.181"; h = "safeZoneH * 0.016"; text = "8 CP";
            sizeEx = 0.017; style = 1; colorBackground[] = {0,0,0,0}; colorText[] = {0.55, 0.62, 0.45, 0.80};
        };
        class OSF_UpUI_Cost_9433 : RscText
        {
            idc = -1; x = "safeZoneX + safeZoneW * 0.497"; y = "safeZoneY + safeZoneH * 0.246";
            w = "safeZoneW * 0.181"; h = "safeZoneH * 0.016"; text = "8 CP";
            sizeEx = 0.017; style = 1; colorBackground[] = {0,0,0,0}; colorText[] = {0.55, 0.62, 0.45, 0.80};
        };
        class OSF_UpUI_Cost_9443 : RscText
        {
            idc = -1; x = "safeZoneX + safeZoneW * 0.692"; y = "safeZoneY + safeZoneH * 0.246";
            w = "safeZoneW * 0.181"; h = "safeZoneH * 0.016"; text = "8 CP";
            sizeEx = 0.017; style = 1; colorBackground[] = {0,0,0,0}; colorText[] = {0.55, 0.62, 0.45, 0.80};
        };

        // ── Row 2 — Tier 6CP ──────────────────────────────────────────────

        class OSF_UpUI_Node_9412 : RscButton
        {
            idc = 9412;
            x = "safeZoneX + safeZoneW * 0.107";
            y = "safeZoneY + safeZoneH * 0.270";
            w = "safeZoneW * 0.181";
            h = "safeZoneH * 0.068";
            text = "QRF — PLAYER LOCATION";
            sizeEx = 0.020;
            colorBackground[] = {0.06, 0.08, 0.06, 1.0};
            colorText[] = {0.30, 0.36, 0.26, 1.0};
            colorActive[] = {0.08, 0.12, 0.06, 1.0};
            action = "";
        };
        class OSF_UpUI_Node_9422 : RscButton
        {
            idc = 9422;
            x = "safeZoneX + safeZoneW * 0.302";
            y = "safeZoneY + safeZoneH * 0.270";
            w = "safeZoneW * 0.181";
            h = "safeZoneH * 0.068";
            text = "TECHNICALS";
            sizeEx = 0.022;
            colorBackground[] = {0.06, 0.08, 0.06, 1.0};
            colorText[] = {0.30, 0.36, 0.26, 1.0};
            colorActive[] = {0.08, 0.12, 0.06, 1.0};
            action = "";
        };
        class OSF_UpUI_Node_9432 : RscButton
        {
            idc = 9432;
            x = "safeZoneX + safeZoneW * 0.497";
            y = "safeZoneY + safeZoneH * 0.270";
            w = "safeZoneW * 0.181";
            h = "safeZoneH * 0.068";
            text = "FARP";
            sizeEx = 0.022;
            colorBackground[] = {0.06, 0.08, 0.06, 1.0};
            colorText[] = {0.30, 0.36, 0.26, 1.0};
            colorActive[] = {0.08, 0.12, 0.06, 1.0};
            action = "";
        };
        class OSF_UpUI_Node_9442 : RscButton
        {
            idc = 9442;
            x = "safeZoneX + safeZoneW * 0.692";
            y = "safeZoneY + safeZoneH * 0.270";
            w = "safeZoneW * 0.181";
            h = "safeZoneH * 0.068";
            text = "AT DEFENCE";
            sizeEx = 0.022;
            colorBackground[] = {0.06, 0.08, 0.06, 1.0};
            colorText[] = {0.30, 0.36, 0.26, 1.0};
            colorActive[] = {0.08, 0.12, 0.06, 1.0};
            action = "";
        };
        // Cost labels — Tier 6CP
        class OSF_UpUI_Cost_9412 : RscText
        {
            idc = -1; x = "safeZoneX + safeZoneW * 0.107"; y = "safeZoneY + safeZoneH * 0.340";
            w = "safeZoneW * 0.181"; h = "safeZoneH * 0.016"; text = "6 CP";
            sizeEx = 0.017; style = 1; colorBackground[] = {0,0,0,0}; colorText[] = {0.55, 0.62, 0.45, 0.80};
        };
        class OSF_UpUI_Cost_9422 : RscText
        {
            idc = -1; x = "safeZoneX + safeZoneW * 0.302"; y = "safeZoneY + safeZoneH * 0.340";
            w = "safeZoneW * 0.181"; h = "safeZoneH * 0.016"; text = "6 CP";
            sizeEx = 0.017; style = 1; colorBackground[] = {0,0,0,0}; colorText[] = {0.55, 0.62, 0.45, 0.80};
        };
        class OSF_UpUI_Cost_9432 : RscText
        {
            idc = -1; x = "safeZoneX + safeZoneW * 0.497"; y = "safeZoneY + safeZoneH * 0.340";
            w = "safeZoneW * 0.181"; h = "safeZoneH * 0.016"; text = "6 CP";
            sizeEx = 0.017; style = 1; colorBackground[] = {0,0,0,0}; colorText[] = {0.55, 0.62, 0.45, 0.80};
        };
        class OSF_UpUI_Cost_9442 : RscText
        {
            idc = -1; x = "safeZoneX + safeZoneW * 0.692"; y = "safeZoneY + safeZoneH * 0.340";
            w = "safeZoneW * 0.181"; h = "safeZoneH * 0.016"; text = "6 CP";
            sizeEx = 0.017; style = 1; colorBackground[] = {0,0,0,0}; colorText[] = {0.55, 0.62, 0.45, 0.80};
        };

        // ── Row 3 — Tier 4CP ──────────────────────────────────────────────

        class OSF_UpUI_Node_9411 : RscButton
        {
            idc = 9411;
            x = "safeZoneX + safeZoneW * 0.107";
            y = "safeZoneY + safeZoneH * 0.364";
            w = "safeZoneW * 0.181";
            h = "safeZoneH * 0.068";
            text = "TRANSPORT DROPOFF";
            sizeEx = 0.022;
            colorBackground[] = {0.06, 0.08, 0.06, 1.0};
            colorText[] = {0.30, 0.36, 0.26, 1.0};
            colorActive[] = {0.08, 0.12, 0.06, 1.0};
            action = "";
        };
        class OSF_UpUI_Node_9421 : RscButton
        {
            idc = 9421;
            x = "safeZoneX + safeZoneW * 0.302";
            y = "safeZoneY + safeZoneH * 0.364";
            w = "safeZoneW * 0.181";
            h = "safeZoneH * 0.068";
            text = "SUPPORT WEAPONS";
            sizeEx = 0.022;
            colorBackground[] = {0.06, 0.08, 0.06, 1.0};
            colorText[] = {0.30, 0.36, 0.26, 1.0};
            colorActive[] = {0.08, 0.12, 0.06, 1.0};
            action = "";
        };
        class OSF_UpUI_Node_9431 : RscButton
        {
            idc = 9431;
            x = "safeZoneX + safeZoneW * 0.497";
            y = "safeZoneY + safeZoneH * 0.364";
            w = "safeZoneW * 0.181";
            h = "safeZoneH * 0.068";
            text = "AOB";
            sizeEx = 0.022;
            colorBackground[] = {0.06, 0.08, 0.06, 1.0};
            colorText[] = {0.30, 0.36, 0.26, 1.0};
            colorActive[] = {0.08, 0.12, 0.06, 1.0};
            action = "";
        };
        class OSF_UpUI_Node_9441 : RscButton
        {
            idc = 9441;
            x = "safeZoneX + safeZoneW * 0.692";
            y = "safeZoneY + safeZoneH * 0.364";
            w = "safeZoneW * 0.181";
            h = "safeZoneH * 0.068";
            text = "ROAD PATROLS";
            sizeEx = 0.022;
            colorBackground[] = {0.06, 0.08, 0.06, 1.0};
            colorText[] = {0.30, 0.36, 0.26, 1.0};
            colorActive[] = {0.08, 0.12, 0.06, 1.0};
            action = "";
        };
        // Cost labels — Tier 4CP
        class OSF_UpUI_Cost_9411 : RscText
        {
            idc = -1; x = "safeZoneX + safeZoneW * 0.107"; y = "safeZoneY + safeZoneH * 0.434";
            w = "safeZoneW * 0.181"; h = "safeZoneH * 0.016"; text = "4 CP";
            sizeEx = 0.017; style = 1; colorBackground[] = {0,0,0,0}; colorText[] = {0.55, 0.62, 0.45, 0.80};
        };
        class OSF_UpUI_Cost_9421 : RscText
        {
            idc = -1; x = "safeZoneX + safeZoneW * 0.302"; y = "safeZoneY + safeZoneH * 0.434";
            w = "safeZoneW * 0.181"; h = "safeZoneH * 0.016"; text = "4 CP";
            sizeEx = 0.017; style = 1; colorBackground[] = {0,0,0,0}; colorText[] = {0.55, 0.62, 0.45, 0.80};
        };
        class OSF_UpUI_Cost_9431 : RscText
        {
            idc = -1; x = "safeZoneX + safeZoneW * 0.497"; y = "safeZoneY + safeZoneH * 0.434";
            w = "safeZoneW * 0.181"; h = "safeZoneH * 0.016"; text = "4 CP";
            sizeEx = 0.017; style = 1; colorBackground[] = {0,0,0,0}; colorText[] = {0.55, 0.62, 0.45, 0.80};
        };
        class OSF_UpUI_Cost_9441 : RscText
        {
            idc = -1; x = "safeZoneX + safeZoneW * 0.692"; y = "safeZoneY + safeZoneH * 0.434";
            w = "safeZoneW * 0.181"; h = "safeZoneH * 0.016"; text = "4 CP";
            sizeEx = 0.017; style = 1; colorBackground[] = {0,0,0,0}; colorText[] = {0.55, 0.62, 0.45, 0.80};
        };

        // ── Row 4 — Tier 2CP (bottom) ─────────────────────────────────────

        class OSF_UpUI_Node_9410 : RscButton
        {
            idc = 9410;
            x = "safeZoneX + safeZoneW * 0.107";
            y = "safeZoneY + safeZoneH * 0.458";
            w = "safeZoneW * 0.181";
            h = "safeZoneH * 0.068";
            text = "AMMO SUPPLY AT TOC";
            sizeEx = 0.022;
            colorBackground[] = {0.06, 0.08, 0.06, 1.0};
            colorText[] = {0.30, 0.36, 0.26, 1.0};
            colorActive[] = {0.08, 0.12, 0.06, 1.0};
            action = "";
        };
        class OSF_UpUI_Node_9420 : RscButton
        {
            idc = 9420;
            x = "safeZoneX + safeZoneW * 0.302";
            y = "safeZoneY + safeZoneH * 0.458";
            w = "safeZoneW * 0.181";
            h = "safeZoneH * 0.068";
            text = "SMALL ARMS";
            sizeEx = 0.022;
            colorBackground[] = {0.06, 0.08, 0.06, 1.0};
            colorText[] = {0.30, 0.36, 0.26, 1.0};
            colorActive[] = {0.08, 0.12, 0.06, 1.0};
            action = "";
        };
        class OSF_UpUI_Node_9430 : RscButton
        {
            idc = 9430;
            x = "safeZoneX + safeZoneW * 0.497";
            y = "safeZoneY + safeZoneH * 0.458";
            w = "safeZoneW * 0.181";
            h = "safeZoneH * 0.068";
            text = "F.O.B";
            sizeEx = 0.022;
            colorBackground[] = {0.06, 0.08, 0.06, 1.0};
            colorText[] = {0.30, 0.36, 0.26, 1.0};
            colorActive[] = {0.08, 0.12, 0.06, 1.0};
            action = "";
        };
        class OSF_UpUI_Node_9440 : RscButton
        {
            idc = 9440;
            x = "safeZoneX + safeZoneW * 0.692";
            y = "safeZoneY + safeZoneH * 0.458";
            w = "safeZoneW * 0.181";
            h = "safeZoneH * 0.068";
            text = "ROADBLOCKS";
            sizeEx = 0.022;
            colorBackground[] = {0.06, 0.08, 0.06, 1.0};
            colorText[] = {0.30, 0.36, 0.26, 1.0};
            colorActive[] = {0.08, 0.12, 0.06, 1.0};
            action = "";
        };
        // Cost labels — Tier 2CP
        class OSF_UpUI_Cost_9410 : RscText
        {
            idc = -1; x = "safeZoneX + safeZoneW * 0.107"; y = "safeZoneY + safeZoneH * 0.528";
            w = "safeZoneW * 0.181"; h = "safeZoneH * 0.016"; text = "2 CP";
            sizeEx = 0.017; style = 1; colorBackground[] = {0,0,0,0}; colorText[] = {0.55, 0.62, 0.45, 0.80};
        };
        class OSF_UpUI_Cost_9420 : RscText
        {
            idc = -1; x = "safeZoneX + safeZoneW * 0.302"; y = "safeZoneY + safeZoneH * 0.528";
            w = "safeZoneW * 0.181"; h = "safeZoneH * 0.016"; text = "2 CP";
            sizeEx = 0.017; style = 1; colorBackground[] = {0,0,0,0}; colorText[] = {0.55, 0.62, 0.45, 0.80};
        };
        class OSF_UpUI_Cost_9430 : RscText
        {
            idc = -1; x = "safeZoneX + safeZoneW * 0.497"; y = "safeZoneY + safeZoneH * 0.528";
            w = "safeZoneW * 0.181"; h = "safeZoneH * 0.016"; text = "2 CP";
            sizeEx = 0.017; style = 1; colorBackground[] = {0,0,0,0}; colorText[] = {0.55, 0.62, 0.45, 0.80};
        };
        class OSF_UpUI_Cost_9440 : RscText
        {
            idc = -1; x = "safeZoneX + safeZoneW * 0.692"; y = "safeZoneY + safeZoneH * 0.528";
            w = "safeZoneW * 0.181"; h = "safeZoneH * 0.016"; text = "2 CP";
            sizeEx = 0.017; style = 1; colorBackground[] = {0,0,0,0}; colorText[] = {0.55, 0.62, 0.45, 0.80};
        };

        // ── Bottom section ────────────────────────────────────────────────

        class OSF_UpUI_Sep3 : RscText
        {
            idc = -1;
            x = "safeZoneX + safeZoneW * 0.105";
            y = "safeZoneY + safeZoneH * 0.552";
            w = "safeZoneW * 0.690";
            h = "safeZoneH * 0.002";
            text = "";
            colorBackground[] = {0.95, 0.78, 0.30, 0.85};
        };
        // IDC 9401 — description updated on button click by fn_tocMilitiaUI
        class OSF_UpUI_NodeDesc : RscText
        {
            idc = 9401;
            x = "safeZoneX + safeZoneW * 0.105";
            y = "safeZoneY + safeZoneH * 0.557";
            w = "safeZoneW * 0.690";
            h = "safeZoneH * 0.055";
            text = "Select an upgrade to view details.";
            sizeEx = 0.023;
            colorBackground[] = {0, 0, 0, 0};
            colorText[] = {0.55, 0.62, 0.48, 0.80};
        };
        class OSF_UpUI_Sep4 : RscText
        {
            idc = -1;
            x = "safeZoneX + safeZoneW * 0.105";
            y = "safeZoneY + safeZoneH * 0.615";
            w = "safeZoneW * 0.690";
            h = "safeZoneH * 0.002";
            text = "";
            colorBackground[] = {0.28, 0.40, 0.20, 0.70};
        };
        class OSF_UpUI_BtnSave : RscButton
        {
            idc = 9403;
            x = "safeZoneX + safeZoneW * 0.750";
            y = "safeZoneY + safeZoneH * 0.620";
            w = "safeZoneW * 0.065";
            h = "safeZoneH * 0.034";
            text = "SAVE";
            colorBackground[] = {0.10, 0.18, 0.35, 1.0};
            action = "";
        };
        class OSF_UpUI_BtnClose : RscButton
        {
            idc = 9402;
            x = "safeZoneX + safeZoneW * 0.825";
            y = "safeZoneY + safeZoneH * 0.620";
            w = "safeZoneW * 0.065";
            h = "safeZoneH * 0.034";
            text = "CLOSE";
            action = "";
        };
    };
};
