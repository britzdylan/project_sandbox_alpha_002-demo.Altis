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
_x addWeapon "Aegis_arifle_AKM74_GL_plum_F";
_x addPrimaryWeaponItem "Aegis_optic_1p87_snd";
_x addPrimaryWeaponItem "30Rnd_545x39_Mag_Green_F";
_x addPrimaryWeaponItem "1Rnd_HE_Grenade_shell";

comment "Add containers";
_x forceAddUniform "U_I_C_Soldier_Para_1_F";
_x addVest "V_CarrierRigKBT_01_heavy_Coyote_F";

comment "Add binoculars";
_x addWeapon "Binocular";

comment "Add items to containers";
_x addItemToVest "FirstAidKit";
for "_i" from 1 to 6 do {
	_x addItemToVest "1Rnd_HE_Grenade_shell";
};
for "_i" from 1 to 8 do {
	_x addItemToVest "30Rnd_545x39_Mag_Green_F";
};
for "_i" from 1 to 3 do {
	_x addItemToVest "1Rnd_Smoke_Grenade_shell";
};
_x addHeadgear "Aegis_H_Helmet_FASTMT_Headset_cbr_F";
_x addGoggles "G_Combat";

comment "Add items";
_x linkItem "ItemMap";
_x linkItem "ItemCompass";
_x linkItem "ItemWatch";
_x linkItem "ItemRadio";
_x linkItem "ItemGPS";
_x linkItem "NVGoggles";