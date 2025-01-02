use <Lib-CrystalGenerator/crystalGenerator.scad>;

// 52 63 x 88mm
// 84 44 x 67mm

/* [Card Parameters] */
// Height
CardHeight = 88;
// Width
CardWidth = 63;
// Thickness
CardThickness = 0.2;

/* [Holder Parameters] */
// Card Quantity
CardQty = 2;

/* [Randomisation] */
// Base Seed
BaseSeed = 156;

// ###########################################

/* [Hidden] */
RenderCludge = 0.01; // Cludge to tidy up rendering interface
Wiggle = 0.2;

// ###########################################

module CardHolder()
{
   for ( i = [0:1:CardQty] )
      translate([i * CardWidth, 0, 0])
      {
         crystalGenerator(
             Randomness = 1,
             Seed = (BaseSeed + (10 * i)),
             Number_of_Shards = 5,
             Shard_Sides = 5,
             Shard_Length = CardHeight,
             Shard_Tilt = 5,
             Shard_Offset = 5,
             Shard_Length_Variance_Percentage = 80,
             Shard_Diameter_Variance_Percentage = 70,
             Shard_Tilt_Variance_Percentage = 20,
             Hollow_Shards = 1,
             Base_Type = 0
         );
      }
}

CardHolder();