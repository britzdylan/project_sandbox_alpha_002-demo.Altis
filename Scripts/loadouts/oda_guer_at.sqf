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
_x addWeapon "arifle_TRG21_F";
_x addPrimaryWeaponItem "Aegis_optic_1p87_snd";
_x addPrimaryWeaponItem "30Rnd_556x45_Stanag_red";
_x addWeapon "Aegis_launch_RPG7M_F";
_x addSecondaryWeaponItem "PSRL1_HEAT_RF";

comment "Add containers";
_x forceAddUniform "U_I_G_Story_Protagonist_F";
_x addVest "Aegis_V_CarrierRigKBT_01_recon_olive_F";
_x addBackpack "B_AssaultPack_blk";

comment "Add items to containers";
_x addItemToVest "FirstAidKit";
for "_i" from 1 to 6 do {
	_x addItemToVest "30Rnd_556x45_Stanag_red";
};
_x addItemToBackpack "PSRL1_HEAT_RF";
_x addHeadgear "Aegis_H_Helmet_FASTMT_Headset_cbr_F";
_x addGoggles "G_Shemag_oli";

comment "Add items";
_x linkItem "ItemMap";
_x linkItem "ItemCompass";
_x linkItem "ItemWatch";
_x linkItem "ItemRadio";
_x linkItem "ItemGPS";
_x linkItem "NVGoggles";