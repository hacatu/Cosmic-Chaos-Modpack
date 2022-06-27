#priority 6
import crafttweaker.block.IBlockState;
import crafttweaker.block.IBlock;
import crafttweaker.item.IIngredient;
import crafttweaker.item.IItemStack;
import crafttweaker.liquid.ILiquidStack;
import crafttweaker.oredict.IOreDictEntry;
import crafttweaker.world.IBlockPos;
import crafttweaker.world.IFacing;
import crafttweaker.world.IWorld;
import crafttweaker.data.IData;
import mods.contenttweaker.Random;
import mods.contenttweaker.World;
import mods.gregtech.IControllerTile;
import mods.gregtech.multiblock.Builder;
import mods.gregtech.multiblock.CTPredicate;
import mods.gregtech.multiblock.FactoryBlockPattern;
import mods.gregtech.multiblock.IPatternMatchContext;
import mods.gregtech.multiblock.functions.ICheckRecipeFunction;
import mods.gregtech.recipe.functions.ISetupRecipeFunction;
import mods.gregtech.multiblock.functions.IPatternBuilderFunction;
import mods.gregtech.multiblock.functions.IFormStructureFunction;
import mods.gregtech.multiblock.functions.IUpdateFormedValidFunction;
import mods.gregtech.multiblock.IBlockPattern;
import mods.gregtech.multiblock.RelativeDirection;
import mods.gregtech.recipe.FactoryRecipeMap;
import mods.gregtech.recipe.functions.ICompleteRecipeFunction;
import mods.gregtech.recipe.IRecipe;
import mods.gregtech.recipe.IRecipeLogic;
import mods.gregtech.recipe.RecipeMap;
import mods.forge.items.IItemHandlerModifiable;


var loc = "mbt:pebf";

val pebf = Builder.start(loc)
    .withPattern(function(controller as IControllerTile) as IBlockPattern {
                       return FactoryBlockPattern.start(RelativeDirection.RIGHT, RelativeDirection.DOWN, RelativeDirection.FRONT)
            .aisle(
				"BFB",
				"GGG",
                "IEI"
            )
            .aisle(
                "FBF",
                "GCG",
                "IBI"
            )
            .aisle(
                "BFB",
                "GGG",
                "III"
            )


            .where("E", controller.self())
			.where("B", <blockstate:gregtech:metal_casing:variant=bronze_bricks>)
			.where("F", <blockstate:gregtech:boiler_firebox_casing:active=false,variant=bronze_firebox>)
			.where("G", <blockstate:minecraft:stained_glass:color=red>)
			.where("C", CTPredicate.states(<blockstate:gregtech:meta_block_compressed_2009:variant=red_crystal_alloy>)
				  | CTPredicate.states(<blockstate:gregtech:meta_block_compressed_2003:variant=aurorian_geode>)
				  | CTPredicate.states(<blockstate:midnight:rouxe_rock>)
				  | CTPredicate.states(<blockstate:thebetweenlands:mire_coral_block>)
			)
            .where("I", CTPredicate.states(<blockstate:gregtech:metal_casing:variant=bronze_bricks>)
				  | CTPredicate.abilities(<mte_ability:IMPORT_ITEMS>).setMinGlobalLimited(1).setPreviewCount(1)
				  | CTPredicate.abilities(<mte_ability:EXPORT_ITEMS>).setMinGlobalLimited(1).setPreviewCount(1)
				  | CTPredicate.abilities(<mte_ability:INPUT_ENERGY>).setMinGlobalLimited(1).setMaxGlobalLimited(1).setPreviewCount(1)
            )
            .build();
    } as IPatternBuilderFunction)
	    .withRecipeMap(
		FactoryRecipeMap.start("pebf")
						.maxInputs(2)
                        .maxOutputs(1)
                        .build())
		.withBaseTexture(<blockstate:gregtech:metal_casing:variant=bronze_bricks>)
		.buildAndRegister();
// set optional properties
pebf.hasMaintenanceMechanics = false;
pebf.hasMufflerMechanics = false;

# [pebf] from [Blast Furnace][+4]
craft.make(<metaitem:mbt:pebf>, ["pretty",
  "L ■ L",
  "H l H",
  "B ■ B"], {
  "L": <ore:circuitLv>,                  # Electronic Circuit
  "■": <ore:blockWroughtIron>,           # Block of Wrought Iron
  "H": <contenttweaker:heating_element>, # Heating Element
  "l": <futuremc:blast_furnace>,         # Blast Furnace
  "B": <ore:sheetBronze>,                # Bronze Sheet
});

<metaitem:mbt:pebf>.addTooltip(format.red("Runs dust/ore recipes in parallel!"));
<metaitem:mbt:pebf>.addTooltip(format.red("4x + 1x per overclock tier"));

val steelFuelMap as int[IIngredient] = {
	<ore:dustCharcoal>*4: 180,
	<ore:dustCoal>*2: 120,
	<ore:dustCoke>:60
} as int[IIngredient];

for input, time in steelFuelMap {
	pebf.recipeMap.recipeBuilder()
		.inputs(input, <ore:ingotIron>)
		.outputs(<ore:ingotSteel>.firstItem.withTag({display:{Lore:["Requires an upgraded gem core (aurorian geode, rouxe block, or mire coral)"]},requiresCoreTier:1}))
	.duration(time).EUt(6).buildAndRegister();
	
	pebf.recipeMap.recipeBuilder()
		.inputs(input, <ore:ingotIron>)
		.outputs(<ore:ingotCrudeSteel>.firstItem.withTag({display:{Lore:["Created by a basic gem core (fire gem)"]},requiresCoreTier:0}))
	.duration(time).EUt(6).buildAndRegister();
}

pebf.recipeMap.recipeBuilder()
	.inputs(<ore:ingotIron>)
	.notConsumable(<metaitem:circuit.integrated>.withTag({Configuration:1}))
	.outputs(<ore:ingotWroughtIron>.firstItem)
.duration(60).EUt(6).buildAndRegister();


//print("ZZZZZ DUMPING FURNACE RECIPES $ore*/$dust* -> *");
/*
for recipe in furnace.all {
	for oreDictTag in recipe.input.ores {
		if (oreDictTag.name.startsWith("ore") || oreDictTag.name.startsWith("dust")) {
			print(recipe.toCommandString());
			break;
		}
	}
}
*/

