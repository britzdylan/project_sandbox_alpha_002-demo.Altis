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
_x addWeapon "arifle_SPAR_03_snd_F";
_x addPrimaryWeaponItem "suppressor_h_sand_lxWS";
_x addPrimaryWeaponItem "Aegis_acc_pointer_DM_Sand";
_x addPrimaryWeaponItem "optic_DMS";
_x addPrimaryWeaponItem "20Rnd_762x51_Mag";
_x addPrimaryWeaponItem "bipod_01_F_snd";

comment "Add containers";
_x forceAddUniform "U_B_CTRG_Soldier_3_Arid_F";
_x addVest "V_ChestrigF_rgr";

comment "Add binoculars";
_x addWeapon "Binocular";

comment "Add items to containers";
_x addItemToUniform "optic_NVS";
for "_i" from 1 to 2 do {
	_x addItemToUniform "20Rnd_762x51_Mag";
};
_x addItemToVest "FirstAidKit";
for "_i" from 1 to 3 do {
	_x addItemToVest "SmokeShell";
};
_x addItemToVest "20Rnd_762x51_Mag";
_x addHeadgear "H_Booniehat_oli";
_x addGoggles "G_Shemag_oli";

comment "Add items";
_x linkItem "ItemMap";
_x linkItem "ItemCompass";
_x linkItem "ItemWatch";
_x linkItem "ItemRadio";
_x linkItem "ItemGPS";
_x linkItem "NVGoggles";