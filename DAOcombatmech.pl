#!/usr/bin/perl
use strict; use warnings;
#	DAOcombatmech by MOskar
#	To check how equipement and stats will affect combat mechanics in Dragon Age Origins
#	I took the combat mechanics from the Dragon Age Wiki http://dragonage.wikia.com/wiki/Combat_mechanics_(Origins)


die "Usage: DAOcombatmech.pl <STR 0> <DEX 1> <Cunning 2>
\n<Weapon Type 3 (dagger, longsword, mace, waraxe, crossbow, shortbow, longbow)> <BaseWeaponDmg 4> <AttackBonuses 5> <AP bonus 6> <OnHitDamage 7 (runes, poison...)>
\n<Armor protection 8> <DefenseBonuses 9> <CharacterDmgBonus 10 (Duelist, Aim...)> 
<AP bonus 11 (aim, master archer, etc)> <Speed modificator 12 (aim speed or attack duration modifier)>
<BaseWeapon2Dmg 13> <AttackBonuses2 14> <AP bonus2 15> <OnHitDamage2 16 (runes, poison...)> <Speed modificator2 17 (aim speed or attack duration modifier)>
<missile deflection bonusses 18>\n" unless @ARGV > 1;

my @stats = @ARGV;

# DefenseValue = 50 + (Dexterity - 10) + DefenseBonuses

my $DEX = $stats[1];
my $defbonus = $stats[9];
my $DV = ($DEX -10) + 50 + $defbonus;
my $armor = $stats[8];
my $armorprotec = (0.7 + (0.3 * 0.5) )* $armor;
my $meleedef = ($DV - 30) + 54;
my $deflect = $stats[18];
my $evasion = (50 + $deflect);

print "\nDefense (DefenseValue) is $DV\n";
print "probability of evade melee attack is $meleedef %\n";
print "probability of deflect ranged attacks is $evasion %\n";
print "Armor damage reduction value is $armorprotec\n\n";

# ArmorPenetration = (Cunning - 10) / 7
# AttackValue = 55 + 0.5 * {(STR - 10) + (DEX - 10)} + AttackBonuses
# Melee Attack Roll Probability = AV - DefenseValue(55) + 54%
# Ranged Attack Roll Probability = AV - MissileDeflection(20) + 54%

my $cunning = $stats[2];

my $STR = $stats[0];
my $atkbonus1 = $stats[5];
my $atkbonus2 = $stats[14];

my $AV1 = ((($STR - 10) + ($DEX - 10)) * 0.5) + 55 + $atkbonus1;
my $AV2 = ((($STR - 10) + ($DEX - 10)) * 0.5) + 55 + $atkbonus2;




# Melee Attack Duration = 1.5 + Weapon Speed Mod + CharacterSpeedMod(1)
# Ranged Attack Duration = 1.6 + Aim time

# Damage = BaseWeaponDmg + AttributeBasedDmg + CharacterDmgBonus + OnHitDamage - ArmorDmgReduction
# AttributeBaseDmg
 #	STR: AttrAttributeBasedDmg = [STR - 10] * [Weapon Attribute Modifier] * [Weapon Style Modifier]
 #	DEX+STR: AttributeBasedDmg = 0.5 * [STR + DEX - 20] * [Weapon Attribute Modifier] * [Weapon Style Modifier]
# Weapon Style Modifier = 0.375 main hand; 0.125 off hand (full 0.375 if Dual-Weapon Training)
# CharacterDmgBonus = 0.2 + other bonus(Accurancy, Aim Skill, duelist)
# OnHitDamage = runes, poison and other weapon special properties
# ArmorDmgReduction = 0.7 + (0.3 * 0.5) * armor - AP

my $chardmg = 0.2 + $stats[10];
my $weapon1 = $stats[3];
my $weapdmg1 = $stats[4];
my $weapdmg2 = $stats[13];
my $OnHitdmg1 = $stats[7];
my $OnHitdmg2 = $stats[16];
my $apbonusweap1 = $stats[6];
my $apbonusweap2 = $stats[15];
my $apcharbonus = $stats[11];
my $speedmod1 = $stats [12];
my $speedmod2 = $stats [17];


