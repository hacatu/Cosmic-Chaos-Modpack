#loader contenttweaker
import mods.contenttweaker.VanillaFactory;
import mods.contenttweaker.Fluid;
import mods.contenttweaker.BlockMaterial;
import mods.contenttweaker.Color;

#priority 103

print("==================== loading fluids.zs ====================");
##########################################################################################

var emc_fluid = VanillaFactory.createFluid("emc_fluid", Color.fromHex("b0e65a"));
emc_fluid.temperature = 6000;
emc_fluid.gaseous = true;
emc_fluid.luminosity = 0.5;
emc_fluid.viscosity = 2000;
//emc_fluid.stillLocation = "contenttweaker:fluids/molten_embers";
//emc_fluid.flowingLocation = "contenttweaker:fluids/molten_embers";
emc_fluid.material = <blockmaterial:lava>;
emc_fluid.register();

##########################################################################################
print("==================== end of fluids.zs ====================");