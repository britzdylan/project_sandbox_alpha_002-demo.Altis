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
_x addWeapon "Aegis_arifle_SPAR_02_inf_snd_F";
_x addPrimaryWeaponItem "Aegis_acc_pointer_DM_Arid";
_x addPrimaryWeaponItem "Aegis_optic_ACOG_sand";
_x addPrimaryWeaponItem "30Rnd_556x45_AP_Stanag_green_Tan_RF";
_x addWeapon "hgun_G17_F";
_x addHandgunItem "17Rnd_9x21_Mag";

comment "Add containers";
_x forceAddUniform "U_B_CombatUniform_mcam_vest";
_x addVest "V_PlateCarrierSpec_rgr";
_x addBackpack "B_Kitbag_mcamo";

comment "Add binoculars";
_x addWeapon "Binocular";

comment "Add items to containers";
_x addItemToVest "FirstAidKit";
for "_i" from 1 to 2 do {
	_x addItemToVest "17Rnd_9x21_Mag";
};
for "_i" from 1 to 8 do {
	_x addItemToVest "30Rnd_556x45_AP_Stanag_green_Tan_RF";
};
_x addItemToVest "HandGrenade";
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
for "_i" from 1 to 4 do {
	_x addItemToBackpack "30Rnd_556x45_AP_Stanag_green_Tan_RF";
};
_x addItemToBackpack "17Rnd_9x21_Mag";
for "_i" from 1 to 4 do {
	_x addItemToBackpack "SmokeShell";
};
for "_i" from 1 to 4 do {
	_x addItemToBackpack "HandGrenade";
};
_x addHeadgear "Aegis_H_Helmet_FASTMT_Headset_rgr_F";
_x addGoggles "G_Shemag_tactical";

comment "Add items";
_x linkItem "ItemMap";
_x linkItem "ItemCompass";
_x linkItem "ItemWatch";
_x linkItem "ItemRadio";
_x linkItem "ItemGPS";
_x linkItem "NVGoggles";