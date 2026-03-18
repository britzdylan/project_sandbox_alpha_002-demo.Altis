params ["_container"];

if !(local _container) exitWith {};

clearWeaponCargoGlobal _container;
clearMagazineCargoGlobal _container;
clearItemCargoGlobal _container;
clearBackpackCargoGlobal _container;

{
	_container addWeaponCargoGlobal _x;
} forEach [["arifle_TRG21_F", 1], ["LMG_Mk200_F", 1], ["srifle_DMR_06_hunter_F", 1], ["Aegis_launch_RPG7M_F", 2]];

{
	_container addMagazineCargoGlobal _x;
} forEach [["30Rnd_556x45_Stanag_red", 51], ["200Rnd_65x39_cased_Box_Tracer_Red", 32], ["20Rnd_762x51_Mag", 23], ["PSRL1_HE_RF", 8], ["PSRL1_FRAG_RF", 8], ["Chemlight_green", 25], ["HandGrenade", 44], ["UGL_FlareGreen_Illumination_F", 15], ["SmokeShell", 39], ["1Rnd_Smoke_Grenade_shell", 30], ["1Rnd_HE_Grenade_shell", 39], ["APERSBoundingMine_Range_Mag", 4], ["APERSMineDispenser_Mag", 1], ["APERSTripMine_Wire_Mag", 4], ["ClaymoreDirectionalMine_Remote_Mag", 9], ["IEDLandSmall_Remote_Mag", 9], ["Laserbatteries", 3]];

{
	_container addItemCargoGlobal _x;
} forEach [["optic_Holosight", 2], ["acc_flashlight", 1], ["optic_DMS_weathered_F", 1], ["Aegis_optic_1p87_snd", 2], ["G_Bandanna_blk", 1], ["G_Bandanna_khk", 1], ["G_Bandanna_oli", 1], ["H_Bandanna_mcamo_hs", 1], ["H_Booniehat_mgrn_hs", 1], ["Aegis_V_CarrierRigKBT_01_recon_olive_F", 1], ["V_Chestrig_rgr", 1], ["U_B_CTRG_Soldier_Arid_F", 1], ["U_BG_Guerilla1_3", 1], ["U_BG_Guerilla2_3", 1], ["U_BG_Guerilla2_1", 1], ["U_BG_Guerilla2_2", 1], ["U_BG_Guerilla1_2_F", 1], ["Binocular", 1], ["ItemCompass", 1], ["FirstAidKit", 35], ["ItemGPS", 1], ["Laserdesignator_03", 1], ["ItemMap", 1], ["ItemRadio", 1], ["B_G_FIA_UavTerminal_lxWS", 1], ["ItemWatch", 1], ["dmpBandage", 50], ["dmpCanteenClean", 21], ["dmpMRE", 27]];

{
	_container addBackpackCargoGlobal _x;
} forEach [["B_Kitbag_khk", 2], ["B_CommandoMortar_weapon_RF", 1]];
