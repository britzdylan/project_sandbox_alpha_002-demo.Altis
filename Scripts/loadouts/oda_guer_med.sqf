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
_x addWeapon "Aegis_arifle_AKM74_olive_F";
_x addPrimaryWeaponItem "Aegis_optic_1p87_lush";
_x addPrimaryWeaponItem "30Rnd_545x39_Mag_Olive_F";

comment "Add containers";
_x forceAddUniform "U_I_L_Uniform_01_tshirt_black_F";
_x addVest "Aegis_V_CarrierRigKBT_01_recon_mtp_F";
_x addBackpack "B_AssaultPack_cbr";

comment "Add items to containers";
_x addItemToVest "SmokeShell";
for "_i" from 1 to 8 do {
	_x addItemToVest "30Rnd_545x39_Mag_Olive_F";
};
_x addItemToBackpack "Medikit";
for "_i" from 1 to 5 do {
	_x addItemToBackpack "FirstAidKit";
};
_x addHeadgear "Aegis_H_Helmet_FASTMT_Headset_tan_F";
_x addGoggles "Aegis_G_Condor_EyePro_F";

comment "Add items";
_x linkItem "ItemMap";
_x linkItem "ItemCompass";
_x linkItem "ItemWatch";
_x linkItem "ItemRadio";
_x linkItem "ItemGPS";
_x linkItem "NVGoggles";