if ($weapon1 eq "shortbow") {  
   print "Attack Value (AV) is $AV1\n";
   my $rangeprob = ($AV1 - 40) + 54;
   print "Attack roll Probability is $rangeprob%\n";
   my $atkdur = 1.6 + 0.2 + $speedmod1;
   my $attribdmg = (((($STR + $DEX) - 30) * 0.5) * 1) * 0.625;
   my $AP = (($cunning - 10) / 7) + 3 + $apbonusweap1 + $apcharbonus;
   my $armdmgred = (0.7 + (0.3 * 0.5) * 10) - $AP;
   my $DMG = $weapdmg1 + $attribdmg + $chardmg + $OnHitdmg1 - $armdmgred;
   print "The time between attacks for $weapon1 is $atkdur s\n";
   print "Armor Penetration (AP) from $weapon1 is $AP\n";
   print "The Damage of the ranged weapon ($weapon1) is $DMG\n";
   my $DPS = $DMG / $atkdur;
   my $realATK = $DPS * ($rangeprob * 0.01);
   print "DPS total damage is $DPS\n";
   print "Approximate damage output will be $realATK\n";
}  

elsif ($weapon1 eq "longbow") {  
   print "Attack Value (AV) is $AV1\n";
   my $rangeprob = ($AV1 - 40) + 54;
   print "Attack roll Probability is $rangeprob\n";   
   my $atkdur = 1.6 + 0.3 + $speedmod1;
   my $attribdmg = (((($STR + $DEX) - 20) * 0.5) * 1) * 0.625;
   my $AP = (($cunning - 10) / 7) + 4 + $apbonusweap1 + $apcharbonus;
   my $armdmgred = (0.7 + (0.3 * 0.5) * 10) - $AP;
   my $DMG = $weapdmg1 + $attribdmg + $chardmg + $OnHitdmg1 - $armdmgred;
   print "The time between attacks for $weapon1 is $atkdur s\n";
   print "Armor Penetration (AP) from $weapon1 is $AP\n";
   print "The Damage of the ranged weapon ($weapon1) is $DMG\n";
   my $DPS = $DMG / $atkdur;
   my $realATK = $DPS * ($rangeprob * 0.01);
   print "DPS total damage is $DPS\n";
   print "Approximate damage output will be $realATK\n";
}  

elsif ($weapon1 eq "crossbow") {  
   print "Attack Value (AV) is $AV1\n";
   my $rangeprob = ($AV1 - 40) + 54;
   print "Attack roll Probability is $rangeprob\n";
   my $atkdur = 1.6 + 0.8 + $speedmod1;
   my $attribdmg = 0;
   my $AP = (($cunning - 10) / 7) + 5 + $apbonusweap1 + $apcharbonus;
   my $armdmgred = (0.7 + (0.3 * 0.5) * 10) - $AP;
   my $DMG = $weapdmg1 + $attribdmg + $chardmg + $OnHitdmg1 - $armdmgred;
   print "The time between attacks for $weapon1 is $atkdur s\n";
   print "Armor Penetration (AP) from $weapon1 is $AP\n";
   print "The Damage of the ranged weapon ($weapon1) is $DMG\n";
   my $DPS = $DMG / $atkdur;
   my $realATK = $DPS * ($rangeprob * 0.01);
   print "DPS total damage is $DPS\n";
   print "Approximate damage output will be $realATK\n";
}  

