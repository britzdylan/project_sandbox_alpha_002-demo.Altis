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
_x addWeapon "LMG_Mk200_F";
_x addPrimaryWeaponItem "Aegis_optic_1p87_snd";
_x addPrimaryWeaponItem "200Rnd_65x39_cased_Box_Tracer";

comment "Add containers";
_x forceAddUniform "U_BG_Guerrilla_6_1";
_x addVest "Aegis_V_CarrierRigKBT_01_recon_olive_F";

comment "Add binoculars";
_x addWeapon "Binocular";

comment "Add items to containers";
for "_i" from 1 to 2 do {
	_x addItemToVest "FirstAidKit";
};
for "_i" from 1 to 2 do {
	_x addItemToVest "200Rnd_65x39_cased_Box_Tracer";
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