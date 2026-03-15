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
_x addWeapon "LMG_03_snd_F";
_x addPrimaryWeaponItem "optic_Holosight_blk_F";
_x addPrimaryWeaponItem "200Rnd_556x45_Box_Tracer_F";

comment "Add containers";
_x forceAddUniform "U_B_CombatUniform_mcam_vest";
_x addVest "V_PlateCarrierSpec_rgr";
_x addBackpack "B_Kitbag_mcamo";

comment "Add binoculars";
_x addWeapon "Binocular";

comment "Add items to containers";
_x addItemToVest "FirstAidKit";
_x addItemToVest "HandGrenade";
for "_i" from 1 to 2 do {
	_x addItemToVest "200Rnd_556x45_Box_Tracer_F";
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
for "_i" from 1 to 4 do {
	_x addItemToBackpack "SmokeShell";
};
for "_i" from 1 to 4 do {
	_x addItemToBackpack "HandGrenade";
};
for "_i" from 1 to 3 do {
	_x addItemToBackpack "200Rnd_556x45_Box_Tracer_F";
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