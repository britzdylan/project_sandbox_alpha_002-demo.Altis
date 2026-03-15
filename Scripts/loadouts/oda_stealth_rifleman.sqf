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
_x addWeapon "arifle_SPAR_01_snd_F";
_x addPrimaryWeaponItem "muzzle_snds_m_snd_F";
_x addPrimaryWeaponItem "Aegis_acc_pointer_DM_Sand";
_x addPrimaryWeaponItem "Aegis_optic_ACOG_sand";
_x addPrimaryWeaponItem "30Rnd_556x45_Stanag_Sand_red";

comment "Add containers";
_x forceAddUniform "U_B_CTRG_Soldier_3_Arid_F";
_x addVest "V_ChestrigF_rgr";

comment "Add binoculars";
_x addWeapon "Binocular";

comment "Add items to containers";
_x addItemToVest "FirstAidKit";
for "_i" from 1 to 3 do {
	_x addItemToVest "SmokeShell";
};
for "_i" from 1 to 4 do {
	_x addItemToVest "30Rnd_556x45_Stanag_Sand_red";
};
_x addHeadgear "H_Booniehat_oli";
_x addGoggles "G_Shemag_oli";

comment "Add items";
_x linkItem "ItemMap";
_x linkItem "ItemCompass";
_x linkItem "ItemWatch";
_x linkItem "ItemRadio";
_x linkItem "ItemGPS";
_x linkItem "NVGoggles";