val furnace_blasting_recipes as IItemStack[][] = [
	[<gregtech:ore_gypsum_1:1>, <gregtech:meta_dust:2032>],
	[<gregtech:ore_scheelite_1:2>, <gregtech:meta_dust:315>],
	[<gregtech:meta_dust_impure:337>, <minecraft:iron_ingot>],
	[<gregtech:ore_uraninite_1:1>, <gregtech:meta_dust:332>],
	[<gregtech:ore_cassiterite_sand_0:1>, <gregtech:meta_ingot:112> * 4],
	[<gregtech:ore_tungstate_0:2>, <gregtech:meta_dust:330> * 2],
	[<gregtech:ore_malachite_0>, <gregtech:meta_ingot:25>],
	[<gregtech:ore_grossular_0:1>, <gregtech:meta_gem:282> * 6],
	[<gregtech:ore_sapphire_0>, <gregtech:meta_gem:314>],
	[<gregtech:ore_chromite_1:2>, <gregtech:meta_dust:267>],
	[<gregtech:ore_redstone_0:2>, <minecraft:redstone> * 10],
	[<gregtech:ore_bastnasite_1:2>, <gregtech:meta_dust:379> * 2],
	[<gregtech:meta_dust_impure:265>, <gregtech:meta_ingot:25>],
	[<gregtech:meta_dust:25>, <gregtech:meta_ingot:25>],
	[<gregtech:ore_sodalite_1:3>, <gregtech:meta_gem:316> * 6],
	[<gregtech:ore_calcite_0:1>, <gregtech:meta_dust:262> * 2],
	[<gregtech:ore_pentlandite_1:2>, <gregtech:meta_ingot:69>],
	[<gregtech:meta_dust:395>, <gregtech:meta_dust:51>],
	[<gregtech:ore_lead_1:2>, <gregtech:meta_ingot:55>],
	[<gregtech:ore_blue_topaz_1:2>, <gregtech:meta_gem:257> * 2],
	[<gregtech:ore_spodumene_1:2>, <gregtech:meta_dust:381>],
	[<gregtech:meta_dust:129>, <gregtech:meta_ingot:129>],
	[<gregtech:meta_dust_impure:380>, <gregtech:meta_ingot:69>],
	[<gregtech:meta_dust:287>, <gregtech:meta_ingot:287>],
	[<gregtech:ore_realgar_1:3>, <gregtech:meta_gem:365>],
	[<gregtech:ore_plutonium_0:2>, <gregtech:meta_ingot:81> * 2],
	[<gregtech:ore_cassiterite_0>, <gregtech:meta_ingot:112> * 2],
	[<gregtech:ore_chalcocite_0>, <gregtech:meta_ingot:25>],
	[<libvulpes:ore0:4>, <gregtech:meta_ingot:25>],
	[<gregtech:ore_lazurite_1>, <gregtech:meta_gem:289> * 6],
	[<gregtech:ore_ilmenite_1>, <gregtech:meta_dust:284>],
	[<gregtech:ore_molybdenite_1:3>, <gregtech:meta_ingot:64>],
	[<gregtech:ore_soapstone_0:1>, <gregtech:meta_dust:393> * 6],
	[<gregtech:ore_oilsands_1>, <gregtech:meta_dust:1597>],
	[<gregtech:ore_barite_0:2>, <gregtech:meta_dust:387> * 2],
	[<gregtech:ore_apatite_1>, <gregtech:meta_gem:2010> * 4],
	[<gregtech:ore_copper_0:1>, <gregtech:meta_ingot:25> * 2],
	[<gregtech:ore_lapis_1>, <minecraft:dye:4> * 6],
	[<gregtech:ore_barite_0>, <gregtech:meta_dust:387>],
	[<gregtech:ore_pollucite_0:1>, <gregtech:meta_dust:2024> * 2],
	[<gregtech:meta_dust:380>, <gregtech:meta_ingot:69>],
	[<gregtech:ore_nether_quartz_0:1>, <minecraft:quartz> * 4],
	[<gregtech:ore_granitic_mineral_sand_1>, <minecraft:iron_ingot>],
	[<gregtech:ore_rock_salt_1>, <gregtech:meta_gem:309> * 2],
	[<gregtech:meta_dust_pure:292>, <minecraft:iron_ingot>],
	[<gregtech:ore_nether_quartz_1:1>, <minecraft:quartz> * 2],
	[<gregtech:ore_scheelite_0>, <gregtech:meta_dust:315>],
	[<gregtech:ore_copper_0>, <gregtech:meta_ingot:25>],
	[<gregtech:meta_dust_impure:263>, <gregtech:meta_ingot:112>],
	[<gregtech:ore_powellite_1>, <gregtech:meta_dust:305>],
	[<gregtech:ore_emerald_0>, <minecraft:emerald> * 2],
	[<gregtech:ore_pyrolusite_0>, <gregtech:meta_ingot:61>],
	[<gregtech:meta_dust_impure:280>, <gregtech:meta_ingot:69>],
	[<gregtech:ore_chromite_1>, <gregtech:meta_dust:267>],
	[<gregtech:ore_cassiterite_0:1>, <gregtech:meta_ingot:112> * 4],
	[<gregtech:ore_silver_1:2>, <gregtech:meta_ingot:100>],
	[<gregtech:ore_gold_0>, <minecraft:gold_ingot>],
	[<thebetweenlands:octine_ore>, <thebetweenlands:octine_ingot>],
	[<gregtech:ore_gold_0:1>, <minecraft:gold_ingot> * 2],
	[<gregtech:ore_vanadium_magnetite_0:2>, <gregtech:meta_dust:2022> * 2],
	[<gregtech:ore_tantalite_0:1>, <gregtech:meta_dust:318> * 2],
	[<gregtech:ore_platinum_1>, <gregtech:meta_ingot:80>],
	[<gregtech:meta_dust_impure:385>, <gregtech:meta_ingot:25>],
	[<gregtech:ore_nether_quartz_1:3>, <minecraft:quartz> * 2],
	[<gregtech:ore_basaltic_mineral_sand_1:2>, <minecraft:iron_ingot>],
	[<gregtech:ore_garnet_yellow_0:1>, <gregtech:meta_gem:2017> * 8],
	[<gregtech:ore_olivine_1>, <gregtech:meta_gem:2004> * 2],
	[<gregtech:ore_pyrochlore_0>, <gregtech:meta_dust:449>],
	[<gregtech:ore_saltpeter_1:1>, <gregtech:meta_dust:313> * 2],
	[<gregtech:ore_pitchblende_1>, <gregtech:meta_dust:2028>],
	[<gregtech:ore_garnierite_1:1>, <gregtech:meta_ingot:69>],
	[<gregtech:ore_bentonite_1:2>, <gregtech:meta_dust:2026> * 3],
	[<gregtech:ore_cooperite_1:1>, <gregtech:meta_dust:273>],
	[<gregtech:ore_monazite_1:1>, <gregtech:meta_gem:2029> * 4],
	[<gregtech:ore_scabyst_1:3>, <thebetweenlands:items_misc:39>],
	[<qmd:dust:2>, <qmd:ingot:2>],
	[<gregtech:ore_grossular_1:2>, <gregtech:meta_gem:282> * 3],
	[<gregtech:meta_dust_impure:109>, <gregtech:meta_ingot:109>],
	[<gregtech:ore_sphalerite_1:1>, <gregtech:meta_ingot:122>],
	[<gregtech:meta_dust_impure:272>, <gregtech:meta_ingot:23>],
	[<gregtech:ore_tin_1>, <gregtech:meta_ingot:112>],
	[<gregtech:ore_plutonium_1:2>, <gregtech:meta_ingot:81>],
	[<gregtech:meta_dust_impure:325>, <gregtech:meta_ingot:4>],
	[<gregtech:ore_tin_0>, <gregtech:meta_ingot:112>],
	[<gregtech:ore_malachite_0:1>, <gregtech:meta_ingot:25> * 2],
	[<gregtech:ore_nether_quartz_1>, <minecraft:quartz> * 2],
	[<gregtech:ore_vanadium_magnetite_1:1>, <gregtech:meta_dust:2022>],
	[<gregtech:ore_molybdenite_0:2>, <gregtech:meta_ingot:64> * 2],
	[<gregtech:ore_apatite_0:2>, <gregtech:meta_gem:2010> * 8],
	[<gregtech:ore_certus_quartz_0:1>, <appliedenergistics2:material:0> * 4],
	[<gregtech:meta_dust_impure:347>, <gregtech:meta_ingot:25>],
	[<gregtech:ore_sulfur_1:3>, <gregtech:meta_dust:103>],
	[<thebetweenlands:valonite_ore>, <thebetweenlands:items_misc:19>],
	[<gregtech:ore_emerald_0:1>, <minecraft:emerald> * 4],
	[<gregtech:ore_tantalite_1:2>, <gregtech:meta_dust:318>],
	[<gregtech:ore_electrotine_0>, <gregtech:meta_dust:2507> * 5],
	[<gregtech:ore_pollucite_1:2>, <gregtech:meta_dust:2024>],
	[<gregtech:ore_pyrite_1>, <minecraft:iron_ingot>],
	[<gregtech:ore_copper_0:2>, <gregtech:meta_ingot:25> * 2],
	[<gregtech:ore_rock_salt_1:3>, <gregtech:meta_gem:309> * 2],
	[<gregtech:ore_molybdenum_1:3>, <gregtech:meta_ingot:64>],
	[<gregtech:ore_cobaltite_0:1>, <gregtech:meta_ingot:23> * 2],
	[<gregtech:ore_grossular_1:1>, <gregtech:meta_gem:282> * 3],
	[<gregtech:ore_pollucite_1>, <gregtech:meta_dust:2024>],
	[<gregtech:ore_pyrochlore_1:3>, <gregtech:meta_dust:449>],
	[<gregtech:ore_sphalerite_0:1>, <gregtech:meta_ingot:122> * 2],
	[<gregtech:meta_dust_impure:293>, <gregtech:meta_ingot:64>],
	[<gregtech:ore_cobaltite_1>, <gregtech:meta_ingot:23>],
	[<gregtech:ore_green_sapphire_0>, <gregtech:meta_gem:281>],
	[<gregtech:meta_dust:255>, <minecraft:iron_ingot>],
	[<gregtech:ore_blue_topaz_1:1>, <gregtech:meta_gem:257> * 2],
	[<gregtech:ore_pyrolusite_0:2>, <gregtech:meta_ingot:61> * 2],
	[<gregtech:ore_bornite_1:3>, <gregtech:meta_ingot:25>],
	[<gregtech:ore_octine_0:2>, <thebetweenlands:octine_ingot> * 2],
	[<gregtech:meta_dust:418>, <gregtech:meta_dust:66>],
	[<gregtech:ore_bentonite_0:2>, <gregtech:meta_dust:2026> * 6],
	[<gregtech:ore_silver_1>, <gregtech:meta_ingot:100>],
	[<gregtech:ore_blue_topaz_1:3>, <gregtech:meta_gem:257> * 2],
	[<gregtech:ore_copper_1>, <gregtech:meta_ingot:25>],
	[<gregtech:meta_dust_pure:306>, <minecraft:iron_ingot>],
	[<gregtech:ore_pyrochlore_0:1>, <gregtech:meta_dust:449> * 2],
	[<gregtech:ore_redstone_1:1>, <minecraft:redstone> * 5],
	[<gregtech:ore_octine_1:2>, <thebetweenlands:octine_ingot>],
	[<gregtech:ore_lapis_1:2>, <minecraft:dye:4> * 6],
	[<gregtech:ore_apatite_0:1>, <gregtech:meta_gem:2010> * 8],
	[<gregtech:ore_garnet_yellow_0:2>, <gregtech:meta_gem:2017> * 8],
	[<gregtech:ore_granitic_mineral_sand_0:2>, <minecraft:iron_ingot> * 2],
	[<gregtech:meta_dust:335>, <gregtech:meta_ingot:335>],
	[<gregtech:ore_quartzite_1:2>, <gregtech:meta_gem:340> * 2],
	[<gregtech:ore_certus_quartz_1>, <appliedenergistics2:material:0> * 2],
	[<gregtech:meta_dust:261>, <minecraft:iron_ingot>],
	[<gregtech:ore_lepidolite_1>, <gregtech:meta_dust:382> * 2],
	[<qmd:dust:14>, <qmd:ingot:14>],
	[<gregtech:ore_powellite_1:2>, <gregtech:meta_dust:305>],
	[<gregtech:meta_dust:3>, <gregtech:meta_ingot:3>],
	[<gregtech:ore_garnet_sand_0:1>, <gregtech:meta_dust:2515> * 2],
	[<gregtech:ore_redstone_1:3>, <minecraft:redstone> * 5],
	[<gregtech:ore_tricalcium_phosphate_1:2>, <gregtech:meta_dust:2015> * 3],
	[<gregtech:ore_electrotine_1:3>, <gregtech:meta_dust:2507> * 5],
	[<gregtech:ore_chromite_1:3>, <gregtech:meta_dust:267>],
	[<gregtech:ore_blue_topaz_0>, <gregtech:meta_gem:257> * 2],
	[<gregtech:meta_dust_impure:255>, <minecraft:iron_ingot>],
	[<gregtech:meta_dust:109>, <gregtech:meta_ingot:109>],
	[<gregtech:ore_chalcocite_0:2>, <gregtech:meta_ingot:25> * 2],
	[<gregtech:ore_valonite_0>, <thebetweenlands:items_misc:19>],
	[<gregtech:ore_amethyst_0:1>, <gregtech:meta_gem:2006> * 2],
	[<gregtech:ore_lazurite_1:2>, <gregtech:meta_gem:289> * 6],
	[<gregtech:ore_tungstate_0>, <gregtech:meta_dust:330>],
	[<gregtech:ore_realgar_1:1>, <gregtech:meta_gem:365>],
	[<gregtech:ore_tricalcium_phosphate_1:1>, <gregtech:meta_dust:2015> * 3],
	[<gregtech:meta_dust:41>, <minecraft:gold_ingot>],
	[<gregtech:ore_oilsands_1:2>, <gregtech:meta_dust:1597>],
	[<gregtech:ore_banded_iron_0>, <minecraft:iron_ingot>],
	[<gregtech:meta_dust_pure:293>, <gregtech:meta_ingot:64>],
	[<gregtech:ore_bastnasite_0>, <gregtech:meta_dust:379> * 2],
	[<gregtech:ore_powellite_1:1>, <gregtech:meta_dust:305>],
	[<gregtech:ore_nickel_1:1>, <gregtech:meta_ingot:69>],
	[<gregtech:meta_dust_pure:279>, <gregtech:meta_ingot:55>],
	[<gregtech:ore_tantalite_0>, <gregtech:meta_dust:318>],
	[<nuclearcraft:gem_dust:2>, <appliedenergistics2:material:5>],
	[<gregtech:meta_dust:32004>, <enderio:item_alloy_ingot>],
	[<gregtech:ore_molybdenite_1>, <gregtech:meta_ingot:64>],
	[<gregtech:ore_coal_1:3>, <minecraft:coal> * 2],
	[<gregtech:meta_dust:32003>, <enderio:item_alloy_ingot:8>],
	[<gregtech:ore_talc_0>, <gregtech:meta_dust:392> * 2],
	[<gregtech:ore_ruby_1:2>, <gregtech:meta_gem:311>],
	[<gregtech:meta_dust_impure:80>, <gregtech:meta_ingot:80>],
	[<gregtech:ore_quartzite_1:3>, <gregtech:meta_gem:340> * 2],
	[<gregtech:meta_dust:1074>, <gregtech:meta_ingot:1074>],
	[<gregtech:ore_nether_quartz_0:2>, <minecraft:quartz> * 4],
	[<gregtech:ore_banded_iron_1:2>, <minecraft:iron_ingot>],
	[<gregtech:ore_pentlandite_1:3>, <gregtech:meta_ingot:69>],
	[<gregtech:ore_platinum_1:1>, <gregtech:meta_ingot:80>],
	[<gregtech:ore_talc_1:1>, <gregtech:meta_dust:392> * 2],
	[<gregtech:meta_dust_pure:265>, <gregtech:meta_ingot:25>],
	[<gregtech:ore_yellow_limonite_0>, <minecraft:iron_ingot>],
	[<gregtech:meta_dust:256>, <gregtech:meta_ingot:256>],
	[<gregtech:ore_chalcopyrite_1:3>, <gregtech:meta_ingot:25>],
	[<gregtech:ore_realgar_0:2>, <gregtech:meta_gem:365> * 2],
	[<gregtech:ore_barite_1>, <gregtech:meta_dust:387>],
	[<gregtech:ore_powellite_0:1>, <gregtech:meta_dust:305> * 2],
	[<gregtech:ore_zeolite_1:3>, <gregtech:meta_dust:2033> * 3],
	[<gregtech:meta_dust_impure:69>, <gregtech:meta_ingot:69>],
	[<gregtech:ore_green_sapphire_0:1>, <gregtech:meta_gem:281> * 2],
	[<gregtech:ore_tricalcium_phosphate_1>, <gregtech:meta_dust:2015> * 3],
	[<gregtech:ore_plutonium_0>, <gregtech:meta_ingot:81>],
	[<gregtech:ore_tungstate_1:1>, <gregtech:meta_dust:330>],
	[<gregtech:ore_chromite_0:1>, <gregtech:meta_dust:267> * 2],
	[<gregtech:meta_dust_impure:25>, <gregtech:meta_ingot:25>],
	[<gregtech:ore_valonite_1:3>, <thebetweenlands:items_misc:19>],
	[<gregtech:ore_uraninite_1:3>, <gregtech:meta_dust:332>],
	[<gregtech:meta_dust:32151>, <gregtech:meta_ingot:32151>],
	[<gregtech:ore_garnet_sand_1:1>, <gregtech:meta_dust:2515>],
	[<gregtech:meta_dust_pure:322>, <gregtech:meta_ingot:122>],
	[<gregtech:ore_scheelite_0:2>, <gregtech:meta_dust:315> * 2],
	[<gregtech:ore_fullers_earth_0>, <gregtech:meta_dust:2027> * 2],
	[<gregtech:ore_scabyst_0:1>, <thebetweenlands:items_misc:39> * 2],
	[<gregtech:ore_pyrochlore_0:2>, <gregtech:meta_dust:449> * 2],
	[<gregtech:meta_dust_pure:327>, <gregtech:meta_ingot:25>],
	[<gregtech:ore_diatomite_1:3>, <gregtech:meta_dust:2509>],
	[<gregtech:ore_topaz_0:2>, <gregtech:meta_gem:329> * 2],
	[<gregtech:ore_trona_0:1>, <gregtech:meta_dust:2031> * 4],
	[<gregtech:meta_dust_pure:325>, <gregtech:meta_ingot:4>],
	[<gregtech:ore_barite_1:1>, <gregtech:meta_dust:387>],
	[<gregtech:ore_yellow_limonite_0:1>, <minecraft:iron_ingot> * 2],
	[<gregtech:ore_almandine_1:2>, <gregtech:meta_gem:250> * 3],
	[<gregtech:ore_bastnasite_0:1>, <gregtech:meta_dust:379> * 4],
	[<gregtech:ore_magnetite_0:2>, <minecraft:iron_ingot> * 2],
	[<gregtech:ore_olivine_1:2>, <gregtech:meta_gem:2004> * 2],
	[<gregtech:meta_dust:23>, <gregtech:meta_ingot:23>],
	[<gregtech:ore_realgar_0>, <gregtech:meta_gem:365>],
	[<gregtech:ore_saltpeter_1:2>, <gregtech:meta_dust:313> * 2],
	[<gregtech:ore_quartzite_1:1>, <gregtech:meta_gem:340> * 2],
	[<gregtech:ore_sphalerite_1>, <gregtech:meta_ingot:122>],
	[<gregtech:ore_garnet_sand_1>, <gregtech:meta_dust:2515>],
	[<gregtech:ore_sphalerite_0>, <gregtech:meta_ingot:122>],
	[<gregtech:ore_cinnabar_1>, <gregtech:meta_gem:268>],
	[<gregtech:ore_green_sapphire_1:2>, <gregtech:meta_gem:281>],
	[<gregtech:ore_sulfur_0>, <gregtech:meta_dust:103>],
	[<lucraftcore:ore_copper>, <gregtech:meta_ingot:25>],
	[<gregtech:meta_dust_impure:112>, <gregtech:meta_ingot:112>],
	[<gregtech:ore_certus_quartz_1:1>, <appliedenergistics2:material:0> * 2],
	[<gregtech:ore_opal_0>, <gregtech:meta_gem:2005>],
	[<gregtech:ore_redstone_1:2>, <minecraft:redstone> * 5],
	[<nuclearcraft:ore:7>, <nuclearcraft:ingot:7>],
	[<gregtech:ore_soapstone_1>, <gregtech:meta_dust:393> * 3],
	[<gregtech:ore_stibnite_1>, <gregtech:meta_ingot:4>],
	[<gregtech:ore_topaz_1>, <gregtech:meta_gem:329>],
	[<gregtech:ore_garnierite_1:3>, <gregtech:meta_ingot:69>],
	[<gregtech:ore_basaltic_mineral_sand_1>, <minecraft:iron_ingot>],
	[<gregtech:meta_dust:32080>, <thebetweenlands:octine_ingot>],
	[<gregtech:meta_dust_pure:51>, <minecraft:iron_ingot>],
	[<gregtech:ore_apatite_1:2>, <gregtech:meta_gem:2010> * 4],
	[<gregtech:ore_octine_1:3>, <thebetweenlands:octine_ingot>],
	[<gregtech:meta_dust:32015>, <enderio:item_alloy_endergy_ingot:4>],
	[<gregtech:ore_cobalt_1>, <gregtech:meta_ingot:23>],
	[<gregtech:ore_garnet_red_1:1>, <gregtech:meta_gem:2016> * 4],
	[<gregtech:ore_molybdenum_1:1>, <gregtech:meta_ingot:64>],
	[<gregtech:ore_pollucite_1:3>, <gregtech:meta_dust:2024>],
	[<gregtech:ore_fullers_earth_1:3>, <gregtech:meta_dust:2027> * 2],
	[<gregtech:meta_dust:32081>, <thebetweenlands:items_misc:11>],
	[<gregtech:ore_tetrahedrite_1:3>, <gregtech:meta_ingot:25>],
	[<gregtech:ore_spodumene_1:1>, <gregtech:meta_dust:381>],
	[<gregtech:ore_salt_1:2>, <gregtech:meta_gem:312> * 2],
	[<gregtech:meta_dust_pure:32080>, <thebetweenlands:octine_ingot>],
	[<gregtech:ore_almandine_0:2>, <gregtech:meta_gem:250> * 6],
	[<gregtech:ore_garnet_yellow_1>, <gregtech:meta_gem:2017> * 4],
	[<gregtech:meta_dust_pure:348>, <gregtech:meta_ingot:25>],
	[<gregtech:meta_dust_pure:25>, <gregtech:meta_ingot:25>],
	[<gregtech:ore_cassiterite_sand_0:2>, <gregtech:meta_ingot:112> * 4],
	[<gregtech:ore_molybdenite_0>, <gregtech:meta_ingot:64>],
	[<gregtech:ore_blue_topaz_0:1>, <gregtech:meta_gem:257> * 4],
	[<gregtech:ore_coal_0>, <minecraft:coal> * 2],
	[<gregtech:ore_lead_0:2>, <gregtech:meta_ingot:55> * 2],
	[<gregtech:ore_valonite_1:2>, <thebetweenlands:items_misc:19>],
	[<gregtech:ore_gold_1:3>, <minecraft:gold_ingot>],
	[<gregtech:ore_valonite_1:1>, <thebetweenlands:items_misc:19>],
	[<gregtech:ore_diamond_1>, <minecraft:diamond>],
	[<gregtech:ore_trona_0:2>, <gregtech:meta_dust:2031> * 4],
	[<gregtech:ore_lead_1>, <gregtech:meta_ingot:55>],
	[<gregtech:ore_pyrope_1:1>, <gregtech:meta_gem:308> * 3],
	[<gregtech:ore_kyanite_0:1>, <gregtech:meta_dust:394> * 2],
	[<gregtech:ore_garnet_red_1>, <gregtech:meta_gem:2016> * 4],
	[<gregtech:meta_dust_pure:41>, <minecraft:gold_ingot>],
	[<lucraftcore:ore_tin>, <gregtech:meta_ingot:112>],
	[<gregtech:ore_wulfenite_0>, <gregtech:meta_dust:336>],
	[<actuallyadditions:block_misc:3>, <actuallyadditions:item_misc:5>],
	[<gregtech:ore_mica_0:1>, <gregtech:meta_dust:386> * 4],
	[<gregtech:ore_plutonium_1>, <gregtech:meta_ingot:81>],
	[<gregtech:ore_asbestos_1>, <gregtech:meta_dust:253> * 3],
	[<gregtech:ore_magnetite_1:2>, <minecraft:iron_ingot>],
	[<gregtech:ore_nickel_0>, <gregtech:meta_ingot:69>],
	[<gregtech:ore_almandine_1:3>, <gregtech:meta_gem:250> * 3],
	[<appliedenergistics2:quartz_ore>, <appliedenergistics2:material:0> * 2],
	[<gregtech:ore_nickel_0:2>, <gregtech:meta_ingot:69> * 2],
	[<gregtech:ore_cassiterite_sand_0>, <gregtech:meta_ingot:112> * 2],
	[<gregtech:ore_scabyst_0:2>, <thebetweenlands:items_misc:39> * 2],
	[<gregtech:ore_opal_1:1>, <gregtech:meta_gem:2005>],
	[<gregtech:ore_sodalite_1:2>, <gregtech:meta_gem:316> * 6],
	[<industrialrenewal:chunk_hematite>, <minecraft:iron_ingot>],
	[<gregtech:ore_lepidolite_1:3>, <gregtech:meta_dust:382> * 2],
	[<gregtech:meta_dust:69>, <gregtech:meta_ingot:69>],
	[<gregtech:ore_opal_1:3>, <gregtech:meta_gem:2005>],
	[<gregtech:ore_grossular_0>, <gregtech:meta_gem:282> * 3],
	[<gregtech:ore_alunite_0>, <gregtech:meta_dust:388> * 3],
	[<gregtech:ore_wulfenite_1>, <gregtech:meta_dust:336>],
	[<gregtech:ore_granitic_mineral_sand_1:3>, <minecraft:iron_ingot>],
	[<gregtech:ore_platinum_0:1>, <gregtech:meta_ingot:80> * 2],
	[<gregtech:ore_lead_1:1>, <gregtech:meta_ingot:55>],
	[<gregtech:ore_green_sapphire_1:3>, <gregtech:meta_gem:281>],
	[<lucraftcore:ore_nickel>, <gregtech:meta_ingot:69>],
	[<gregtech:ore_blue_topaz_1>, <gregtech:meta_gem:257> * 2],
	[<gregtech:ore_pyrope_1>, <gregtech:meta_gem:308> * 3],
	[<gregtech:ore_galena_0:2>, <gregtech:meta_ingot:55> * 2],
	[<gregtech:ore_glauconite_sand_1:3>, <gregtech:meta_dust:384> * 3],
	[<gregtech:ore_lead_0:1>, <gregtech:meta_ingot:55> * 2],
	[<gregtech:ore_saltpeter_0:1>, <gregtech:meta_dust:313> * 4],
	[<erebus:ore_encrusted_diamond>, <minecraft:diamond>],
	[<gregtech:ore_uraninite_0>, <gregtech:meta_dust:332>],
	[<gregtech:ore_sapphire_1>, <gregtech:meta_gem:314>],
	[<gregtech:meta_dust_impure:322>, <gregtech:meta_ingot:122>],
	[<gregtech:ore_brown_limonite_0:1>, <minecraft:iron_ingot> * 2],
	[<gregtech:ore_pitchblende_1:1>, <gregtech:meta_dust:2028>],
	[<gregtech:meta_dust:2527>, <gregtech:meta_ingot:2527>],
	[<gregtech:meta_dust_impure:64>, <gregtech:meta_ingot:64>],
	[<gregtech:meta_dust_pure:23>, <gregtech:meta_ingot:23>],
	[<gregtech:ore_galena_0>, <gregtech:meta_ingot:55>],
	[<gregtech:ore_kyanite_0:2>, <gregtech:meta_dust:394> * 2],
	[<gregtech:ore_thorium_1:2>, <gregtech:meta_ingot:109>],
	[<gregtech:ore_pitchblende_0:1>, <gregtech:meta_dust:2028> * 2],
	[<gregtech:ore_bauxite_1:2>, <gregtech:meta_dust:286>],
	[<gregtech:meta_dust:322>, <gregtech:meta_ingot:122>],
	[<gregtech:ore_beryllium_1:1>, <gregtech:meta_ingot:10>],
	[<gregtech:ore_platinum_0:2>, <gregtech:meta_ingot:80> * 2],
	[<gregtech:ore_tin_1:2>, <gregtech:meta_ingot:112>],
	[<gregtech:ore_olivine_1:3>, <gregtech:meta_gem:2004> * 2],
	[<gregtech:ore_lazurite_0>, <gregtech:meta_gem:289> * 6],
	[<gregtech:ore_thorium_0>, <gregtech:meta_ingot:109>],
	[<gregtech:ore_soapstone_1:2>, <gregtech:meta_dust:393> * 3],
	[<gregtech:ore_ilmenite_1:2>, <gregtech:meta_dust:284>],
	[<gregtech:ore_uraninite_0:2>, <gregtech:meta_dust:332> * 2],
	[<gregtech:ore_stibnite_0:2>, <gregtech:meta_ingot:4> * 2],
	[<gregtech:ore_saltpeter_0:2>, <gregtech:meta_dust:313> * 4],
	[<gregtech:ore_amethyst_0:2>, <gregtech:meta_gem:2006> * 2],
	[<gregtech:ore_lapis_0:2>, <minecraft:dye:4> * 12],
	[<gregtech:ore_stibnite_1:2>, <gregtech:meta_ingot:4>],
	[<gregtech:ore_cooperite_0>, <gregtech:meta_dust:273>],
	[<gregtech:ore_certus_quartz_1:2>, <appliedenergistics2:material:0> * 2],
	[<gregtech:ore_ruby_0>, <gregtech:meta_gem:311>],
	[<gregtech:ore_gold_1:1>, <minecraft:gold_ingot>],
	[<gregtech:ore_tungstate_1>, <gregtech:meta_dust:330>],
	[<gregtech:ore_tetrahedrite_1:2>, <gregtech:meta_ingot:25>],
	[<gregtech:ore_vanadium_magnetite_1>, <gregtech:meta_dust:2022>],
	[<gregtech:meta_dust:272>, <gregtech:meta_ingot:23>],
	[<gregtech:ore_cassiterite_1:2>, <gregtech:meta_ingot:112> * 2],
	[<gregtech:meta_dust_impure:81>, <gregtech:meta_ingot:81>],
	[<gregtech:ore_bentonite_0:1>, <gregtech:meta_dust:2026> * 6],
	[<gregtech:meta_dust:32010>, <enderio:item_alloy_ingot:1>],
	[<gregtech:ore_graphite_0>, <gregtech:meta_dust:341>],
	[<gregtech:meta_dust:293>, <gregtech:meta_ingot:64>],
	[<gregtech:ore_malachite_1:1>, <gregtech:meta_ingot:25>],
	[<gregtech:meta_dust:61>, <gregtech:meta_ingot:61>],
	[<gregtech:ore_cobaltite_0:2>, <gregtech:meta_ingot:23> * 2],
	[<gregtech:ore_zeolite_0>, <gregtech:meta_dust:2033> * 3],
	[<gregtech:ore_magnesite_1>, <gregtech:meta_dust:59>],
	[<gregtech:ore_molybdenum_1:2>, <gregtech:meta_ingot:64>],
	[<gregtech:meta_dust:64>, <gregtech:meta_ingot:64>],
	[<gregtech:ore_scheelite_1:3>, <gregtech:meta_dust:315>],
	[<gregtech:ore_fullers_earth_0:1>, <gregtech:meta_dust:2027> * 4],
	[<gregtech:ore_barite_1:2>, <gregtech:meta_dust:387>],
	[<gregtech:meta_dust:32016>, <enderio:item_alloy_endergy_ingot:5>],
	[<gregtech:ore_bentonite_1:1>, <gregtech:meta_dust:2026> * 3],
	[<libvulpes:ore0>, <libvulpes:productdust>],
	[<gregtech:ore_pyrite_1:3>, <minecraft:iron_ingot>],
	[<gregtech:ore_cassiterite_1:1>, <gregtech:meta_ingot:112> * 2],
	[<gregtech:ore_lapis_0:1>, <minecraft:dye:4> * 12],
	[<gregtech:ore_lepidolite_1:1>, <gregtech:meta_dust:382> * 2],
	[<gregtech:ore_bauxite_0>, <gregtech:meta_dust:286>],
	[<gregtech:ore_sapphire_1:2>, <gregtech:meta_gem:314>],
	[<gregtech:ore_amethyst_1:1>, <gregtech:meta_gem:2006>],
	[<gregtech:ore_syrmorite_1:2>, <thebetweenlands:items_misc:11>],
	[<gregtech:ore_brown_limonite_0:2>, <minecraft:iron_ingot> * 2],
	[<gregtech:ore_molybdenite_1:1>, <gregtech:meta_ingot:64>],
	[<gregtech:meta_dust:2035>, <gregtech:meta_dust:324>],
	[<erebus:ore_diamond>, <minecraft:diamond>],
	[<gregtech:ore_banded_iron_0:2>, <minecraft:iron_ingot> * 2],
	[<gregtech:ore_cobaltite_1:2>, <gregtech:meta_ingot:23>],
	[<gregtech:ore_coal_1:2>, <minecraft:coal> * 2],
	[<gregtech:ore_copper_1:1>, <gregtech:meta_ingot:25>],
	[<gregtech:ore_scheelite_0:1>, <gregtech:meta_dust:315> * 2],
	[<gregtech:ore_sulfur_1:1>, <gregtech:meta_dust:103>],
	[<gregtech:ore_silver_1:1>, <gregtech:meta_ingot:100>],
	[<gregtech:ore_glauconite_sand_0:2>, <gregtech:meta_dust:384> * 6],
	[<gregtech:ore_lithium_1>, <gregtech:meta_dust:56>],
	[<gregtech:ore_chalcocite_1>, <gregtech:meta_ingot:25>],
	[<gregtech:ore_almandine_1:1>, <gregtech:meta_gem:250> * 3],
	[<gregtech:ore_pyrite_1:2>, <minecraft:iron_ingot>],
	[<gregtech:ore_beryllium_1:2>, <gregtech:meta_ingot:10>],
	[<gregtech:meta_dust_impure:32080>, <thebetweenlands:octine_ingot>],
	[<gregtech:ore_apatite_0>, <gregtech:meta_gem:2010> * 4],
	[<gregtech:ore_syrmorite_0:1>, <thebetweenlands:items_misc:11> * 2],
	[<gregtech:ore_molybdenum_0:2>, <gregtech:meta_ingot:64> * 2],
	[<gregtech:ore_sapphire_1:3>, <gregtech:meta_gem:314>],
	[<gregtech:ore_lithium_1:2>, <gregtech:meta_dust:56>],
	[<gregtech:meta_dust:116>, <gregtech:meta_ingot:116>],
	[<gregtech:ore_barite_0:1>, <gregtech:meta_dust:387> * 2],
	[<gregtech:ore_cinnabar_1:2>, <gregtech:meta_gem:268>],
	[<gregtech:ore_garnet_red_0:1>, <gregtech:meta_gem:2016> * 8],
	[<gregtech:ore_cooperite_1:2>, <gregtech:meta_dust:273>],
	[<gregtech:ore_beryllium_1:3>, <gregtech:meta_ingot:10>],
	[<gregtech:ore_uraninite_0:1>, <gregtech:meta_dust:332> * 2],
	[<gregtech:ore_syrmorite_1:1>, <thebetweenlands:items_misc:11>],
	[<gregtech:ore_spessartine_0:1>, <gregtech:meta_gem:321> * 6],
	[<gregtech:meta_dust:385>, <gregtech:meta_ingot:25>],
	[<gregtech:ore_tungstate_1:2>, <gregtech:meta_dust:330>],
	[<gregtech:ore_stibnite_0>, <gregtech:meta_ingot:4>],
	[<gregtech:ore_kyanite_1>, <gregtech:meta_dust:394>],
	[<gregtech:ore_cobalt_0>, <gregtech:meta_ingot:23>],
	[<gregtech:ore_trona_1>, <gregtech:meta_dust:2031> * 2],
	[<gregtech:ore_copper_1:3>, <gregtech:meta_ingot:25>],
	[<gregtech:ore_graphite_1:3>, <gregtech:meta_dust:341>],
	[<gregtech:ore_malachite_1:2>, <gregtech:meta_ingot:25>],
	[<gregtech:ore_octine_0>, <thebetweenlands:octine_ingot>],
	[<gregtech:ore_wulfenite_1:3>, <gregtech:meta_dust:336>],
	[<gregtech:ore_cobaltite_0>, <gregtech:meta_ingot:23>],
	[<gregtech:ore_realgar_1>, <gregtech:meta_gem:365>],
	[<gregtech:meta_dust:2014>, <gregtech:meta_ingot:2014>],
	[<gregtech:meta_dust:320>, <gregtech:meta_ingot:320>],
	[<gregtech:ore_talc_0:2>, <gregtech:meta_dust:392> * 4],
	[<gregtech:ore_sphalerite_1:3>, <gregtech:meta_ingot:122>],
	[<erebus:ore_gold>, <minecraft:gold_ingot>],
	[<gregtech:ore_stibnite_0:1>, <gregtech:meta_ingot:4> * 2],
	[<gregtech:ore_tungstate_1:3>, <gregtech:meta_dust:330>],
	[<gregtech:ore_electrotine_0:2>, <gregtech:meta_dust:2507> * 10],
	[<gregtech:ore_silver_0:1>, <gregtech:meta_ingot:100> * 2],
	[<gregtech:ore_wulfenite_0:2>, <gregtech:meta_dust:336> * 2],
	[<gregtech:ore_stibnite_1:1>, <gregtech:meta_ingot:4>],
	[<gregtech:meta_dust:2037>, <gregtech:meta_ingot:2037>],
	[<gregtech:ore_trona_1:1>, <gregtech:meta_dust:2031> * 2],
	[<gregtech:ore_uraninite_1:2>, <gregtech:meta_dust:332>],
	[<erebus:ore_lapis>, <minecraft:dye:4> * 6],
	[<nuclearcraft:ore:3>, <gregtech:meta_ingot:109>],
	[<gregtech:ore_mica_1:3>, <gregtech:meta_dust:386> * 2],
	[<gregtech:ore_molybdenum_0>, <gregtech:meta_ingot:64>],
	[<nuclearcraft:gem_dust:1>, <nuclearcraft:dust:14>],
	[<gregtech:ore_bornite_1>, <gregtech:meta_ingot:25>],
	[<gregtech:meta_dust:32005>, <enderio:item_alloy_ingot:6>],
	[<gregtech:ore_electrotine_1:1>, <gregtech:meta_dust:2507> * 5],
	[<gregtech:meta_dust:252>, <gregtech:meta_ingot:252>],
	[<gregtech:ore_yellow_limonite_1:1>, <minecraft:iron_ingot>],
	[<gregtech:ore_cassiterite_1:3>, <gregtech:meta_ingot:112> * 2],
	[<gregtech:ore_nickel_0:1>, <gregtech:meta_ingot:69> * 2],
	[<gregtech:ore_pyrope_0>, <gregtech:meta_gem:308> * 3],
	[<gregtech:ore_rock_salt_0:1>, <gregtech:meta_gem:309> * 4],
	[<gregtech:ore_certus_quartz_1:3>, <appliedenergistics2:material:0> * 2],
	[<gregtech:meta_dust_pure:2518>, <minecraft:iron_ingot>],
	[<gregtech:ore_gypsum_0:1>, <gregtech:meta_dust:2032> * 2],
	[<gregtech:ore_valonite_1>, <thebetweenlands:items_misc:19>],
	[<gregtech:ore_olivine_0>, <gregtech:meta_gem:2004> * 2],
	[<gregtech:ore_alunite_1:2>, <gregtech:meta_dust:388> * 3],
	[<gregtech:ore_chalcopyrite_0>, <gregtech:meta_ingot:25>],
	[<gregtech:ore_cassiterite_sand_1:2>, <gregtech:meta_ingot:112> * 2],
	[<gregtech:ore_spodumene_0:1>, <gregtech:meta_dust:381> * 2],
	[<gregtech:ore_sodalite_0>, <gregtech:meta_gem:316> * 6],
	[<gregtech:ore_pentlandite_1>, <gregtech:meta_ingot:69>],
	[<gregtech:ore_fullers_earth_1:2>, <gregtech:meta_dust:2027> * 2],
	[<gregtech:ore_quartzite_0:2>, <gregtech:meta_gem:340> * 4],
	[<gregtech:ore_magnetite_0>, <minecraft:iron_ingot>],
	[<gregtech:ore_asbestos_0>, <gregtech:meta_dust:253> * 3],
	[<gregtech:ore_valonite_0:1>, <thebetweenlands:items_misc:19> * 2],
	[<gregtech:ore_green_sapphire_0:2>, <gregtech:meta_gem:281> * 2],
	[<gregtech:meta_dust_impure:306>, <minecraft:iron_ingot>],
	[<gregtech:ore_lithium_0:1>, <gregtech:meta_dust:56> * 2],
	[<gregtech:meta_dust:2038>, <gregtech:meta_ingot:2038>],
	[<gregtech:ore_tantalite_0:2>, <gregtech:meta_dust:318> * 2],
	[<gregtech:ore_saltpeter_1:3>, <gregtech:meta_dust:313> * 2],
	[<gregtech:meta_dust_pure:280>, <gregtech:meta_ingot:69>],
	[<nuclearcraft:dust:12>, <nuclearcraft:ingot:12>],
	[<gregtech:ore_nickel_1:2>, <gregtech:meta_ingot:69>],
	[<gregtech:meta_dust:328>, <gregtech:meta_ingot:328>],
	[<gregtech:ore_molybdenite_1:2>, <gregtech:meta_ingot:64>],
	[<gregtech:ore_stibnite_1:3>, <gregtech:meta_ingot:4>],
	[<gregtech:ore_granitic_mineral_sand_1:2>, <minecraft:iron_ingot>],
	[<gregtech:ore_garnierite_0:2>, <gregtech:meta_ingot:69> * 2],
	[<gregtech:ore_octine_0:1>, <thebetweenlands:octine_ingot> * 2],
	[<gregtech:ore_tricalcium_phosphate_0>, <gregtech:meta_dust:2015> * 3],
	[<gregtech:meta_dust:48>, <gregtech:meta_ingot:48>],
	[<gregtech:ore_pyrope_0:2>, <gregtech:meta_gem:308> * 6],
	[<gregtech:ore_monazite_1>, <gregtech:meta_gem:2029> * 4],
	[<gregtech:ore_iron_1:2>, <minecraft:iron_ingot>],
	[<gregtech:ore_tricalcium_phosphate_0:1>, <gregtech:meta_dust:2015> * 6],
	[<gregtech:meta_dust:39>, <gregtech:meta_ingot:39>],
	[<gregtech:ore_alunite_0:2>, <gregtech:meta_dust:388> * 6],
	[<gregtech:ore_talc_1>, <gregtech:meta_dust:392> * 2],
	[<gregtech:meta_dust:348>, <gregtech:meta_ingot:25>],
	[<gregtech:ore_basaltic_mineral_sand_1:1>, <minecraft:iron_ingot>],
	[<gregtech:ore_alunite_1:3>, <gregtech:meta_dust:388> * 3],
	[<gregtech:ore_amethyst_1>, <gregtech:meta_gem:2006>],
	[<gregtech:ore_emerald_1:3>, <minecraft:emerald> * 2],
	[<gregtech:ore_ilmenite_0:2>, <gregtech:meta_dust:284> * 2],
	[<gregtech:ore_vanadium_magnetite_0>, <gregtech:meta_dust:2022>],
	[<gregtech:ore_garnet_red_0>, <gregtech:meta_gem:2016> * 4],
	[<gregtech:meta_dust:81>, <gregtech:meta_ingot:81>],
	[<gregtech:ore_granitic_mineral_sand_1:1>, <minecraft:iron_ingot>],
	[<gregtech:ore_nether_quartz_1:2>, <minecraft:quartz> * 2],
	[<gregtech:ore_valonite_0:2>, <thebetweenlands:items_misc:19> * 2],
	[<gregtech:ore_soapstone_1:1>, <gregtech:meta_dust:393> * 3],
	[<gregtech:ore_gold_1:2>, <minecraft:gold_ingot>],
	[<gregtech:ore_chalcocite_1:2>, <gregtech:meta_ingot:25>],
	[<gregtech:ore_garnierite_1>, <gregtech:meta_ingot:69>],
	[<gregtech:meta_dust:32013>, <enderio:item_alloy_endergy_ingot:2>],
	[<gregtech:ore_wulfenite_1:2>, <gregtech:meta_dust:336>],
	[<gregtech:ore_pyrope_1:2>, <gregtech:meta_gem:308> * 3],
	[<gregtech:meta_dust_impure:261>, <minecraft:iron_ingot>],
	[<gregtech:ore_vanadium_magnetite_0:1>, <gregtech:meta_dust:2022> * 2],
	[<gregtech:ore_scabyst_1>, <thebetweenlands:items_misc:39>],
	[<gregtech:ore_chalcopyrite_0:1>, <gregtech:meta_ingot:25> * 2],
	[<gregtech:ore_nickel_1:3>, <gregtech:meta_ingot:69>],
	[<gregtech:meta_dust_impure:32081>, <thebetweenlands:items_misc:11>],
	[<gregtech:meta_dust:82>, <gregtech:meta_ingot:82>],
	[<gregtech:ore_bornite_0:1>, <gregtech:meta_ingot:25> * 2],
	[<gregtech:meta_dust:277>, <gregtech:meta_ingot:277>],
	[<gregtech:meta_dust_pure:307>, <gregtech:meta_ingot:61>],
	[<gregtech:ore_galena_1:3>, <gregtech:meta_ingot:55>],
	[<gregtech:ore_magnetite_1:3>, <minecraft:iron_ingot>],
	[<gregtech:ore_pyrolusite_1:2>, <gregtech:meta_ingot:61>],
	[<gregtech:ore_tantalite_1:3>, <gregtech:meta_dust:318>],
	[<gregtech:ore_pyrite_0:1>, <minecraft:iron_ingot> * 2],
	[<gregtech:ore_scheelite_1>, <gregtech:meta_dust:315>],
	[<gregtech:meta_dust:55>, <gregtech:meta_ingot:55>],
	[<gregtech:ore_granitic_mineral_sand_0:1>, <minecraft:iron_ingot> * 2],
	[<gregtech:meta_dust:27>, <gregtech:meta_ingot:27>],
	[<gregtech:ore_amethyst_0>, <gregtech:meta_gem:2006>],
	[<gregtech:ore_fullers_earth_1>, <gregtech:meta_dust:2027> * 2],
	[<gregtech:ore_graphite_1:1>, <gregtech:meta_dust:341>],
	[<gregtech:ore_galena_0:1>, <gregtech:meta_ingot:55> * 2],
	[<gregtech:ore_garnet_sand_1:3>, <gregtech:meta_dust:2515>],
	[<gregtech:ore_banded_iron_1:3>, <minecraft:iron_ingot>],
	[<gregtech:meta_dust:122>, <gregtech:meta_ingot:122>],
	[<gregtech:ore_cassiterite_sand_1:3>, <gregtech:meta_ingot:112> * 2],
	[<gregtech:ore_pollucite_0:2>, <gregtech:meta_dust:2024> * 2],
	[<gregtech:ore_vanadium_magnetite_1:2>, <gregtech:meta_dust:2022>],
	[<gregtech:ore_opal_1:2>, <gregtech:meta_gem:2005>],
	[<gregtech:meta_dust:423>, <gregtech:meta_dust:95>],
	[<gregtech:ore_gypsum_0>, <gregtech:meta_dust:2032>],
	[<gregtech:ore_sphalerite_0:2>, <gregtech:meta_ingot:122> * 2],
	[<gregtech:meta_dust:32200>, <gregtech:meta_ingot:32200>],
	[<gregtech:ore_bastnasite_0:2>, <gregtech:meta_dust:379> * 4],
	[<gregtech:ore_thorium_0:1>, <gregtech:meta_ingot:109> * 2],
	[<gregtech:ore_amethyst_1:2>, <gregtech:meta_gem:2006>],
	[<gregtech:ore_salt_1:3>, <gregtech:meta_gem:312> * 2],
	[<gregtech:ore_tricalcium_phosphate_0:2>, <gregtech:meta_dust:2015> * 6],
	[<gregtech:ore_cooperite_0:2>, <gregtech:meta_dust:273> * 2],
	[<gregtech:ore_beryllium_1>, <gregtech:meta_ingot:10>],
	[<gregtech:ore_grossular_1:3>, <gregtech:meta_gem:282> * 3],
	[<gregtech:ore_cinnabar_0:1>, <gregtech:meta_gem:268> * 2],
	[<gregtech:meta_dust:290>, <gregtech:meta_ingot:290>],
	[<gregtech:ore_copper_1:2>, <gregtech:meta_ingot:25>],
	[<gregtech:ore_scabyst_1:1>, <thebetweenlands:items_misc:39>],
	[<gregtech:ore_garnierite_0>, <gregtech:meta_ingot:69>],
	[<gregtech:meta_dust_impure:41>, <minecraft:gold_ingot>],
	[<gregtech:ore_emerald_1:1>, <minecraft:emerald> * 2],
	[<gregtech:meta_dust_pure:112>, <gregtech:meta_ingot:112>],
	[<gregtech:ore_coal_0:1>, <minecraft:coal> * 4],
	[<gregtech:ore_zeolite_1:1>, <gregtech:meta_dust:2033> * 3],
	[<gregtech:ore_iron_0:1>, <minecraft:iron_ingot> * 2],
	[<gregtech:meta_dust:117>, <gregtech:meta_ingot:117>],
	[<gregtech:ore_salt_1:1>, <gregtech:meta_gem:312> * 2],
	[<gregtech:ore_glauconite_sand_1>, <gregtech:meta_dust:384> * 3],
	[<gregtech:ore_thorium_1>, <gregtech:meta_ingot:109>],
	[<gregtech:ore_mica_1:2>, <gregtech:meta_dust:386> * 2],
	[<gregtech:ore_nether_quartz_0>, <minecraft:quartz> * 2],
	[<gregtech:ore_talc_0:1>, <gregtech:meta_dust:392> * 4],
	[<gregtech:meta_dust_pure:380>, <gregtech:meta_ingot:69>],
	[<gregtech:ore_redstone_1>, <minecraft:redstone> * 5],
	[<gregtech:ore_diamond_0>, <minecraft:diamond>],
	[<gregtech:ore_grossular_0:2>, <gregtech:meta_gem:282> * 6],
	[<gregtech:ore_magnetite_1>, <minecraft:iron_ingot>],
	[<gregtech:ore_salt_0:2>, <gregtech:meta_gem:312> * 4],
	[<gregtech:ore_pitchblende_0:2>, <gregtech:meta_dust:2028> * 2],
	[<gregtech:ore_saltpeter_0>, <gregtech:meta_dust:313> * 2],
	[<gregtech:meta_dust_pure:272>, <gregtech:meta_ingot:23>],
	[<qmd:dust:6>, <qmd:ingot:6>],
	[<nuclearcraft:dust:10>, <nuclearcraft:ingot:10>],
	[<gregtech:ore_gypsum_1:2>, <gregtech:meta_dust:2032>],
	[<gregtech:ore_ruby_0:2>, <gregtech:meta_gem:311> * 2],
	[<gregtech:ore_ilmenite_0:1>, <gregtech:meta_dust:284> * 2],
	[<gregtech:ore_calcite_0>, <gregtech:meta_dust:262>],
	[<gregtech:ore_tungstate_0:1>, <gregtech:meta_dust:330> * 2],
	[<gregtech:ore_lepidolite_0:2>, <gregtech:meta_dust:382> * 4],
	[<gregtech:ore_garnet_sand_0:2>, <gregtech:meta_dust:2515> * 2],
	[<gregtech:ore_magnesite_0:1>, <gregtech:meta_dust:59> * 2],
	[<gregtech:ore_diamond_1:2>, <minecraft:diamond>],
	[<gregtech:meta_dust_impure:307>, <gregtech:meta_ingot:61>],
	[<gregtech:ore_cobalt_0:1>, <gregtech:meta_ingot:23> * 2],
	[<gregtech:meta_dust:100>, <gregtech:meta_ingot:100>],
	[<gregtech:ore_garnierite_0:1>, <gregtech:meta_ingot:69> * 2],
	[<gregtech:ore_plutonium_1:1>, <gregtech:meta_ingot:81>],
	[<gregtech:ore_wulfenite_1:1>, <gregtech:meta_dust:336>],
	[<gregtech:meta_dust_pure:263>, <gregtech:meta_ingot:112>],
	[<gregtech:ore_pyrite_0:2>, <minecraft:iron_ingot> * 2],
	[<gregtech:ore_almandine_0:1>, <gregtech:meta_gem:250> * 6],
	[<gregtech:meta_dust:279>, <gregtech:meta_ingot:55>],
	[<lucraftcore:ore_silver>, <gregtech:meta_ingot:100>],
	[<gregtech:ore_glauconite_sand_0>, <gregtech:meta_dust:384> * 3],
	[<appliedenergistics2:charged_quartz_ore>, <appliedenergistics2:material:0> * 2],
	[<gregtech:ore_asbestos_1:3>, <gregtech:meta_dust:253> * 3],
	[<gregtech:meta_dust:274>, <gregtech:meta_ingot:274>],
	[<gregtech:ore_lead_0>, <gregtech:meta_ingot:55>],
	[<gregtech:ore_basaltic_mineral_sand_0:1>, <minecraft:iron_ingot> * 2],
	[<gregtech:ore_graphite_0:2>, <gregtech:meta_dust:341> * 2],
	[<gregtech:ore_silver_0>, <gregtech:meta_ingot:100>],
	[<gregtech:ore_basaltic_mineral_sand_0>, <minecraft:iron_ingot>],
	[<gregtech:meta_dust:32008>, <enderio:item_alloy_ingot:3>],
	[<gregtech:ore_asbestos_1:1>, <gregtech:meta_dust:253> * 3],
	[<gregtech:ore_lapis_1:1>, <minecraft:dye:4> * 6],
	[<gregtech:ore_kyanite_1:3>, <gregtech:meta_dust:394>],
	[<gregtech:ore_realgar_1:2>, <gregtech:meta_gem:365>],
	[<gregtech:ore_salt_0:1>, <gregtech:meta_gem:312> * 4],
	[<gregtech:ore_garnet_sand_0>, <gregtech:meta_dust:2515>],
	[<gregtech:meta_dust:32012>, <enderio:item_alloy_endergy_ingot:1>],
	[<gregtech:ore_wulfenite_0:1>, <gregtech:meta_dust:336> * 2],
	[<gregtech:ore_sapphire_1:1>, <gregtech:meta_gem:314>],
	[<gregtech:ore_spodumene_1>, <gregtech:meta_dust:381>],
	[<gregtech:ore_saltpeter_1>, <gregtech:meta_dust:313> * 2],
	[<gregtech:meta_dust_impure:292>, <minecraft:iron_ingot>],
	[<gregtech:ore_pentlandite_0>, <gregtech:meta_ingot:69>],
	[<gregtech:ore_topaz_0>, <gregtech:meta_gem:329>],
	[<gregtech:ore_pentlandite_1:1>, <gregtech:meta_ingot:69>],
	[<gregtech:ore_pyrolusite_1:1>, <gregtech:meta_ingot:61>],
	[<gregtech:meta_dust:2517>, <gregtech:meta_ingot:2517>],
	[<gregtech:ore_mica_1>, <gregtech:meta_dust:386> * 2],
	[<gregtech:ore_beryllium_0>, <gregtech:meta_ingot:10>],
	[<gregtech:meta_dust:292>, <minecraft:iron_ingot>],
	[<gregtech:ore_syrmorite_1>, <thebetweenlands:items_misc:11>],
	[<gregtech:ore_spodumene_1:3>, <gregtech:meta_dust:381>],
	[<gregtech:ore_olivine_1:1>, <gregtech:meta_gem:2004> * 2],
	[<gregtech:ore_quartzite_1>, <gregtech:meta_gem:340> * 2],
	[<gregtech:ore_bauxite_1:3>, <gregtech:meta_dust:286>],
	[<gregtech:ore_syrmorite_0:2>, <thebetweenlands:items_misc:11> * 2],
	[<gregtech:meta_dust:265>, <gregtech:meta_ingot:25>],
	[<gregtech:ore_iron_0>, <minecraft:iron_ingot>],
	[<gregtech:ore_thorium_1:1>, <gregtech:meta_ingot:109>],
	[<gregtech:meta_dust:347>, <gregtech:meta_ingot:25>],
	[<gregtech:ore_syrmorite_0>, <thebetweenlands:items_misc:11>],
	[<gregtech:ore_soapstone_0:2>, <gregtech:meta_dust:393> * 6],
	[<gregtech:ore_chalcopyrite_1:1>, <gregtech:meta_ingot:25>],
	[<gregtech:ore_asbestos_1:2>, <gregtech:meta_dust:253> * 3],
	[<gregtech:ore_diatomite_0:2>, <gregtech:meta_dust:2509> * 2],
	[<gregtech:ore_coal_1>, <minecraft:coal> * 2],
	[<gregtech:ore_tetrahedrite_0>, <gregtech:meta_ingot:25>],
	[<gregtech:ore_malachite_1:3>, <gregtech:meta_ingot:25>],
	[<gregtech:meta_dust_pure:80>, <gregtech:meta_ingot:80>],
	[<gregtech:ore_octine_1>, <thebetweenlands:octine_ingot>],
	[<gregtech:ore_topaz_1:2>, <gregtech:meta_gem:329>],
	[<gregtech:ore_bauxite_1>, <gregtech:meta_dust:286>],
	[<gregtech:ore_garnet_sand_1:2>, <gregtech:meta_dust:2515>],
	[<gregtech:ore_graphite_0:1>, <gregtech:meta_dust:341> * 2],
	[<gregtech:ore_trona_0>, <gregtech:meta_dust:2031> * 2],
	[<gregtech:ore_ilmenite_0>, <gregtech:meta_dust:284>],
	[<gregtech:meta_dust_impure:55>, <gregtech:meta_ingot:55>],
	[<gregtech:ore_ruby_1:1>, <gregtech:meta_gem:311>],
	[<gregtech:meta_dust_pure:261>, <minecraft:iron_ingot>],
	[<gregtech:meta_dust_impure:2513>, <minecraft:iron_ingot>],
	[<gregtech:ore_plutonium_0:1>, <gregtech:meta_ingot:81> * 2],
	[<gregtech:ore_brown_limonite_1>, <minecraft:iron_ingot>],
	[<gregtech:ore_spessartine_0:2>, <gregtech:meta_gem:321> * 6],
	[<gregtech:ore_bornite_1:2>, <gregtech:meta_ingot:25>],
	[<gregtech:ore_pyrolusite_1:3>, <gregtech:meta_ingot:61>],
	[<gregtech:ore_ilmenite_1:3>, <gregtech:meta_dust:284>],
	[<gregtech:ore_tin_0:2>, <gregtech:meta_ingot:112> * 2],
	[<gregtech:ore_diamond_1:3>, <minecraft:diamond>],
	[<gregtech:meta_dust_pure:109>, <gregtech:meta_ingot:109>],
	[<gregtech:meta_dust:325>, <gregtech:meta_ingot:4>],
	[<gregtech:ore_galena_1>, <gregtech:meta_ingot:55>],
	[<gregtech:ore_pyrochlore_1:1>, <gregtech:meta_dust:449>],
	[<gregtech:ore_spodumene_0>, <gregtech:meta_dust:381>],
	[<gregtech:meta_dust_impure:10>, <gregtech:meta_ingot:10>],
	[<nuclearcraft:ore:4>, <nuclearcraft:ingot:4>],
	[<gregtech:ore_coal_0:2>, <minecraft:coal> * 4],
	[<gregtech:meta_dust:127>, <gregtech:meta_ingot:127>],
	[<gregtech:ore_uraninite_1>, <gregtech:meta_dust:332>],
	[<gregtech:meta_dust:32007>, <enderio:item_alloy_ingot:4>],
	[<gregtech:ore_bastnasite_1:1>, <gregtech:meta_dust:379> * 2],
	[<nuclearcraft:ore:6>, <gregtech:meta_dust:56>],
	[<gregtech:meta_dust_pure:100>, <gregtech:meta_ingot:100>],
	[<gregtech:ore_zeolite_0:1>, <gregtech:meta_dust:2033> * 6],
	[<gregtech:ore_certus_quartz_0:2>, <appliedenergistics2:material:0> * 4],
	[<gregtech:ore_nickel_1>, <gregtech:meta_ingot:69>],
	[<gregtech:ore_iron_0:2>, <minecraft:iron_ingot> * 2],
	[<gregtech:ore_sodalite_0:1>, <gregtech:meta_gem:316> * 12],
	[<gregtech:ore_cobaltite_1:3>, <gregtech:meta_ingot:23>],
	[<gregtech:meta_dust:307>, <gregtech:meta_ingot:61>],
	[<gregtech:ore_ruby_1>, <gregtech:meta_gem:311>],
	[<gregtech:ore_mica_1:1>, <gregtech:meta_dust:386> * 2],
	[<gregtech:ore_cassiterite_0:2>, <gregtech:meta_ingot:112> * 4],
	[<gregtech:ore_olivine_0:2>, <gregtech:meta_gem:2004> * 4],
	[<gregtech:ore_tin_1:3>, <gregtech:meta_ingot:112>],
	[<gregtech:ore_octine_1:1>, <thebetweenlands:octine_ingot>],
	[<gregtech:ore_diatomite_1:1>, <gregtech:meta_dust:2509>],
	[<gregtech:ore_molybdenum_1>, <gregtech:meta_ingot:64>],
	[<gregtech:meta_dust_pure:55>, <gregtech:meta_ingot:55>],
	[<gregtech:ore_pentlandite_0:1>, <gregtech:meta_ingot:69> * 2],
	[<gregtech:meta_dust_impure:23>, <gregtech:meta_ingot:23>],
	[<actuallyadditions:item_dust:7>, <actuallyadditions:item_misc:5>],
	[<gregtech:ore_rock_salt_0:2>, <gregtech:meta_gem:309> * 4],
	[<gregtech:ore_trona_1:3>, <gregtech:meta_dust:2031> * 2],
	[<gregtech:ore_chalcocite_0:1>, <gregtech:meta_ingot:25> * 2],
	[<gregtech:ore_ruby_1:3>, <gregtech:meta_gem:311>],
	[<gregtech:ore_scabyst_0>, <thebetweenlands:items_misc:39>],
	[<gregtech:ore_pentlandite_0:2>, <gregtech:meta_ingot:69> * 2],
	[<gregtech:ore_iron_1>, <minecraft:iron_ingot>],
	[<gregtech:ore_granitic_mineral_sand_0>, <minecraft:iron_ingot>],
	[<gregtech:ore_malachite_1>, <gregtech:meta_ingot:25>],
	[<gregtech:ore_spodumene_0:2>, <gregtech:meta_dust:381> * 2],
	[<gregtech:ore_diamond_0:1>, <minecraft:diamond> * 2],
	[<gregtech:ore_salt_0>, <gregtech:meta_gem:312> * 2],
	[<gregtech:ore_vanadium_magnetite_1:3>, <gregtech:meta_dust:2022>],
	[<gregtech:ore_almandine_1>, <gregtech:meta_gem:250> * 3],
	[<gregtech:ore_sulfur_1:2>, <gregtech:meta_dust:103>],
	[<gregtech:ore_sulfur_0:2>, <gregtech:meta_dust:103> * 2],
	[<gregtech:ore_pitchblende_0>, <gregtech:meta_dust:2028>],
	[<gregtech:meta_dust_impure:51>, <minecraft:iron_ingot>],
	[<gregtech:meta_dust:32006>, <enderio:item_alloy_ingot:5>],
	[<gregtech:ore_garnet_yellow_1:1>, <gregtech:meta_gem:2017> * 4],
	[<gregtech:ore_redstone_0>, <minecraft:redstone> * 5],
	[<gregtech:ore_iron_1:3>, <minecraft:iron_ingot>],
	[<gregtech:ore_gold_1>, <minecraft:gold_ingot>],
	[<gregtech:meta_dust:280>, <gregtech:meta_ingot:69>],
	[<gregtech:ore_yellow_limonite_0:2>, <minecraft:iron_ingot> * 2],
	[<gregtech:ore_calcite_1:1>, <gregtech:meta_dust:262>],
	[<gregtech:meta_dust:2518>, <minecraft:iron_ingot>],
	[<gregtech:meta_dust:32014>, <enderio:item_alloy_endergy_ingot:3>],
	[<gregtech:ore_powellite_0:2>, <gregtech:meta_dust:305> * 2],
	[<gregtech:ore_rock_salt_1:2>, <gregtech:meta_gem:309> * 2],
	[<gregtech:ore_diatomite_1:2>, <gregtech:meta_dust:2509>],
	[<gregtech:ore_sodalite_1>, <gregtech:meta_gem:316> * 6],
	[<gregtech:ore_tetrahedrite_1>, <gregtech:meta_ingot:25>],
	[<gregtech:ore_thorium_0:2>, <gregtech:meta_ingot:109> * 2],
	[<gregtech:ore_fullers_earth_1:1>, <gregtech:meta_dust:2027> * 2],
	[<gregtech:ore_powellite_1:3>, <gregtech:meta_dust:305>],
	[<gregtech:ore_bastnasite_1>, <gregtech:meta_dust:379> * 2],
	[<gregtech:ore_chalcopyrite_0:2>, <gregtech:meta_ingot:25> * 2],
	[<gregtech:ore_opal_1>, <gregtech:meta_gem:2005>],
	[<gregtech:ore_platinum_0>, <gregtech:meta_ingot:80>],
	[<gregtech:ore_grossular_1>, <gregtech:meta_gem:282> * 3],
	[<gregtech:ore_calcite_1>, <gregtech:meta_dust:262>],
	[<gregtech:ore_bastnasite_1:3>, <gregtech:meta_dust:379> * 2],
	[<gregtech:ore_soapstone_1:3>, <gregtech:meta_dust:393> * 3],
	[<gregtech:ore_gypsum_1:3>, <gregtech:meta_dust:2032>],
	[<gregtech:ore_bauxite_1:1>, <gregtech:meta_dust:286>],
	[<gregtech:ore_beryllium_0:2>, <gregtech:meta_ingot:10> * 2],
	[<gregtech:ore_asbestos_0:1>, <gregtech:meta_dust:253> * 6],
	[<gregtech:ore_alunite_1>, <gregtech:meta_dust:388> * 3],
	[<gregtech:ore_scabyst_1:2>, <thebetweenlands:items_misc:39>],
	[<gregtech:ore_kyanite_1:2>, <gregtech:meta_dust:394>],
	[<gregtech:ore_blue_topaz_0:2>, <gregtech:meta_gem:257> * 4],
	[<gregtech:ore_brown_limonite_1:3>, <minecraft:iron_ingot>],
	[<gregtech:ore_lithium_0>, <gregtech:meta_dust:56>],
	[<gregtech:ore_chromite_1:1>, <gregtech:meta_dust:267>],
	[<gregtech:ore_pollucite_0>, <gregtech:meta_dust:2024>],
	[<gregtech:meta_dust:263>, <gregtech:meta_ingot:112>],
	[<gregtech:ore_sulfur_1>, <gregtech:meta_dust:103>],
	[<gregtech:ore_brown_limonite_1:1>, <minecraft:iron_ingot>],
	[<gregtech:ore_cassiterite_sand_1:1>, <gregtech:meta_ingot:112> * 2],
	[<gregtech:ore_electrotine_1:2>, <gregtech:meta_dust:2507> * 5],
	[<gregtech:meta_dust_impure:100>, <gregtech:meta_ingot:100>],
	[<gregtech:ore_sphalerite_1:2>, <gregtech:meta_ingot:122>],
	[<gregtech:ore_tin_0:1>, <gregtech:meta_ingot:112> * 2],
	[<nuclearcraft:ore>, <gregtech:meta_ingot:25>],
	[<gregtech:meta_dust_impure:327>, <gregtech:meta_ingot:25>],
	[<gregtech:ore_opal_0:2>, <gregtech:meta_gem:2005> * 2],
	[<gregtech:ore_soapstone_0>, <gregtech:meta_dust:393> * 3],
	[<gregtech:ore_magnesite_1:1>, <gregtech:meta_dust:59>],
	[<gregtech:meta_dust:80>, <gregtech:meta_ingot:80>],
	[<gregtech:ore_rock_salt_0>, <gregtech:meta_gem:309> * 2],
	[<gregtech:meta_dust_pure:64>, <gregtech:meta_ingot:64>],
	[<gregtech:ore_calcite_1:3>, <gregtech:meta_dust:262>],
	[<gregtech:ore_certus_quartz_0>, <appliedenergistics2:material:0> * 2],
	[<gregtech:ore_basaltic_mineral_sand_0:2>, <minecraft:iron_ingot> * 2],
	[<gregtech:ore_garnet_yellow_1:2>, <gregtech:meta_gem:2017> * 4],
	[<gregtech:ore_chromite_0>, <gregtech:meta_dust:267>],
	[<gregtech:ore_trona_1:2>, <gregtech:meta_dust:2031> * 2],
	[<nuclearcraft:ore:2>, <gregtech:meta_ingot:55>],
	[<gregtech:ore_barite_1:3>, <gregtech:meta_dust:387>],
	[<thebetweenlands:scabyst_ore>, <thebetweenlands:items_misc:39>],
	[<nuclearcraft:ore:5>, <nuclearcraft:ingot:5>],
	[<gregtech:meta_dust:32011>, <enderio:item_alloy_ingot:7>],
	[<erebus:ore_coal>, <minecraft:coal> * 2],
	[<gregtech:ore_pyrope_0:1>, <gregtech:meta_gem:308> * 6],
	[<gregtech:ore_cassiterite_1>, <gregtech:meta_ingot:112> * 2],
	[<nuclearcraft:ore:1>, <gregtech:meta_ingot:112>],
	[<gregtech:meta_dust:128>, <gregtech:meta_ingot:128>],
	[<gregtech:meta_dust_pure:2513>, <minecraft:iron_ingot>],
	[<gregtech:ore_zeolite_0:2>, <gregtech:meta_dust:2033> * 6],
	[<gregtech:ore_sulfur_0:1>, <gregtech:meta_dust:103> * 2],
	[<gregtech:ore_sapphire_0:2>, <gregtech:meta_gem:314> * 2],
	[<gregtech:ore_lapis_0>, <minecraft:dye:4> * 6],
	[<gregtech:ore_banded_iron_0:1>, <minecraft:iron_ingot> * 2],
	[<gregtech:ore_sodalite_0:2>, <gregtech:meta_gem:316> * 12],
	[<gregtech:ore_spessartine_1:3>, <gregtech:meta_gem:321> * 3],
	[<nuclearcraft:dust:15>, <nuclearcraft:ingot:15>],
	[<gregtech:ore_pyrolusite_1>, <gregtech:meta_ingot:61>],
	[<gregtech:ore_spessartine_1:1>, <gregtech:meta_gem:321> * 3],
	[<gregtech:ore_lazurite_1:3>, <gregtech:meta_gem:289> * 6],
	[<gregtech:ore_kyanite_0>, <gregtech:meta_dust:394>],
	[<gregtech:ore_galena_1:2>, <gregtech:meta_ingot:55>],
	[<gregtech:ore_lepidolite_0>, <gregtech:meta_dust:382> * 2],
	[<gregtech:ore_cinnabar_0>, <gregtech:meta_gem:268>],
	[<gregtech:ore_magnesite_0:2>, <gregtech:meta_dust:59> * 2],
	[<gregtech:ore_tantalite_1:1>, <gregtech:meta_dust:318>],
	[<gregtech:ore_bornite_0:2>, <gregtech:meta_ingot:25> * 2],
	[<gregtech:ore_chalcopyrite_1>, <gregtech:meta_ingot:25>],
	[<gregtech:meta_dust_pure:10>, <gregtech:meta_ingot:10>],
	[<gregtech:ore_garnet_yellow_0>, <gregtech:meta_gem:2017> * 4],
	[<gregtech:ore_lithium_1:3>, <gregtech:meta_dust:56>],
	[<gregtech:ore_tetrahedrite_1:1>, <gregtech:meta_ingot:25>],
	[<gregtech:ore_iron_1:1>, <minecraft:iron_ingot>],
	[<gregtech:meta_dust:32017>, <enderio:item_alloy_endergy_ingot:6>],
	[<gregtech:ore_gold_0:2>, <minecraft:gold_ingot> * 2],
	[<gregtech:ore_magnetite_1:1>, <minecraft:iron_ingot>],
	[<gregtech:ore_emerald_1>, <minecraft:emerald> * 2],
	[<gregtech:meta_dust_impure:348>, <gregtech:meta_ingot:25>],
	[<gregtech:ore_gypsum_1>, <gregtech:meta_dust:2032>],
	[<gregtech:meta_dust:4>, <gregtech:meta_ingot:4>],
	[<gregtech:ore_cooperite_1:3>, <gregtech:meta_dust:273>],
	[<gregtech:meta_dust_pure:264>, <gregtech:meta_ingot:112>],
	[<gregtech:ore_asbestos_0:2>, <gregtech:meta_dust:253> * 6],
	[<gregtech:meta_dust:327>, <gregtech:meta_ingot:25>],
	[<gregtech:ore_cobaltite_1:1>, <gregtech:meta_ingot:23>],
	[<gregtech:ore_diamond_1:1>, <minecraft:diamond>],
	[<gregtech:ore_lazurite_1:1>, <gregtech:meta_gem:289> * 6],
	[<gregtech:ore_silver_0:2>, <gregtech:meta_ingot:100> * 2],
	[<gregtech:meta_dust_pure:337>, <minecraft:iron_ingot>],
	[<gregtech:ore_diatomite_0>, <gregtech:meta_dust:2509>],
	[<gregtech:ore_alunite_0:1>, <gregtech:meta_dust:388> * 6],
	[<gregtech:ore_green_sapphire_1>, <gregtech:meta_gem:281>],
	[<gregtech:ore_calcite_1:2>, <gregtech:meta_dust:262>],
	[<gregtech:ore_almandine_0>, <gregtech:meta_gem:250> * 3],
	[<gregtech:meta_dust:260>, <gregtech:meta_ingot:260>],
	[<gregtech:meta_dust:51>, <minecraft:iron_ingot>],
	[<thebetweenlands:sulfur_ore>, <gregtech:meta_dust:103>],
	[<gregtech:meta_dust:259>, <gregtech:meta_ingot:259>],
	[<gregtech:ore_tetrahedrite_0:1>, <gregtech:meta_ingot:25> * 2],
	[<gregtech:ore_powellite_0>, <gregtech:meta_dust:305>],
	[<gregtech:ore_monazite_0:1>, <gregtech:meta_gem:2029> * 8],
	[<gregtech:ore_cinnabar_0:2>, <gregtech:meta_gem:268> * 2],
	[<gregtech:ore_monazite_1:2>, <gregtech:meta_gem:2029> * 4],
	[<gregtech:ore_cobalt_1:1>, <gregtech:meta_ingot:23>],
	[<gregtech:meta_dust:10>, <gregtech:meta_ingot:10>],
	[<gregtech:ore_alunite_1:1>, <gregtech:meta_dust:388> * 3],
	[<gregtech:ore_magnesite_1:3>, <gregtech:meta_dust:59>],
	[<gregtech:ore_green_sapphire_1:1>, <gregtech:meta_gem:281>],
	[<gregtech:ore_garnierite_1:2>, <gregtech:meta_ingot:69>],
	[<gregtech:ore_lithium_1:1>, <gregtech:meta_dust:56>],
	[<gregtech:ore_basaltic_mineral_sand_1:3>, <minecraft:iron_ingot>],
	[<gregtech:ore_oilsands_0>, <gregtech:meta_dust:1597>],
	[<gregtech:meta_dust:32009>, <enderio:item_alloy_ingot:2>],
	[<gregtech:ore_bauxite_0:1>, <gregtech:meta_dust:286> * 2],
	[<gregtech:ore_emerald_1:2>, <minecraft:emerald> * 2],
	[<gregtech:ore_talc_1:2>, <gregtech:meta_dust:392> * 2],
	[<gregtech:ore_cinnabar_1:1>, <gregtech:meta_gem:268>],
	[<gregtech:ore_pitchblende_1:3>, <gregtech:meta_dust:2028>],
	[<gregtech:ore_monazite_0>, <gregtech:meta_gem:2029> * 4],
	[<gregtech:ore_coal_1:1>, <minecraft:coal> * 2],
	[<gregtech:ore_quartzite_0:1>, <gregtech:meta_gem:340> * 4],
	[<gregtech:meta_dust:112>, <gregtech:meta_ingot:112>],
	[<gregtech:ore_redstone_0:1>, <minecraft:redstone> * 10],
	[<gregtech:ore_tetrahedrite_0:2>, <gregtech:meta_ingot:25> * 2],
	[<gregtech:ore_quartzite_0>, <gregtech:meta_gem:340> * 2],
	[<gregtech:ore_sapphire_0:1>, <gregtech:meta_gem:314> * 2],
	[<gregtech:meta_dust:32002>, <enderio:item_alloy_endergy_ingot>],
	[<gregtech:ore_malachite_0:2>, <gregtech:meta_ingot:25> * 2],
	[<gregtech:meta_dust_pure:385>, <gregtech:meta_ingot:25>],
	[<gregtech:ore_graphite_1:2>, <gregtech:meta_dust:341>],
	[<gregtech:ore_chalcocite_1:1>, <gregtech:meta_ingot:25>],
	[<gregtech:ore_pyrite_1:1>, <minecraft:iron_ingot>],
	[<gregtech:ore_zeolite_1:2>, <gregtech:meta_dust:2033> * 3],
	[<gregtech:ore_realgar_0:1>, <gregtech:meta_gem:365> * 2],
	[<erebus:ore_iron>, <minecraft:iron_ingot>],
	[<gregtech:ore_magnetite_0:1>, <minecraft:iron_ingot> * 2],
	[<gregtech:ore_apatite_1:1>, <gregtech:meta_gem:2010> * 4],
	[<gregtech:ore_bauxite_0:2>, <gregtech:meta_dust:286> * 2],
	[<gregtech:ore_brown_limonite_0>, <minecraft:iron_ingot>],
	[<gregtech:ore_pitchblende_1:2>, <gregtech:meta_dust:2028>],
	[<gregtech:ore_lazurite_0:1>, <gregtech:meta_gem:289> * 12],
	[<gregtech:ore_tin_1:1>, <gregtech:meta_ingot:112>],
	[<gregtech:ore_mica_0:2>, <gregtech:meta_dust:386> * 4],
	[<gregtech:ore_ilmenite_1:1>, <gregtech:meta_dust:284>],
	[<gregtech:ore_fullers_earth_0:2>, <gregtech:meta_dust:2027> * 4],
	[<gregtech:ore_banded_iron_1>, <minecraft:iron_ingot>],
	[<gregtech:ore_calcite_0:2>, <gregtech:meta_dust:262> * 2],
	[<gregtech:ore_pyrolusite_0:1>, <gregtech:meta_ingot:61> * 2],
	[<gregtech:ore_lazurite_0:2>, <gregtech:meta_gem:289> * 12],
	[<gregtech:ore_apatite_1:3>, <gregtech:meta_gem:2010> * 4],
	[<gregtech:ore_diatomite_0:1>, <gregtech:meta_dust:2509> * 2],
	[<gregtech:ore_yellow_limonite_1:2>, <minecraft:iron_ingot>],
	[<gregtech:ore_yellow_limonite_1:3>, <minecraft:iron_ingot>],
	[<gregtech:ore_pollucite_1:1>, <gregtech:meta_dust:2024>],
	[<gregtech:meta_dust_pure:69>, <gregtech:meta_ingot:69>],
	[<nuclearcraft:dust:14>, <nuclearcraft:ingot:14>],
	[<gregtech:meta_dust:306>, <minecraft:iron_ingot>],
	[<gregtech:ore_oilsands_0:1>, <gregtech:meta_dust:1597> * 2],
	[<gregtech:ore_topaz_1:1>, <gregtech:meta_gem:329>],
	[<gregtech:ore_syrmorite_1:3>, <thebetweenlands:items_misc:11>],
	[<libvulpes:ore0:5>, <gregtech:meta_ingot:112>],
	[<gregtech:ore_diamond_0:2>, <minecraft:diamond> * 2],
	[<thebetweenlands:syrmorite_ore>, <thebetweenlands:items_misc:11>],
	[<gregtech:ore_lepidolite_0:1>, <gregtech:meta_dust:382> * 4],
	[<gregtech:ore_glauconite_sand_1:2>, <gregtech:meta_dust:384> * 3],
	[<gregtech:ore_chromite_0:2>, <gregtech:meta_dust:267> * 2],
	[<gregtech:ore_bornite_1:1>, <gregtech:meta_ingot:25>],
	[<gregtech:ore_bentonite_1:3>, <gregtech:meta_dust:2026> * 3],
	[<gregtech:ore_cobalt_1:3>, <gregtech:meta_ingot:23>],
	[<gregtech:ore_scheelite_1:1>, <gregtech:meta_dust:315>],
	[<gregtech:ore_yellow_limonite_1>, <minecraft:iron_ingot>],
	[<gregtech:ore_plutonium_1:3>, <gregtech:meta_ingot:81>],
	[<gregtech:ore_lepidolite_1:2>, <gregtech:meta_dust:382> * 2],
	[<gregtech:ore_tantalite_1>, <gregtech:meta_dust:318>],
	[<gregtech:ore_cooperite_1>, <gregtech:meta_dust:273>],
	[<gregtech:ore_emerald_0:2>, <minecraft:emerald> * 4],
	[<gregtech:ore_platinum_1:3>, <gregtech:meta_ingot:80>],
	[<gregtech:ore_talc_1:3>, <gregtech:meta_dust:392> * 2],
	[<gregtech:ore_glauconite_sand_1:1>, <gregtech:meta_dust:384> * 3],
	[<gregtech:meta_dust_pure:255>, <minecraft:iron_ingot>],
	[<gregtech:ore_chalcocite_1:3>, <gregtech:meta_ingot:25>],
	[<gregtech:ore_rock_salt_1:1>, <gregtech:meta_gem:309> * 2],
	[<gregtech:ore_monazite_1:3>, <gregtech:meta_gem:2029> * 4],
	[<gregtech:ore_lead_1:3>, <gregtech:meta_ingot:55>],
	[<gregtech:meta_dust_impure:264>, <gregtech:meta_ingot:112>],
	[<erebus:ore_emerald>, <minecraft:emerald> * 2],
	[<gregtech:meta_dust_pure:81>, <gregtech:meta_ingot:81>],
	[<gregtech:ore_cobalt_1:2>, <gregtech:meta_ingot:23>],
	[<gregtech:ore_electrotine_1>, <gregtech:meta_dust:2507> * 5],
	[<gregtech:ore_sodalite_1:1>, <gregtech:meta_gem:316> * 6],
	[<gregtech:ore_amethyst_1:3>, <gregtech:meta_gem:2006>],
	[<gregtech:ore_lapis_1:3>, <minecraft:dye:4> * 6],
	[<gregtech:meta_dust:32053>, <lucraftcore:ingot_adamantium>],
	[<gregtech:ore_garnet_red_1:3>, <gregtech:meta_gem:2016> * 4],
	[<gregtech:meta_dust_impure:2518>, <minecraft:iron_ingot>],
	[<gregtech:ore_pyrochlore_1:2>, <gregtech:meta_dust:449>],
	[<gregtech:ore_cinnabar_1:3>, <gregtech:meta_gem:268>],
	[<gregtech:ore_banded_iron_1:1>, <minecraft:iron_ingot>],
	[<gregtech:ore_platinum_1:2>, <gregtech:meta_ingot:80>],
	[<gregtech:ore_pyrite_0>, <minecraft:iron_ingot>],
	[<gregtech:ore_cooperite_0:1>, <gregtech:meta_dust:273> * 2],
	[<gregtech:ore_ruby_0:1>, <gregtech:meta_gem:311> * 2],
	[<gregtech:ore_olivine_0:1>, <gregtech:meta_gem:2004> * 4],
	[<gregtech:ore_diatomite_1>, <gregtech:meta_dust:2509>],
	[<gregtech:ore_cobalt_0:2>, <gregtech:meta_ingot:23> * 2],
	[<gregtech:ore_kyanite_1:1>, <gregtech:meta_dust:394>],
	[<futuremc:ancient_debris>, <futuremc:netherite_scrap>],
	[<gregtech:ore_oilsands_1:1>, <gregtech:meta_dust:1597>],
	[<gregtech:meta_dust:2513>, <minecraft:iron_ingot>],
	[<gregtech:meta_dust:354>, <gregtech:meta_ingot:354>],
	[<gregtech:ore_brown_limonite_1:2>, <minecraft:iron_ingot>],
	[<gregtech:meta_dust:11>, <gregtech:meta_ingot:11>],
	[<gregtech:ore_pyrochlore_1>, <gregtech:meta_dust:449>],
	[<gregtech:ore_spessartine_0>, <gregtech:meta_gem:321> * 3],
	[<gregtech:ore_topaz_0:1>, <gregtech:meta_gem:329> * 2],
	[<gregtech:ore_electrotine_0:1>, <gregtech:meta_dust:2507> * 10],
	[<gregtech:ore_salt_1>, <gregtech:meta_gem:312> * 2],
	[<gregtech:ore_gypsum_0:2>, <gregtech:meta_dust:2032> * 2],
	[<gregtech:ore_molybdenum_0:1>, <gregtech:meta_ingot:64> * 2],
	[<gregtech:ore_bornite_0>, <gregtech:meta_ingot:25>],
	[<gregtech:meta_dust_impure:279>, <gregtech:meta_ingot:55>],
	[<gregtech:ore_glauconite_sand_0:1>, <gregtech:meta_dust:384> * 6],
	[<gregtech:ore_chalcopyrite_1:2>, <gregtech:meta_ingot:25>],
	[<gregtech:ore_galena_1:1>, <gregtech:meta_ingot:55>],
	[<gregtech:meta_dust:337>, <minecraft:iron_ingot>],
	[<gregtech:ore_mica_0>, <gregtech:meta_dust:386> * 2],
	[<gregtech:ore_topaz_1:3>, <gregtech:meta_gem:329>],
	[<gregtech:ore_oilsands_1:3>, <gregtech:meta_dust:1597>],
	[<gregtech:ore_zeolite_1>, <gregtech:meta_dust:2033> * 3],
	[<gregtech:ore_spessartine_1>, <gregtech:meta_gem:321> * 3],
	[<gregtech:ore_oilsands_0:2>, <gregtech:meta_dust:1597> * 2],
	[<gregtech:ore_garnet_red_1:2>, <gregtech:meta_gem:2016> * 4],
	[<gregtech:meta_dust_pure:32081>, <thebetweenlands:items_misc:11>],
	[<gregtech:ore_garnet_yellow_1:3>, <gregtech:meta_gem:2017> * 4],
	[<gregtech:ore_bentonite_0>, <gregtech:meta_dust:2026> * 3],
	[<gregtech:meta_dust:104>, <gregtech:meta_ingot:104>],
	[<gregtech:ore_tricalcium_phosphate_1:3>, <gregtech:meta_dust:2015> * 3],
	[<gregtech:ore_cassiterite_sand_1>, <gregtech:meta_ingot:112> * 2],
	[<gregtech:meta_dust:355>, <gregtech:meta_ingot:355>],
	[<gregtech:ore_garnet_red_0:2>, <gregtech:meta_gem:2016> * 8],
	[<gregtech:ore_spessartine_1:2>, <gregtech:meta_gem:321> * 3],
	[<lucraftcore:ore_lead>, <gregtech:meta_ingot:55>],
	[<gregtech:ore_pyrope_1:3>, <gregtech:meta_gem:308> * 3],
	[<gregtech:ore_bentonite_1>, <gregtech:meta_dust:2026> * 3],
	[<gregtech:meta_dust:264>, <gregtech:meta_ingot:112>],
	[<gregtech:ore_monazite_0:2>, <gregtech:meta_gem:2029> * 8],
	[<gregtech:ore_silver_1:3>, <gregtech:meta_ingot:100>],
	[<gregtech:ore_molybdenite_0:1>, <gregtech:meta_ingot:64> * 2],
	[<gregtech:ore_magnesite_1:2>, <gregtech:meta_dust:59>],
	[<gregtech:ore_graphite_1>, <gregtech:meta_dust:341>],
	[<gregtech:ore_lithium_0:2>, <gregtech:meta_dust:56> * 2],
	[<gregtech:ore_opal_0:1>, <gregtech:meta_gem:2005> * 2],
	[<gregtech:ore_magnesite_0>, <gregtech:meta_dust:59>],
	[<gregtech:ore_thorium_1:3>, <gregtech:meta_ingot:109>],
	[<industrialrenewal:orevein_hematite>, <minecraft:iron_ingot>],
	[<gregtech:meta_dust_pure:347>, <gregtech:meta_ingot:25>],
	[<gregtech:ore_beryllium_0:1>, <gregtech:meta_ingot:10> * 2]
] as IItemStack[][];

