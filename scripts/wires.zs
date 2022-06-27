import crafttweaker.item.IItemStack;
import crafttweaker.liquid.ILiquidStack;
import mods.gregtech.recipe.Recipe;

val wireMaterialsByTier as string[][] = [
	["EmcMinor", "GreenCrystalAlloy", "Lead", "RedAlloy"],             // ULV
	["Cobalt", "Fluix", "Nickel", "Tin"],                              // LV
	["AnnealedCopper", "Copper", "Cupronickel", "FluixSteel", "Iron"], // MV
	["BlueAlloy", "Electrum", "Gold", "Kanthal", "Silver"],            // HV
	["Aluminium", "BlackSteel", "Nichrome", "Steel"],                  // EV
	["Graphene", "Platinum", "Tungsten", "TungstenSteel"],             // IV
	["Hssg", "NiobiumNitride", "NiobiumTitanium", "Osmium"],           // LuV
	["Naquadah", "Trinium", "VanadiumGallium"],                        // ZPM
	["NaquadahAlloy", "Tritanium", "YttriumBariumCuprate"],            // UV
	["Europium"]                                                       // UHV
] as string[][];

val powerMults as int[string] = {
	"Aluminium": 4,
	"Kanthal": 4,
	"Steel": 4,
	"BlackSteel": 4,
	"Nichrome": 16,
	"Tungsten": 16,
	"TungstenSteel": 16,
	"Hssg": 16,
	"NiobiumNitride": 16,
	"NiobiumTitanium": 16,
	"Osmium": 16,
	"Naquadah": 16,
	"Trinium": 16,
	"VanadiumGallium": 16,
	"NaquadahAlloy": 16,
	"YttriumBariumCuprate": 16,
	"Europium": 16
} as int[string];

// The important thing about these superconductors is that they CANNOT be coated
val superconductorMaterialsByTier as string[][] = [
	[],                                          // ULV
	["ManganesePhosphide"],                      // LV
	["MagnesiumDiboride"],                       // MV
	["MercuryBariumCalciumCuprate"],             // HV
	["UraniumTriplatinum"],                      // EV
	["SamariumIronArsenicOxide"],                // IV
	["IndiumTinBariumTitaniumCuprate"],          // LuV
	["UraniumRhodiumDinaquadide"],               // ZPM
	["EnrichedNaquadahTriniumEuropiumDuranide"], // UV
	["RutheniumTriniumAmericiumNeutronate"]      // UHV
] as string[][];

val gtBundleSizeMap as int[][string] = {
	"Single": [1, 1],
	"Double": [2, 1],
	"Quadruple": [4, 2],
	"Octal": [8, 3],
	"Hex": [16, 5]
} as int[][string];

val gtBundleSizes as string[] = [
	"Single", "Double", "Quadruple", "Octal", "Hex"
] as string[];

val gtCableFoils as IItemStack[] = [
	<metaitem:foilPolyvinylChloride>, <metaitem:foilPolyphenyleneSulfide>
] as IItemStack[];

val gtCableFluids as ILiquidStack[] = [
	<fluid:rubber>*144, <fluid:silicone_rubber>*72, <fluid:styrene_butadiene_rubber>*36
] as ILiquidStack[];

val plateRubber as IItemStack = <ore:plateRubber>.firstItem;

// TODO: Add tryRemove(...) to g.zs and use it

