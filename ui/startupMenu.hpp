// ============================================================
// ui/startupMenu.hpp
// OSF_StartupMenu — Mission Start Screen
// IDD 9003
//
// IDC reference:
//   9500 — Title text
//   9501 — Subtitle / tagline
//   9502 — Continue button (disabled when no save)
//   9503 — New Game button
//   9504 — Save status label (shows "Save found" or "No save data")
//
// Logic wired in Functions/core/fn_startupMenu.sqf
// ============================================================

class OSF_StartupMenu
{
    idd = 9003;
    movingEnable = false;
    enableSimulation = false;
    onLoad = "";
    onUnload = "";

    class controlsBackground
    {
        // Full-screen dark overlay
        class BG_Overlay : RscText
        {
            idc = -1;
            x = "safeZoneX";
            y = "safeZoneY";
            w = "safeZoneW";
            h = "safeZoneH";
            text = "";
            colorBackground[] = {0.02, 0.03, 0.02, 0.95};
        };

        // Center panel
        class BG_Panel : RscText
        {
            idc = -1;
            x = "safeZoneX + safeZoneW * 0.30";
            y = "safeZoneY + safeZoneH * 0.20";
            w = "safeZoneW * 0.40";
            h = "safeZoneH * 0.55";
            text = "";
            colorBackground[] = {0.04, 0.05, 0.04, 0.98};
        };

        // Header accent strip
        class BG_Header : RscText
        {
            idc = -1;
            x = "safeZoneX + safeZoneW * 0.30";
            y = "safeZoneY + safeZoneH * 0.20";
            w = "safeZoneW * 0.40";
            h = "safeZoneH * 0.08";
            text = "";
            colorBackground[] = {0.06, 0.10, 0.06, 1.0};
        };
    };

    class controls
    {
        // ── Title ──────────────────────────────────────────
        class Title : RscText
        {
            idc = 9500;
            x = "safeZoneX + safeZoneW * 0.31";
            y = "safeZoneY + safeZoneH * 0.215";
            w = "safeZoneW * 0.38";
            h = "safeZoneH * 0.04";
            text = "OPERATION SOVEREIGN FURY";
            sizeEx = 0.05;
            colorBackground[] = {0, 0, 0, 0};
            colorText[] = {0.62, 0.80, 0.42, 1.0};
        };

        // ── Subtitle ──────────────────────────────────────
        class Subtitle : RscText
        {
            idc = 9501;
            x = "safeZoneX + safeZoneW * 0.31";
            y = "safeZoneY + safeZoneH * 0.255";
            w = "safeZoneW * 0.38";
            h = "safeZoneH * 0.02";
            text = "Green Beret ODA — Unconventional Warfare Campaign";
            sizeEx = 0.04;
            colorBackground[] = {0, 0, 0, 0};
            colorText[] = {0.95, 0.78, 0.30, 1.0};
        };

        // ── Separator ─────────────────────────────────────
        class Sep1 : RscText
        {
            idc = -1;
            x = "safeZoneX + safeZoneW * 0.31";
            y = "safeZoneY + safeZoneH * 0.29";
            w = "safeZoneW * 0.38";
            h = "safeZoneH * 0.002";
            text = "";
            colorBackground[] = {0.95, 0.78, 0.30, 0.85};
        };

        // ── Continue button ───────────────────────────────
        class BtnContinue : RscButton
        {
            idc = 9502;
            x = "safeZoneX + safeZoneW * 0.36";
            y = "safeZoneY + safeZoneH * 0.36";
            w = "safeZoneW * 0.28";
            h = "safeZoneH * 0.06";
            text = "CONTINUE";
            sizeEx = 0.032;
            colorBackground[] = {0.10, 0.30, 0.10, 1.0};
            colorFocused[] = {0.15, 0.40, 0.15, 1.0};
            colorBackgroundActive[] = {0.15, 0.40, 0.15, 1.0};
            action = "";
        };

        // ── New Game button ───────────────────────────────
        class BtnNewGame : RscButton
        {
            idc = 9503;
            x = "safeZoneX + safeZoneW * 0.36";
            y = "safeZoneY + safeZoneH * 0.45";
            w = "safeZoneW * 0.28";
            h = "safeZoneH * 0.06";
            text = "NEW GAME";
            sizeEx = 0.032;
            colorBackground[] = {0.25, 0.18, 0.05, 1.0};
            colorFocused[] = {0.35, 0.25, 0.08, 1.0};
            colorBackgroundActive[] = {0.35, 0.25, 0.08, 1.0};
            action = "";
        };

        // ── Save status label ─────────────────────────────
        class SaveStatus : RscText
        {
            idc = 9504;
            x = "safeZoneX + safeZoneW * 0.36";
            y = "safeZoneY + safeZoneH * 0.54";
            w = "safeZoneW * 0.28";
            h = "safeZoneH * 0.025";
            text = "";
            sizeEx = 0.03;
            style = 2;
            colorBackground[] = {0, 0, 0, 0};
            colorText[] = {0.60, 0.65, 0.55, 0.8};
        };

        // ── Classification stamp ──────────────────────────
        class Classification : RscText
        {
            idc = -1;
            x = "safeZoneX + safeZoneW * 0.56";
            y = "safeZoneY + safeZoneH * 0.68";
            w = "safeZoneW * 0.14";
            h = "safeZoneH * 0.02";
            text = "CLASSIFIED // OSF";
            sizeEx = 0.03;
            style = 1;
            colorBackground[] = {0, 0, 0, 0};
            colorText[] = {0.88, 0.22, 0.22, 0.6};
        };
    };
};