// For comparison:
// Vanilla Furnace: 200 t
// Campfire 600 t, 4x
// Iron/Copper Furnace: 150 t
// LV Electric Furnace: 128 t @ 4 EU/t
// Blast Furnace/Smoker: 100 t
// Silver Furnace: 100 t
for blastingIO in furnace_blasting_recipes {
	pebf.recipeMap.recipeBuilder()
		.inputs(blastingIO[0])
		.outputs(blastingIO[1])
	.duration(60).EUt(16).buildAndRegister();
}

//for some reason this functionality isn't standard for inserting into
//slot -1
function insertItemStack(inventory as IItemHandlerModifiable, _itemStack as IItemStack, simulate as bool) as IItemStack {
	var itemStack as IItemStack = _itemStack;
	for slot, stack in inventory {
		if(itemStack.matches(stack) &&
		   (isNull(stack) || itemStack.maxStackSize > stack.amount)
		){
			itemStack = inventory.insertItem(slot, itemStack, simulate);
			if(isNull(itemStack) || itemStack.amount == 0){
				return null as IItemStack;
			}
		}
	}
	for slot, stack in inventory {
		if(isNull(stack)){
			itemStack = inventory.insertItem(slot, itemStack, simulate);
			if(isNull(itemStack) || itemStack.amount == 0){
				return null as IItemStack;
			}
		}
	}
	return itemStack;
}