for tier in 0 .. (wireMaterialsByTier.length) {
	var numFoils as int = 0;
	if(tier >= 4){ // EV+
		numFoils = 1;
		if(tier >= 6){ // LuV+
			numFoils = 2;
		}
	}
	var assemblerInputs as IItemStack[] = [] as IItemStack[];
	for i in 0 .. numFoils {
		assemblerInputs += gtCableFoils[i];
	}
	var minRubber as int = 0;
	if(tier >= 5){ // IV+
		minRubber = 1;
	}
	for name in wireMaterialsByTier[tier] {
		val powerMult as int = (powerMults has name) ? (powerMults[name] as int) : 1;
		val productMap as IItemStack[string] = {} as IItemStack[string];
		for bundle, stats in gtBundleSizeMap {
			val mult as int = stats[0] as int;
			val wrapMult as int = stats[1] as int;
			val wirePrefix as string = "wireGt"~bundle;
			val cablePrefix as string = "cableGt"~bundle;
			val wire as IItemStack = oreDict[wirePrefix~name].firstItem;
			val cable as IItemStack = oreDict[cablePrefix~name].firstItem;
			productMap[wirePrefix] = wire;
			productMap[cablePrefix] = cable;
			var recipe as Recipe = null as Recipe;
			if(tier < 2){
				recipes.remove(cable);
				recipe = <recipemap:packer>.findRecipe(7, [wire, plateRubber.withAmount(wrapMult)], null);
				if(isNull(recipe)){
					print("ZZZZZZ "~bundle~name~" missing packer recipe");
				}else{
					recipe.remove();
				}
			}
			for i in minRubber .. gtCableFluids.length {
				val fluidStack as ILiquidStack = gtCableFluids[i];
				var input as IItemStack[] = [wire] as IItemStack[];
				for foil in assemblerInputs {
					input += foil.withAmount(foil.amount*wrapMult);
				}
				// This would remove multicoating recipes, but we are good with them for now
				/*
				recipe = <recipemap:assembler>.findRecipe(7, input, [fluidStack.withAmount(fluidStack.amount*wrapMult)]);
				if(isNull(recipe)){
					print("ZZZZZZ "~bundle~name~" missing assembler recipe "~i);
				}else{
					recipe.remove();
				}
				*/
			}
			recipe = <recipemap:packer>.findRecipe(7, [cable], null);
			if(isNull(recipe)){
				print("ZZZZZZ "~bundle~name~" missing packer recycling recipe");
			}else{
				recipe.remove();
			}
			recipe = <recipemap:extractor>.findRecipe(30*powerMult, [cable], null);
			if(isNull(recipe)){
				print("ZZZZZZ "~bundle~name~" missing extractor recycling recipe");
			}else{
				recipe.remove();
			}
			recipe = <recipemap:arc_furnace>.findRecipe(30, [cable], [<fluid:oxygen>*64000]);
			if(isNull(recipe)){
				print("ZZZZZZ "~bundle~name~" missing arc furnace recycling recipe");
			}else{
				recipe.remove();
			}
			recipe = <recipemap:macerator>.findRecipe(2*powerMult, [cable], null);
			if(isNull(recipe)){
				print("ZZZZZZ "~bundle~name~" missing macerator recycling recipe");
			}else{
				recipe.remove();
			}
		}
		for i in 1 .. gtBundleSizes.length {
			val output as IItemStack = productMap["cableGtSingle"];
			val input as IItemStack = productMap["cableGt"~gtBundleSizes[i]];
			<recipemap:packer>.recipeBuilder()
				.inputs(input)
				.notConsumable(<metaitem:circuit.integrated>.withTag({Configuration:1}))
				.outputs(output*gtBundleSizeMap[gtBundleSizes[i]][0])
				.duration(100).EUt(7).buildAndRegister();
		}
		for i in 0 .. (gtBundleSizes.length - 1) {
			val output as IItemStack = productMap["cableGt"~gtBundleSizes[i + 1]];
			val input as IItemStack = productMap["cableGt"~gtBundleSizes[i]];
			recipes.addShapeless("combine_"~name~"_cable"~i~"x2", output, [input, input]);
			recipes.addShapeless("split_"~name~"_cable"~i~"x2", input.withAmount(2), [output]);
			<recipemap:packer>.recipeBuilder()
				.inputs(input*2)
				.notConsumable(<metaitem:circuit.integrated>.withTag({Configuration:2}))
				.outputs(output)
				.duration(100).EUt(7).buildAndRegister();
		}
		for i in 0 .. (gtBundleSizes.length - 2) {
			val output as IItemStack = productMap["cableGt"~gtBundleSizes[i + 2]];
			val input as IItemStack = productMap["cableGt"~gtBundleSizes[i]];
			recipes.addShapeless("combine_"~name~"_cable"~i~"x4", output, [input, input, input, input]);
			<recipemap:packer>.recipeBuilder()
				.inputs(input*4)
				.notConsumable(<metaitem:circuit.integrated>.withTag({Configuration:4}))
				.outputs(output)
				.duration(100).EUt(7).buildAndRegister();
		}
		for i in 0 .. (gtBundleSizes.length - 3) {
			val output as IItemStack = productMap["cableGt"~gtBundleSizes[i + 3]];
			val input as IItemStack = productMap["cableGt"~gtBundleSizes[i]];
			<recipemap:packer>.recipeBuilder()
				.inputs(input*8)
				.notConsumable(<metaitem:circuit.integrated>.withTag({Configuration:8}))
				.outputs(output)
				.duration(100).EUt(7).buildAndRegister();
		}
		<recipemap:packer>.recipeBuilder()
			.inputs(productMap["cableGtSingle"]*16)
			.notConsumable(<metaitem:circuit.integrated>.withTag({Configuration:8}))
			.outputs(productMap["cableGtHex"])
			.duration(100).EUt(7).buildAndRegister();
		val inputs as IItemStack[] = assemblerInputs + productMap["wireGtSingle"];
		// Currently, the default assembler coating recipes aren't touched so we don't need to add our own
		/*
		for i in minRubber .. gtCableFluids.length {
			<recipemap:assembler>.recipeBuilder()
				.inputs(inputs)
				.fluidInputs(gtCableFluids[i])
				.outputs(productMap["cableGtSingle"])
				.duration(100).EUt(7).buildAndRegister();
		}
		*/
	}
}

// new hand coating recipes
for i in 0 .. 3 {
	for name in wireMaterialsByTier[i] {
		for bundle, stats in gtBundleSizeMap {
			val wire as IItemStack = oreDict["wireGt"~bundle~name].firstItem;
			val cable as IItemStack = oreDict["cableGt"~bundle~name].firstItem;
			craft.shapeless(cable, "WRRRRR".substring(0, stats[1] + 1), {
				"W": wire,
				"R": <ore:anyCableWrapper>
			});
		}
	}
}

recipes.addShaped("scabyst_plate", <metaitem:plateScabyst>, [[<ore:gtceHardHammers>], [<ore:gemScabyst>], [<ore:gemScabyst>]]);