elsif ($weapon1 eq "dagger") {  
   print "Attack Value (AV) for $weapon1 is $AV1\n";
   my $meleeprob1 = ($AV1 - 50) + 54;
   print "Attack roll Probability is $meleeprob1 %\n";
   my $atkdur1 = ((1.5 - 0.5) * 1 ) + $speedmod1;
   my $attribdmg1 = (((($STR + $DEX) - 20) * 0.5) * 0.85) * 0.375;
   my $AP1 = (($cunning - 10) / 7) + 4 + $apbonusweap1 + $apcharbonus;
   my $prearmdmgred1 = (0.7 + (0.3 * 0.5) * 10) - $AP1;
   my $armdmgred1 = 0;
   if ($prearmdmgred1 <= 0) {$armdmgred1 = 0;} else {$armdmgred1 = $prearmdmgred1};
   my $DMG1 = $weapdmg1 + $attribdmg1 + $chardmg + $OnHitdmg1 - $armdmgred1;
   print "The attack duration is $atkdur1 s\n";  
   print "Armor Penetration (AP) from this $weapon1 is $AP1\n";
   print "The Damage of the first melee weapon ($weapon1) is $DMG1\n";
    #second weapon
   print "\nAttack Value (AV) for the second weapon (off-hand dagger) is $AV2\n";
   my $meleeprob2 = ($AV2 - 50) + 54;
   print "Attack roll Probability is $meleeprob2 %\n";
   my $averageprob = ($meleeprob1 + $meleeprob2) / 2;
   my $speedmod2 = $stats[17];
   my $atkdur2 = ((1.5 - 0.5) * 1 ) + $speedmod2;
   my $atktiming = ($atkdur1 + $atkdur2);
   my $attribdmg2 = (((($STR + $DEX) - 20) * 0.5) * 0.85) * 0.125;
   my $AP2 = (($cunning - 10) / 7) + 4 + $apbonusweap2 + $apcharbonus;
   my $prearmdmgred2 = (0.7 + (0.3 * 0.5) * 10) - $AP2;
   my $armdmgred2 = 0;
   if ($prearmdmgred2 <= 0) {$armdmgred2 = 0;} else {$armdmgred2 = $prearmdmgred2};
   my $DMG2 = $weapdmg2 + $attribdmg2 + $chardmg + $OnHitdmg2 - $armdmgred2;
   print "The attack duration is $atkdur2 s\n";  
   print "Armor Penetration (AP) from off-hand dagger is $AP2\n";
   print "Its Damage is $DMG2\n";
   my $DPS = ($DMG1 + $DMG2) / $atktiming;
   my $ATK1 = $DMG1 * ($meleeprob1 * 0.01);
   my $ATK2 = $DMG2 * ($meleeprob2 * 0.01);
   my $realATK = ($ATK1 + $ATK2) / $atktiming;
   print "\nThe average dual-wielding attack speed is " . $atktiming/2 ."s\n";
   print "The average Attack roll probability is $averageprob %\n";
   print "DPS total damage with both weapons is $DPS\n";
   print "Approximate total damage output will be $realATK\n";
}  

elsif ($weapon1 eq "longsword") {  
   print "Attack Value (AV) for $weapon1 is $AV1\n";
   my $meleeprob1 = ($AV1 - 50) + 54;
   print "Attack roll Probability is $meleeprob1 %\n";
   my $atkdur1 = ((1.5 - 0.1) * 1 ) + $speedmod1;
   my $attribdmg1 = (($STR - 10) * 0.5) * 1 * 0.375;
   my $AP1 = (($cunning - 10) / 7) + 2 + $apbonusweap1 + $apcharbonus;
   my $prearmdmgred1 = (0.7 + (0.3 * 0.5) * 10) - $AP1;
   my $armdmgred1 = 0;
   if ($prearmdmgred1 <= 0) {$armdmgred1 = 0;} else {$armdmgred1 = $prearmdmgred1};
   my $DMG1 = $weapdmg1 + $attribdmg1 + $chardmg + $OnHitdmg1 - $armdmgred1;
   print "The attack duration is $atkdur1 s\n";  
   print "Armor Penetration (AP) from this $weapon1 is $AP1\n";
   print "The Damage of the first melee weapon ($weapon1) is $DMG1\n";
     #second weapon
   print "\nAttack Value (AV) for the second weapon (off-hand dagger) is $AV2\n";
   my $meleeprob2 = ($AV2 - 50) + 54;
   print "Attack roll Probability is $meleeprob2 %\n";
   my $averageprob = ($meleeprob1 + $meleeprob2) / 2;
   my $speedmod2 = $stats[17];
   my $atkdur2 = ((1.5 - 0.5) * 1 ) + $speedmod2;
   my $atktiming = ($atkdur1 + $atkdur2);
   my $attribdmg2 = (((($STR + $DEX) - 20) * 0.5) * 0.85) * 0.125;
   my $AP2 = (($cunning - 10) / 7) + 4 + $apbonusweap2 + $apcharbonus;
   my $prearmdmgred2 = (0.7 + (0.3 * 0.5) * 10) - $AP2;
   my $armdmgred2 = 0;
   if ($prearmdmgred2 <= 0) {$armdmgred2 = 0;} else {$armdmgred2 = $prearmdmgred2};
   my $DMG2 = $weapdmg2 + $attribdmg2 + $chardmg + $OnHitdmg2 - $armdmgred2;
   print "The attack duration is $atkdur2 s\n";  
   print "Armor Penetration (AP) from off-hand dagger is $AP2\n";
   print "Its Damage is $DMG2\n";
   my $DPS = ($DMG1 + $DMG2) / $atktiming;
   my $ATK1 = $DMG1 * ($meleeprob1 * 0.01);
   my $ATK2 = $DMG2 * ($meleeprob2 * 0.01);
   my $realATK = ($ATK1 + $ATK2) / $atktiming;
   print "\nThe average dual-wielding attack speed is " . $atktiming/2 ."s\n";
   print "The average Attack roll probability is $averageprob %\n";
   print "DPS total damage with both weapons is $DPS\n";
   print "Approximate total damage output will be $realATK\n";
   }  

