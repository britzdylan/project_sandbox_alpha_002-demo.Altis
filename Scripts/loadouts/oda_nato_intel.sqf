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

comment "Add containers";
_x forceAddUniform "U_B_CombatUniform_mcam";
_x addVest "V_PlateCarrier2_rgr";
_x addBackpack "B_UAV_01_backpack_F";

comment "Add items to containers";
_x addItemToVest "FirstAidKit";
for "_i" from 1 to 8 do {
	_x addItemToVest "30Rnd_556x45_AP_Stanag_green_Tan_RF";
};
for "_i" from 1 to 3 do {
	_x addItemToVest "B_IR_Grenade";
};
_x addItemToVest "Aegis_SignalFlare_Green";
for "_i" from 1 to 4 do {
	_x addItemToVest "Chemlight_blue";
};
_x addHeadgear "Aegis_H_Helmet_FASTMT_Headset_blk_F";

comment "Add items";
_x linkItem "ItemMap";
_x linkItem "ItemCompass";
_x linkItem "ItemWatch";
_x linkItem "ItemRadio";
_x linkItem "ItemGPS";
_x linkItem "NVGoggles";