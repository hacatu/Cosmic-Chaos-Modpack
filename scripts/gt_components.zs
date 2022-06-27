#priority 1000

//see https://github.com/GregTechCEu/GregTech/blob/master/src/main/java/gregtech/loaders/recipe/CraftingComponent.java

// This file is a list of all formulaic components used in crafting gregtech machines by tier.  It is adapted from the
// above java file.

import crafttweaker.item.IItemStack;
import crafttweaker.liquid.ILiquidStack;
import crafttweaker.oredict.IOreDictEntry;

static EBF_GASES as ILiquidStack[string] = {
	"LOW": <fluid:nitrogen>*1000,
	"MID": <fluid:helium>*100,
	"HIGH": <fluid:argon>*50,
	"HIGHER": <fluid:neon>*25,
	"HIGHEST": <fluid:krypton>*10,
} as ILiquidStack[string];

static CIRCUIT as IOreDictEntry[int] = {
	0: <ore:circuitUlv>,
	1: <ore:circuitLv>,
	2: <ore:circuitMv>,
	3: <ore:circuitHv>,
	4: <ore:circuitEv>,
	5: <ore:circuitIv>,
	6: <ore:circuitLuv>,
	7: <ore:circuitZpm>,
	8: <ore:circuitUv>,
	9: <ore:circuitUhv>,
	10: <ore:circuitUev>,
	11: <ore:circuitUiv>,
	12: <ore:circuitUxv>,
	13: <ore:circuitOpv>,
	14: <ore:circuitMax>
} as IOreDictEntry[int];

static BETTER_CIRCUIT as IItemStack[int] = {
	0: <ore:circuitLv>.firstItem,
	1: <ore:circuitMv>.firstItem,
	2: <ore:circuitHv>.firstItem,
	3: <ore:circuitEv>.firstItem,
	4: <ore:circuitIv>.firstItem,
	5: <ore:circuitLuv>.firstItem,
	6: <ore:circuitZpm>.firstItem,
	7: <ore:circuitUv>.firstItem,
	8: <ore:circuitUhv>.firstItem,
	9: <ore:circuitUev>.firstItem,
	10: <ore:circuitUiv>.firstItem,
	11: <ore:circuitUxv>.firstItem,
	12: <ore:circuitOpv>.firstItem,
	13: <ore:circuitMax>.firstItem
} as IItemStack[int];

static PUMP as IItemStack[int] = {
	1: <metaitem:electric.pump.lv>,
	2: <metaitem:electric.pump.mv>,
	3: <metaitem:electric.pump.hv>,
	4: <metaitem:electric.pump.ev>,
	5: <metaitem:electric.pump.iv>,
	6: <metaitem:electric.pump.luv>,
	7: <metaitem:electric.pump.zpm>,
	8: <metaitem:electric.pump.uv>,
/* high tiers nyi
	9: <metaitem:electric.pump.uhv>,
	10: <metaitem:electric.pump.uev>,
	11: <metaitem:electric.pump.uiv>,
	12: <metaitem:electric.pump.uxv>,
	13: <metaitem:electric.pump.opv>*/
} as IItemStack[int];


static WIRE_ELECTRIC as IItemStack[int] = {
	0: <ore:wireGtSingleGold>.firstItem,
	1: <ore:wireGtSingleGold>.firstItem,
	2: <ore:wireGtSingleSilver>.firstItem,
	3: <ore:wireGtSingleElectrum>.firstItem,
	4: <ore:wireGtSinglePlatinum>.firstItem,
	5: <ore:wireGtSingleOsmium>.firstItem,
	6: <ore:wireGtSingleOsmium>.firstItem,
	7: <ore:wireGtSingleOsmium>.firstItem,
	8: <ore:wireGtSingleOsmium>.firstItem,
} as IItemStack[int];

static WIRE_QUAD as IItemStack[int] = {
	0: <ore:wireGtQuadrupleLead>.firstItem,
	1: <ore:wireGtQuadrupleTin>.firstItem,
	2: <ore:wireGtQuadrupleCopper>.firstItem,
	3: <ore:wireGtQuadrupleGold>.firstItem,
	4: <ore:wireGtQuadrupleAluminium>.firstItem,
	5: <ore:wireGtQuadrupleTungsten>.firstItem,
	6: <ore:wireGtQuadrupleNiobiumTitanium>.firstItem,
	7: <ore:wireGtQuadrupleVanadiumGallium>.firstItem,
	8: <ore:wireGtQuadrupleYttriumBariumCuprate>.firstItem,
} as IItemStack[int];