elsif ($weapon1 eq "mace") {  
   
print "Attack Value (AV) for $weapon1 is $AV1\n";
   my $meleeprob1 = ($AV1 - 50) + 54;
   print "Attack roll Probability is $meleeprob1 %\n";
   my $atkdur1 = ((1.5 - 0) * 1 ) + $speedmod1;
   my $attribdmg1 = (($STR - 10) * 0.5) * 1 * 0.375;
   my $AP1 = (($cunning - 10) / 7) + 4 + $apbonusweap1 + $apcharbonus;
   my $prearmdmgred1 = (0.7 + (0.3 * 0.5) * 10) - $AP1;
   my $armdmgred1 = 0;
   if ($prearmdmgred1 <= 0) {$armdmgred1 = 0;} else {$armdmgred1 = $prearmdmgred1};
   my $DMG1 = $weapdmg1 + $attribdmg1 + $chardmg + $OnHitdmg1 - $armdmgred1;
   print "The attack duration is $atkdur1 s\n";  
   print "Armor Penetration (AP) from this $weapon1 is $AP1\n";
   print "The Damage of the first melee weapon ($weapon1) is $DMG1\n";
     #second weapon
   print "\nAttack Value (AV) for the second weapon (off-hand dagger) is $AV2\n";
   my $meleeprob2 = ($AV2 - 50) + 54;
   print "Attack roll Probability is $meleeprob2 %\n";
   my $averageprob = ($meleeprob1 + $meleeprob2) / 2;
   my $speedmod2 = $stats[17];
   my $atkdur2 = ((1.5 - 0.5) * 1 ) + $speedmod2;
   my $atktiming = ($atkdur1 + $atkdur2);
   my $attribdmg2 = (((($STR + $DEX) - 20) * 0.5) * 0.85) * 0.125;
   my $AP2 = (($cunning - 10) / 7) + 4 + $apbonusweap2 + $apcharbonus;
   my $prearmdmgred2 = (0.7 + (0.3 * 0.5) * 10) - $AP2;
   my $armdmgred2 = 0;
   if ($prearmdmgred2 <= 0) {$armdmgred2 = 0;} else {$armdmgred2 = $prearmdmgred2};
   my $DMG2 = $weapdmg2 + $attribdmg2 + $chardmg + $OnHitdmg2 - $armdmgred2;
   print "The attack duration is $atkdur2 s\n";  
   print "Armor Penetration (AP) from off-hand dagger is $AP2\n";
   print "Its Damage is $DMG2\n";
   my $DPS = ($DMG1 + $DMG2) / $atktiming;
   my $ATK1 = $DMG1 * ($meleeprob1 * 0.01);
   my $ATK2 = $DMG2 * ($meleeprob2 * 0.01);
   my $realATK = ($ATK1 + $ATK2) / $atktiming;
   print "\nThe average dual-wielding attack speed is " . $atktiming/2 ."s\n";
   print "The average Attack roll probability is $averageprob %\n";
   print "DPS total damage with both weapons is $DPS\n";
   print "Approximate total damage output will be $realATK\n";   
}  