// Returns the amount of items successfully extracted
function extractIngredient(inventory as IItemHandlerModifiable, _ingredient as IIngredient) as int {
	var toExtract as int = _ingredient.amount;
	val ingredient as IIngredient = _ingredient*1;
	//print("extractIngredient::: toExtract "~toExtract~" 1=="~ingredient.amount);
	for slot, stack in inventory {
		if(ingredient.matches(stack) && !isNull(stack)){
			var amount as int = toExtract;
			if(amount > stack.amount){
				amount = stack.amount;
			}
			//print("extractIngredient::: trying "~amount~" from slot "~slot);
			val itemStack as IItemStack = inventory.extractItem(slot, amount, false);
			if(!isNull(itemStack)){
				//print("extractIngredient::: got "~itemStack.amount);
				toExtract -= itemStack.amount;
				if(toExtract == 0){
					return _ingredient.amount;
				}
			}
		}
	}
	return _ingredient.amount - toExtract;
}

function voltageToTier(voltage as long) as long {
	if(voltage < (2048 as long)){
		if(voltage < (128 as long)){
			return (voltage < (32 as long) ? (0 as long) : (1 as long)) as long;
		}
		return (voltage < (512 as long) ? (2 as long) : (3 as long)) as long;
	}else if(voltage >= (32768 as long)){
		if(voltage < (524288 as long)){
			return (voltage < (131072 as long) ? (6 as long) : (7 as long)) as long;
		}
		return (voltage < (2147483647 as long) ? (8 as long) : (9 as long)) as long;
	}
	return (voltage < (8192 as long) ? (4 as long) : (5 as long)) as long;
}