static WIRE_OCT as IItemStack[int] = {
	0: <ore:wireGtOctalLead>.firstItem,
	1: <ore:wireGtOctalTin>.firstItem,
	2: <ore:wireGtOctalCopper>.firstItem,
	3: <ore:wireGtOctalGold>.firstItem,
	4: <ore:wireGtOctalAluminium>.firstItem,
	5: <ore:wireGtOctalTungsten>.firstItem,
	6: <ore:wireGtOctalNiobiumTitanium>.firstItem,
	7: <ore:wireGtOctalVanadiumGallium>.firstItem,
	8: <ore:wireGtOctalYttriumBariumCuprate>.firstItem,
} as IItemStack[int];

static WIRE_HEX as IItemStack[int] = {
	0: <ore:wireGtHexLead>.firstItem,
	1: <ore:wireGtHexTin>.firstItem,
	2: <ore:wireGtHexCopper>.firstItem,
	3: <ore:wireGtHexGold>.firstItem,
	4: <ore:wireGtHexAluminium>.firstItem,
	5: <ore:wireGtHexTungsten>.firstItem,
	6: <ore:wireGtHexNiobiumTitanium>.firstItem,
	7: <ore:wireGtHexVanadiumGallium>.firstItem,
	8: <ore:wireGtHexYttriumBariumCuprate>.firstItem,
} as IItemStack[int];

static CABLE as IItemStack[int] = {
	0: <ore:cableGtSingleRedAlloy>.firstItem,
	1: <ore:cableGtSingleTin>.firstItem,
	2: <ore:cableGtSingleCopper>.firstItem,
	3: <ore:cableGtSingleGold>.firstItem,
	4: <ore:cableGtSingleAluminium>.firstItem,
	5: <ore:cableGtSinglePlatinum>.firstItem,
	6: <ore:cableGtSingleNiobiumTitanium>.firstItem,
	7: <ore:cableGtSingleVanadiumGallium>.firstItem,
	8: <ore:cableGtSingleYttriumBariumCuprate>.firstItem,
	9: <ore:cableGtSingleEuropium>.firstItem,
} as IItemStack[int];

static CABLE_QUAD as IItemStack[int] = {
	0: <ore:cableGtQuadrupleRedAlloy>.firstItem,
	1: <ore:cableGtQuadrupleTin>.firstItem,
	2: <ore:cableGtQuadrupleCopper>.firstItem,
	3: <ore:cableGtQuadrupleGold>.firstItem,
	4: <ore:cableGtQuadrupleAluminium>.firstItem,
	5: <ore:cableGtQuadruplePlatinum>.firstItem,
	6: <ore:cableGtQuadrupleNiobiumTitanium>.firstItem,
	7: <ore:cableGtQuadrupleVanadiumGallium>.firstItem,
	8: <ore:cableGtQuadrupleYttriumBariumCuprate>.firstItem,
	9: <ore:cableGtQuadrupleEuropium>.firstItem,
} as IItemStack[int];

static CABLE_OCT as IItemStack[int] = {
	0: <ore:cableGtOctalRedAlloy>.firstItem,
	1: <ore:cableGtOctalTin>.firstItem,
	2: <ore:cableGtOctalCopper>.firstItem,
	3: <ore:cableGtOctalGold>.firstItem,
	4: <ore:cableGtOctalAluminium>.firstItem,
	5: <ore:cableGtOctalPlatinum>.firstItem,
	6: <ore:cableGtOctalNiobiumTitanium>.firstItem,
	7: <ore:cableGtOctalVanadiumGallium>.firstItem,
	8: <ore:cableGtOctalYttriumBariumCuprate>.firstItem,
	9: <ore:cableGtOctalEuropium>.firstItem,
} as IItemStack[int];

