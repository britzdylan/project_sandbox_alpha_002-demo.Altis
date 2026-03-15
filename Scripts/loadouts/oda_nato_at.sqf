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
_x addPrimaryWeaponItem "ef_optic_Holosight_coy";
_x addPrimaryWeaponItem "30Rnd_556x45_Stanag_Sand";
_x addWeapon "launch_MRAWS_sand_F";
_x addSecondaryWeaponItem "MRAWS_HEAT55_F";

comment "Add containers";
_x forceAddUniform "U_B_CombatUniform_mcam_tshirt";
_x addVest "Aegis_V_CarrierRigKBT_01_tac_cbr_F";
_x addBackpack "B_Kitbag_mcamo";

comment "Add items to containers";
_x addItemToVest "FirstAidKit";
for "_i" from 1 to 8 do {
	_x addItemToVest "30Rnd_556x45_AP_Stanag_green_Tan_RF";
};
for "_i" from 1 to 2 do {
	_x addItemToBackpack "FirstAidKit";
};
for "_i" from 1 to 2 do {
	_x addItemToBackpack "dmpMRE";
};
_x addItemToBackpack "dmpWallet";
for "_i" from 1 to 2 do {
	_x addItemToBackpack "dmpBottleFull";
};
for "_i" from 1 to 3 do {
	_x addItemToBackpack "MRAWS_HEAT55_F";
};
_x addHeadgear "Aegis_H_Helmet_FASTMT_Headset_cbr_F";
_x addGoggles "G_Shemag_tan";

comment "Add items";
_x linkItem "ItemMap";
_x linkItem "ItemCompass";
_x linkItem "ItemWatch";
_x linkItem "ItemRadio";
_x linkItem "ItemGPS";
_x linkItem "NVGoggles";