val getCenter = function(pos as IBlockPos, facing as IFacing) as IBlockPos[] {
	return [pos.getOffset(facing.opposite, 1).getOffset(IFacing.up(), 1)] as IBlockPos[];
};

pebf.formStructureFunction = function(controller as IControllerTile, context as IPatternMatchContext){
	val corePos as IBlockPos = controller.pos.getOffset(controller.frontFacing.opposite, 1).getOffset(IFacing.up(), 1);
	val coreBlock as IBlockState = controller.world.getBlockState(corePos);
	val coreTier as int = <blockstate:gregtech:meta_block_compressed_2009:variant=red_crystal_alloy>.matches(coreBlock) ? 0 : 1;
	print("ZZZZZZ PEBF formStructure: coreTier? "~coreTier);
	val extraExtracted as int = (!isNull(controller.extraData) && controller.extraData has "extraExtracted") ? controller.extraData.extraExtracted as int : 0;
	controller.extraData = {extraExtracted: extraExtracted, coreTier: coreTier} as IData;
} as IFormStructureFunction;

pebf.setupRecipeFunction = function(logic as IRecipeLogic, recipe as IRecipe) as bool {
	logic.superSetupRecipe(recipe);
	val recipeInputs as IIngredient[] = recipe.getInputs();
	val recipeOutputs as IItemStack[] = recipe.getAllItemOutputs();
	if (recipeInputs.length == 1 && recipeOutputs.length == 1) {
		val tier as long = voltageToTier(logic.getMaxVoltage());
		var extraAmount as int = (tier as int) + 3;
		val inputMult as int = recipeInputs[0].amount;
		val outputMult as int = recipeOutputs[0].amount;
		val overflowOutput as IItemStack = insertItemStack(logic.outputInventory, recipeOutputs[0].withAmount((extraAmount + 1)*outputMult), true);
		if(!isNull(overflowOutput) && overflowOutput.amount > 0){
			extraAmount -= (overflowOutput.amount + outputMult - 1)/outputMult;
		}
		//print("PEBF::: Running at tier "~tier~", pulling "~extraAmount~" extra items");
		val extraExtracted as int = extractIngredient(logic.inputInventory, recipeInputs[0]*(extraAmount*inputMult));
		//print("PEBF::: Actually pulled "~extraExtracted);
		val coreTier as int = logic.metaTileEntity.extraData.coreTier as int;
		print("ZZZZZZ PEBF setupRecipe: coreTier "~coreTier);
		logic.metaTileEntity.extraData = {extraExtracted: extraExtracted, coreTier: coreTier} as IData;
	}
	return false;
} as ISetupRecipeFunction;

pebf.completeRecipeFunction = function(logic as IRecipeLogic) as bool {
	val extraExtracted as int = logic.metaTileEntity.extraData.extraExtracted as int;
	val coreTier = logic.metaTileEntity.extraData.coreTier as int;
	print("ZZZZZZ PEBF completeRecipe: coreTier "~coreTier);
	logic.metaTileEntity.extraData = {extraExtracted: 0, coreTier: coreTier} as IData;
	//print("PEBF::: Generating bonus outputs for "~extraExtracted~" extra recipes");
	var outputItem as IItemStack = logic.previousRecipe.getAllItemOutputs()[0];
	if(extraExtracted != 0){
		insertItemStack(logic.outputInventory, outputItem.withAmount(outputItem.amount*extraExtracted), false);
	}else if(outputItem.hasTag && outputItem.tag has "requiresCoreTier"){
		if(coreTier > 0){
			outputItem = <ore:ingotSteel>.firstItem;
		}else{
			outputItem = <ore:ingotCrudeSteel>.firstItem;
		}
		logic.itemOutputs = [outputItem] as IItemStack[];
	}
	return true;
} as ICompleteRecipeFunction;