static CABLE_HEX as IItemStack[int] = {
	0: <ore:cableGtHexRedAlloy>.firstItem,
	1: <ore:cableGtHexTin>.firstItem,
	2: <ore:cableGtHexCopper>.firstItem,
	3: <ore:cableGtHexGold>.firstItem,
	4: <ore:cableGtHexAluminium>.firstItem,
	5: <ore:cableGtHexPlatinum>.firstItem,
	6: <ore:cableGtHexNiobiumTitanium>.firstItem,
	7: <ore:cableGtHexVanadiumGallium>.firstItem,
	8: <ore:cableGtHexYttriumBariumCuprate>.firstItem,
	9: <ore:cableGtHexEuropium>.firstItem,
} as IItemStack[int];

static CABLE_TIER_UP as IItemStack[int] = {
	0: <ore:cableGtSingleTin>.firstItem,
	1: <ore:cableGtSingleCopper>.firstItem,
	2: <ore:cableGtSingleGold>.firstItem,
	3: <ore:cableGtSingleAluminium>.firstItem,
	4: <ore:cableGtSinglePlatinum>.firstItem,
	5: <ore:cableGtSingleNiobiumTitanium>.firstItem,
	6: <ore:cableGtSingleVanadiumGallium>.firstItem,
	7: <ore:cableGtSingleYttriumBariumCuprate>.firstItem,
	8: <ore:cableGtSingleEuropium>.firstItem,
    -1: <ore:cableGtSingleEuropium>.firstItem,
} as IItemStack[int];

static HULL as IItemStack[int] = {
	0: <metaitem:gregtech:hull.ulv>,
	1: <metaitem:gregtech:hull.lv>,
	2: <metaitem:gregtech:hull.mv>,
	3: <metaitem:gregtech:hull.hv>,
	4: <metaitem:gregtech:hull.ev>,
	5: <metaitem:gregtech:hull.iv>,
	6: <metaitem:gregtech:hull.luv>,
	7: <metaitem:gregtech:hull.zpm>,
	8: <metaitem:gregtech:hull.uv>,
	9: <metaitem:gregtech:hull.uhv>,
/* high tiers nyi
	10: <metaitem:gregtech:hull.uev>,
	11: <metaitem:gregtech:hull.uiv>,
	12: <metaitem:gregtech:hull.uxv>,
	13: <metaitem:gregtech:hull.opv>,
	14: <metaitem:gregtech:hull.max>,*/
} as IItemStack[int];

static CASING as IItemStack[int] = {
	0: <gregtech:machine_casing:0>,
	1: <gregtech:machine_casing:1>,
	2: <gregtech:machine_casing:2>,
	3: <gregtech:machine_casing:3>,
	4: <gregtech:machine_casing:4>,
	5: <gregtech:machine_casing:5>,
	6: <gregtech:machine_casing:6>,
	7: <gregtech:machine_casing:7>,
	8: <gregtech:machine_casing:8>,
	9: <gregtech:machine_casing:9>,
/* high tiers nyi
	10: <gregtech:machine_casing:10>,
	11: <gregtech:machine_casing:11>,
	12: <gregtech:machine_casing:12>,
	13: <gregtech:machine_casing:13>,
	14: <gregtech:machine_casing:14>,*/
} as IItemStack[int];

static PIPE_NORMAL as IItemStack[int] = {
	0: <ore:pipeNormalFluidBronze>.firstItem,
	1: <ore:pipeNormalFluidBronze>.firstItem,
	2: <ore:pipeNormalFluidSteel>.firstItem,
	3: <ore:pipeNormalFluidStainlessSteel>.firstItem,
	4: <ore:pipeNormalFluidTitanium>.firstItem,
	5: <ore:pipeNormalFluidTungstenSteel>.firstItem,
	6: <ore:pipeNormalFluidNiobiumTitanium>.firstItem,
	7: <ore:pipeNormalFluidIridium>.firstItem,
	8: <ore:pipeNormalFluidNaquadah>.firstItem,
} as IItemStack[int];