elsif ($weapon1 eq "waraxe") {  
   
print "Attack Value (AV) for $weapon1 is $AV1\n";
   my $meleeprob1 = ($AV1 - 50) + 54;
   print "Attack roll Probability is $meleeprob1 %\n";
   my $atkdur1 = ((1.5 - 0.1) * 1 ) + $speedmod1;
   my $attribdmg1 = (($STR - 10) * 0.5) * 1.1 * 0.375;
   my $AP1 = (($cunning - 10) / 7) + 2 + $apbonusweap1 + $apcharbonus;
   my $prearmdmgred1 = (0.7 + (0.3 * 0.5) * 10) - $AP1;
   my $armdmgred1 = 0;
   if ($prearmdmgred1 <= 0) {$armdmgred1 = 0;} else {$armdmgred1 = $prearmdmgred1};
   my $DMG1 = $weapdmg1 + $attribdmg1 + $chardmg + $OnHitdmg1 - $armdmgred1;
   print "The attack duration is $atkdur1 s\n";  
   print "Armor Penetration (AP) from this $weapon1 is $AP1\n";
   print "The Damage of the first melee weapon ($weapon1) is $DMG1\n";
     #second weapon
   print "\nAttack Value (AV) for the second weapon (off-hand dagger) is $AV2\n";
   my $meleeprob2 = ($AV2 - 50) + 54;
   print "Attack roll Probability is $meleeprob2 %\n";
   my $averageprob = ($meleeprob1 + $meleeprob2) / 2;
   my $speedmod2 = $stats[17];
   my $atkdur2 = ((1.5 - 0.5) * 1 ) + $speedmod2;
   my $atktiming = ($atkdur1 + $atkdur2);
   my $attribdmg2 = (((($STR + $DEX) - 20) * 0.5) * 0.85) * 0.125;
   my $AP2 = (($cunning - 10) / 7) + 4 + $apbonusweap2 + $apcharbonus;
   my $prearmdmgred2 = (0.7 + (0.3 * 0.5) * 10) - $AP2;
   my $armdmgred2 = 0;
   if ($prearmdmgred2 <= 0) {$armdmgred2 = 0;} else {$armdmgred2 = $prearmdmgred2};
   my $DMG2 = $weapdmg2 + $attribdmg2 + $chardmg + $OnHitdmg2 - $armdmgred2;
   print "The attack duration is $atkdur2 s\n";  
   print "Armor Penetration (AP) from off-hand dagger is $AP2\n";
   print "Its Damage is $DMG2\n";
   my $DPS = ($DMG1 + $DMG2) / $atktiming;
   my $ATK1 = $DMG1 * ($meleeprob1 * 0.01);
   my $ATK2 = $DMG2 * ($meleeprob2 * 0.01);
   my $realATK = ($ATK1 + $ATK2) / $atktiming;
   print "\nThe average dual-wielding attack speed is " . $atktiming/2 ."s\n";
   print "The average Attack roll probability is $averageprob %\n";
   print "DPS total damage with both weapons is $DPS\n";
   print "Approximate total damage output will be $realATK\n";   
}
   
else { print "Something went wrong with the elsif use for attack duration calculation of $weapon1"; }



#Weapons
 #	Dagger		Speed Mod = -0.5	AP = 4	Attribute = DEX+STR		Attribute modifier = 85%
 #	Long Sword	Speed Mod = -0.1	AP = 2	Attribute = STR			Attribute modifier = 100%
 #	Mace		Speed Mod = 0		AP = 4	Attribute = STR			Attribute modifier = 100%
 #	War Axe		Speed Mod = -0.1	AP = 2	Attribute = STR			Attribute modifier = 110%
 #	Crossbow 	Aim time = 0.8		AP = 5
 #	Shortbow	Aim time = 0.2		AP = 3	Attribute = DEX+STR		Attribute modifier = 100%
 #	Longbow		Aim time = 0.3		AP = 4	Attribute = DEX+STR		Attribute modifier = 100%

# CharacterSpeedMod = 1








print "\n\n\n\t\t<Press Enter to exit>\n";

   <STDIN>;
