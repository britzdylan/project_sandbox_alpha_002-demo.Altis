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
_x addWeapon "Aegis_arifle_AKM74_sand_F";
_x addPrimaryWeaponItem "Aegis_optic_1p87_snd";
_x addPrimaryWeaponItem "30Rnd_545x39_Mag_Sand_Green_F";

comment "Add containers";
_x forceAddUniform "U_BG_Guerilla2_3";
_x addVest "Aegis_V_CarrierRigKBT_01_recon_cbr_F";

comment "Add items to containers";
_x addItemToVest "FirstAidKit";
for "_i" from 1 to 5 do {
	_x addItemToVest "30Rnd_545x39_Mag_Sand_Green_F";
};
for "_i" from 1 to 3 do {
	_x addItemToVest "DemoCharge_Remote_Mag";
};
_x addHeadgear "Aegis_H_Helmet_FASTMT_Headset_cbr_F";
_x addGoggles "G_Bandanna_oli";

comment "Add items";
_x linkItem "ItemMap";
_x linkItem "ItemCompass";
_x linkItem "ItemWatch";
_x linkItem "ItemRadio";
_x linkItem "ItemGPS";
_x linkItem "NVGoggles";