static PIPE_LARGE as IItemStack[int] = {
	0: <ore:pipeLargeFluidBronze>.firstItem,
	1: <ore:pipeLargeFluidBronze>.firstItem,
	2: <ore:pipeLargeFluidSteel>.firstItem,
	3: <ore:pipeLargeFluidStainlessSteel>.firstItem,
	4: <ore:pipeLargeFluidTitanium>.firstItem,
	5: <ore:pipeLargeFluidTungstenSteel>.firstItem,
	6: <ore:pipeLargeFluidNiobiumTitanium>.firstItem,
	7: <ore:pipeLargeFluidUltimet>.firstItem,
	8: <ore:pipeLargeFluidNaquadah>.firstItem,
} as IItemStack[int];


//TODO, Glass Tiers:
/*
Glass: Steam-MV
Tempered: HV, EV
Laminated Glass: IV, LuV
Fusion: ZPM, UV
Some gregicality thing: UHV+
*/

static GLASS as IItemStack[int] = {
	-1: <minecraft:glass>,
	0: <minecraft:glass>,
	1: <minecraft:glass>,
	2: <minecraft:glass>,
	3: <gregtech:transparent_casing:0>,
	4: <gregtech:transparent_casing:0>,
	5: <gregtech:transparent_casing:2>,
	6: <gregtech:transparent_casing:2>,
	7: <gregtech:transparent_casing:1>,
	8: <gregtech:transparent_casing:1>,
} as IItemStack[int];

static PLATE as IItemStack[int] = {
	0: <ore:plateWroughtIron>.firstItem,
	1: <ore:plateSteel>.firstItem,
	2: <ore:plateAluminium>.firstItem,
	3: <ore:plateStainlessSteel>.firstItem,
	4: <ore:plateTitanium>.firstItem,
	5: <ore:plateTungstenSteel>.firstItem,
	6: <ore:plateRhodiumPlatedPalladium>.firstItem,
	7: <ore:plateNaquadahAlloy>.firstItem,
	8: <ore:plateDarmstadtium>.firstItem,
	9: <ore:plateNeutronium>.firstItem,
} as IItemStack[int];

static HULL_PLATE as IItemStack[int] = {
	0: <ore:plateWood>.firstItem,
	1: <ore:plateWroughtIron>.firstItem,
	2: <ore:plateWroughtIron>.firstItem,
	3: <ore:platePolyethylene>.firstItem,
	4: <ore:platePolyethylene>.firstItem,
	5: <ore:platePolytetrafluoroethylene>.firstItem,
	6: <ore:platePolytetrafluoroethylene>.firstItem,
	7: <ore:platePolybenzimidazole>.firstItem,
	8: <ore:platePolybenzimidazole>.firstItem,
    -1: <ore:platePolybenzimidazole>.firstItem,
} as IItemStack[int];

static MOTOR as IItemStack[int] = {
	1: <metaitem:electric.motor.lv>,
	2: <metaitem:electric.motor.mv>,
	3: <metaitem:electric.motor.hv>,
	4: <metaitem:electric.motor.ev>,
	5: <metaitem:electric.motor.iv>,
	6: <metaitem:electric.motor.luv>,
	7: <metaitem:electric.motor.zpm>,
	8: <metaitem:electric.motor.uv>,
/* high tiers nyi
	9: <metaitem:electric.motor.uhv>,
	10: <metaitem:electric.motor.uev>,
	11: <metaitem:electric.motor.uiv>,
	12: <metaitem:electric.motor.uxv>,
	13: <metaitem:electric.motor.opv>,*/
} as IItemStack[int];

static ROTOR as IItemStack[int] = {
	0: <ore:rotorTin>.firstItem,
	1: <ore:rotorTin>.firstItem,
	2: <ore:rotorBronze>.firstItem,
	3: <ore:rotorSteel>.firstItem,
	4: <ore:rotorStainlessSteel>.firstItem,
	5: <ore:rotorTungstenSteel>.firstItem,
	6: <ore:rotorRhodiumPlatedPalladium>.firstItem,
	7: <ore:rotorNaquadahAlloy>.firstItem,
	8: <ore:rotorDarmstadtium>.firstItem,
} as IItemStack[int];

