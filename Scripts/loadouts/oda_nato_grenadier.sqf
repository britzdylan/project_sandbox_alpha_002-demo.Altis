params ["_x"];
comment "Exported from Arsenal by britz";

comment "[!] UNIT MUST BE LOCAL [!]";
if (!local _x) exitWith {};

comment "Remove existing items";
removeAllWeapons _x;
removeAllItems _x;
removeAllAssignedItems _x;
removeUniform _x;
removeVest _x;
removeBackpack _x;
removeHeadgear _x;
removeGoggles _x;

comment "Add weapons";
_x addWeapon "arifle_SPAR_01_GL_snd_F";
_x addPrimaryWeaponItem "Aegis_acc_pointer_DM_Arid";
_x addPrimaryWeaponItem "Aegis_optic_ACOG_sand";
_x addPrimaryWeaponItem "30Rnd_556x45_AP_Stanag_green_Tan_RF";
_x addPrimaryWeaponItem "1Rnd_HE_Grenade_shell";

comment "Add containers";
_x forceAddUniform "U_B_CombatUniform_mcam_vest";
_x addVest "V_PlateCarrierGL_mtp";
_x addBackpack "B_Kitbag_mcamo";

comment "Add items to containers";
for "_i" from 1 to 8 do {
	_x addItemToVest "30Rnd_556x45_AP_Stanag_green_Tan_RF";
};
for "_i" from 1 to 8 do {
	_x addItemToVest "1Rnd_HE_Grenade_shell";
};
for "_i" from 1 to 3 do {
	_x addItemToVest "1Rnd_Smoke_Grenade_shell";
};
for "_i" from 1 to 3 do {
	_x addItemToBackpack "FirstAidKit";
};
for "_i" from 1 to 2 do {
	_x addItemToBackpack "dmpMRE";
};
_x addItemToBackpack "dmpWallet";
for "_i" from 1 to 3 do {
	_x addItemToBackpack "dmpBottleFull";
};
for "_i" from 1 to 2 do {
	_x addItemToBackpack "dmpBandage";
};
for "_i" from 1 to 8 do {
	_x addItemToBackpack "1Rnd_HE_Grenade_shell";
};
for "_i" from 1 to 8 do {
	_x addItemToBackpack "30Rnd_556x45_AP_Stanag_green_Tan_RF";
};
for "_i" from 1 to 3 do {
	_x addItemToBackpack "1Rnd_Smoke_Grenade_shell";
};
_x addHeadgear "Aegis_H_Helmet_FASTMT_Headset_cbr_F";
_x addGoggles "G_Combat_Goggles_blk_F";

comment "Add items";
_x linkItem "ItemMap";
_x linkItem "ItemCompass";
_x linkItem "ItemWatch";
_x linkItem "ItemRadio";
_x linkItem "ItemGPS";
_x linkItem "NVGoggles";