static SENSOR as IItemStack[int] = {
	1: <metaitem:sensor.lv>,
	2: <metaitem:sensor.mv>,
	3: <metaitem:sensor.hv>,
	4: <metaitem:sensor.ev>,
	5: <metaitem:sensor.iv>,
	6: <metaitem:sensor.luv>,
	7: <metaitem:sensor.zpm>,
	8: <metaitem:sensor.uv>,
/* high tiers nyi
	9: <metaitem:sensor.uhv>,
	10: <metaitem:sensor.uev>,
	11: <metaitem:sensor.uiv>,
	12: <metaitem:sensor.uxv>,
	13: <metaitem:sensor.opv>,*/
} as IItemStack[int];

static GRINDER as IItemStack[int] = {
	0: <ore:gemDiamond>.firstItem,
	1: <ore:gemDiamond>.firstItem,
	2: <ore:gemDiamond>.firstItem,
	3: <metaitem:component.grinder.diamond>,
	4: <metaitem:component.grinder.diamond>,
	5: <metaitem:component.grinder.tungsten>,
    -1: <metaitem:component.grinder.tungsten>,
} as IItemStack[int];

static SAWBLADE as IItemStack[int] = {
	0: <ore:toolHeadBuzzSawBronze>.firstItem,
	1: <ore:toolHeadBuzzSawCobaltBrass>.firstItem,
	2: <ore:toolHeadBuzzSawVanadiumSteel>.firstItem,
	3: <ore:toolHeadBuzzSawBlackBronze>.firstItem,
	4: <ore:toolHeadBuzzSawUltimet>.firstItem,
	5: <ore:toolHeadBuzzSawTungstenCarbide>.firstItem,
	6: <ore:toolHeadBuzzSawHSSS>.firstItem,
	7: <ore:toolHeadBuzzSawDuranium>.firstItem,
	8: <ore:toolHeadBuzzSawTritanium>.firstItem,
    -1: <ore:toolHeadBuzzSawTritanium>.firstItem,
} as IItemStack[int];

static DIAMOND as IItemStack[int] = {
	-1: <ore:gemDiamond>.firstItem,
} as IItemStack[int];

static PISTON as IItemStack[int] = {
	1: <metaitem:electric.piston.lv>,
	2: <metaitem:electric.piston.mv>,
	3: <metaitem:electric.piston.hv>,
	4: <metaitem:electric.piston.ev>,
	5: <metaitem:electric.piston.iv>,
	6: <metaitem:electric.piston.luv>,
	7: <metaitem:electric.piston.zpm>,
	8: <metaitem:electric.piston.uv>,
/* high tiers nyi
	9: <metaitem:electric.piston.uhv>,
	10: <metaitem:electric.piston.uev>,
	11: <metaitem:electric.piston.uiv>,
	12: <metaitem:electric.piston.uxv>,
	13: <metaitem:electric.piston.opv>,*/
} as IItemStack[int];

static EMITTER as IItemStack[int] = {
	1: <metaitem:emitter.lv>,
	2: <metaitem:emitter.mv>,
	3: <metaitem:emitter.hv>,
	4: <metaitem:emitter.ev>,
	5: <metaitem:emitter.iv>,
	6: <metaitem:emitter.luv>,
	7: <metaitem:emitter.zpm>,
	8: <metaitem:emitter.uv>,
/* high tiers nyi
	9: <metaitem:emitter.uhv>,
	10: <metaitem:emitter.uev>,
	11: <metaitem:emitter.uiv>,
	12: <metaitem:emitter.uxv>,
	13: <metaitem:emitter.opv>,*/
} as IItemStack[int];

static CONVEYOR as IItemStack[int] = {
	1: <metaitem:conveyor.module.lv>,
	2: <metaitem:conveyor.module.mv>,
	3: <metaitem:conveyor.module.hv>,
	4: <metaitem:conveyor.module.ev>,
	5: <metaitem:conveyor.module.iv>,
	6: <metaitem:conveyor.module.luv>,
	7: <metaitem:conveyor.module.zpm>,
	8: <metaitem:conveyor.module.uv>,
/* high tiers nyi
	9: <metaitem:conveyor.module.uhv>,
	10: <metaitem:conveyor.module.uev>,
	11: <metaitem:conveyor.module.uiv>,
	12: <metaitem:conveyor.module.uxv>,
	13: <metaitem:conveyor.module.opv>,*/
} as IItemStack[int];

static ROBOT_ARM as IItemStack[int] = {
	1: <metaitem:robot.arm.lv>,
	2: <metaitem:robot.arm.mv>,
	3: <metaitem:robot.arm.hv>,
	4: <metaitem:robot.arm.ev>,
	5: <metaitem:robot.arm.iv>,
	6: <metaitem:robot.arm.luv>,
	7: <metaitem:robot.arm.zpm>,
	8: <metaitem:robot.arm.uv>,
/* high tiers nyi
	9: <metaitem:robot.arm.uhv>,
	10: <metaitem:robot.arm.uev>,
	11: <metaitem:robot.arm.uiv>,
	12: <metaitem:robot.arm.uxv>,
	13: <metaitem:robot.arm.opv>,*/
} as IItemStack[int];

static COIL_HEATING as IItemStack[int] = {
	0: <ore:wireGtDoubleCopper>.firstItem,
	1: <ore:wireGtDoubleCopper>.firstItem,
	2: <ore:wireGtDoubleCupronickel>.firstItem,
	3: <ore:wireGtDoubleKanthal>.firstItem,
	4: <ore:wireGtDoubleNichrome>.firstItem,
	5: <ore:wireGtDoubleTungstenSteel>.firstItem,
	6: <ore:wireGtDoubleHSSG>.firstItem,
	7: <ore:wireGtDoubleNaquadah>.firstItem,
	8: <ore:wireGtDoubleNaquadahAlloy>.firstItem,
} as IItemStack[int];

static COIL_HEATING_DOUBLE as IItemStack[int] = {
	0: <ore:wireGtQuadrupleCopper>.firstItem,
	1: <ore:wireGtQuadrupleCopper>.firstItem,
	2: <ore:wireGtQuadrupleCupronickel>.firstItem,
	3: <ore:wireGtQuadrupleKanthal>.firstItem,
	4: <ore:wireGtQuadrupleNichrome>.firstItem,
	5: <ore:wireGtQuadrupleTungstenSteel>.firstItem,
	6: <ore:wireGtQuadrupleHSSG>.firstItem,
	7: <ore:wireGtQuadrupleNaquadah>.firstItem,
	8: <ore:wireGtQuadrupleNaquadahAlloy>.firstItem,
} as IItemStack[int];

static COIL_ELECTRIC as IItemStack[int] = {
	0: <ore:wireGtSingleTin>.firstItem,
	1: <ore:wireGtDoubleTin>.firstItem,
	2: <ore:wireGtDoubleCopper>.firstItem,
	3: <ore:wireGtDoubleSilver>.firstItem,
	4: <ore:wireGtQuadrupleSteel>.firstItem,
	5: <ore:wireGtQuadrupleGraphene>.firstItem,
	6: <ore:wireGtQuadrupleNiobiumNitride>.firstItem,
	7: <ore:wireGtOctalVanadiumGallium>.firstItem,
	8: <ore:wireGtOctalYttriumBariumCuprate>.firstItem,
} as IItemStack[int];

static STICK_MAGNETIC as IItemStack[int] = {
	0: <ore:stickIronMagnetic>.firstItem,
	1: <ore:stickIronMagnetic>.firstItem,
	2: <ore:stickSteelMagnetic>.firstItem,
	3: <ore:stickSteelMagnetic>.firstItem,
	4: <ore:stickNeodymiumMagnetic>.firstItem,
	5: <ore:stickNeodymiumMagnetic>.firstItem,
	6: <ore:stickLongNeodymiumMagnetic>.firstItem,
	7: <ore:stickLongNeodymiumMagnetic>.firstItem,
	8: <ore:blockNeodymiumMagnetic>.firstItem,
} as IItemStack[int];

static STICK_DISTILLATION as IItemStack[int] = {
	0: <ore:stickBlaze>.firstItem,
	1: <ore:springCopper>.firstItem,
	2: <ore:springCupronickel>.firstItem,
	3: <ore:springKanthal>.firstItem,
	4: <ore:springNichrome>.firstItem,
	5: <ore:springTungstenSteel>.firstItem,
	6: <ore:springHSSG>.firstItem,
	7: <ore:springNaquadah>.firstItem,
	8: <ore:springNaquadahAlloy>.firstItem,
    -1: <ore:stickBlaze>.firstItem,
} as IItemStack[int];

static FIELD_GENERATOR as IItemStack[int] = {
	1: <metaitem:field.generator.lv>,
	2: <metaitem:field.generator.mv>,
	3: <metaitem:field.generator.hv>,
	4: <metaitem:field.generator.ev>,
	5: <metaitem:field.generator.iv>,
	6: <metaitem:field.generator.luv>,
	7: <metaitem:field.generator.zpm>,
	8: <metaitem:field.generator.uv>,
/* high tiers nyi
	9: <metaitem:field.generator.uhv>,
	10: <metaitem:field.generator.uev>,
	11: <metaitem:field.generator.uiv>,
	12: <metaitem:field.generator.uxv>,
	13: <metaitem:field.generator.opv>,*/
} as IItemStack[int];

static STICK_ELECTROMAGNETIC as IItemStack[int] = {
	0: <ore:stickIron>.firstItem,
	1: <ore:stickIron>.firstItem,
	2: <ore:stickSteel>.firstItem,
	3: <ore:stickSteel>.firstItem,
	4: <ore:stickNeodymium>.firstItem,
    -1: <ore:stickVanadiumGallium>.firstItem,
} as IItemStack[int];

static STICK_RADIOACTIVE as IItemStack[int] = {
	4: <ore:stickUranium235>.firstItem,
	5: <ore:stickPlutonium241>.firstItem,
	6: <ore:stickNaquadahEnriched>.firstItem,
	7: <ore:stickAmericium>.firstItem,
    -1: <ore:stickTritanium>.firstItem,
} as IItemStack[int];

static PIPE_REACTOR as IItemStack[int] = {
	0: <minecraft:glass>,
	1: <minecraft:glass>,
	2: <minecraft:glass>,
	3: <ore:pipeNormalFluidPolyethylene>.firstItem,
	4: <ore:pipeLargeFluidPolyethylene>.firstItem,
	5: <ore:pipeHugeFluidPolyethylene>.firstItem,
	6: <ore:pipeNormalFluidPolytetrafluoroethylene>.firstItem,
	7: <ore:pipeLargeFluidPolytetrafluoroethylene>.firstItem,
	8: <ore:pipeHugeFluidPolytetrafluoroethylene>.firstItem,
    -1: <ore:pipeNormalFluidPolyethylene>.firstItem,
} as IItemStack[int];

static POWER_COMPONENT as IItemStack[int] = {
	2: <metaitem:ultra.low.power.integrated.circuit>,
	3: <metaitem:low.power.integrated.circuit>,
	4: <metaitem:power.integrated.circuit>,
	5: <metaitem:high.power.integrated.circuit>,
	6: <metaitem:high.power.integrated.circuit>,
	7: <metaitem:ultra.high.power.integrated.circuit>,
	8: <metaitem:ultra.high.power.integrated.circuit>,
	9: <metaitem:ultra.high.power.integrated.circuit>,
    -1: <metaitem:ultra.high.power.integrated.circuit>,
} as IItemStack[int];

static VOLTAGE_COIL as IItemStack[int] = {
	0: <metaitem:voltage.coil.ulv>,
	1: <metaitem:voltage.coil.lv>,
	2: <metaitem:voltage.coil.mv>,
	3: <metaitem:voltage.coil.hv>,
	4: <metaitem:voltage.coil.ev>,
	5: <metaitem:voltage.coil.iv>,
	6: <metaitem:voltage.coil.luv>,
	7: <metaitem:voltage.coil.zpm>,
	8: <metaitem:voltage.coil.uv>,
    -1: <metaitem:voltage.coil.uv>,
} as IItemStack[int];

static SPRING as IItemStack[int] = {
	0: <ore:springLead>.firstItem,
	1: <ore:springTin>.firstItem,
	2: <ore:springCopper>.firstItem,
	3: <ore:springGold>.firstItem,
	4: <ore:springAluminium>.firstItem,
	5: <ore:springTungsten>.firstItem,
	6: <ore:springNiobiumTitanium>.firstItem,
	7: <ore:springVanadiumGallium>.firstItem,
	8: <ore:springYttriumBariumCuprate>.firstItem,
	9: <ore:springEuropium>.firstItem,
} as IItemStack[int];
