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
CardQty = 3;
// Lips
FaceLips = 2;
// Card Angle
FaceTilt = 10; // From vertical
//Wall Thickness
WallTh = 2;

/* [Randomisation] */
// Base Seed
BaseSeed = 156;

// ###########################################

/* [Hidden] */
RenderCludge = 0.01; // Cludge to tidy up rendering interface
Wiggle = 1;

BodyHeight = CardHeight + WallTh; // Z after rot
BodyWidth = CardWidth + (2 * WallTh); // X after rot
BodyDepth = 1 + (2 * WallTh); // Y after rot
BodyTilt = 90 - FaceTilt;

// ###########################################

module CardSlotBody(CardHeight, CardWidth, FaceTilt = 10, Lip = 2)
{
   difference()
   {
      hull()
      {
         rotate([BodyTilt, 0, 0])
         {
            cube([BodyWidth, BodyHeight, BodyDepth]);
         }
         
         /* 
         BaseRear
            Hyp=BodyHeight
                       /|
               Face ->/ |
                     /  |
                     ---  90Deg
            Ang=BodyTilt
         */
         
         /* 
         BaseFront fill to print bed
                      Hyp=BodyDepth
                     |\
                     | \
                     |  \
                     ----\
            90Deg          Ang=BodyTilt
         */
         
         // Adj = cos(theta) * Hyp
         BaseRear = cos(BodyTilt) * BodyHeight;
         // Adj = cos(theta) * Hyp
         BaseFront = cos(FaceTilt) * BodyDepth;
         // Opp = tan(FaceTilt) * BaseFront
         BaseDepth = tan(FaceTilt) * BaseFront;
         translate([0, -BaseFront, 0])
            cube([BodyWidth, BaseFront + BaseRear, BaseDepth]);
      }
      
      rotate([BodyTilt,0,0]) translate([ 0, 1, WallTh])
      {
         // Face cut
         translate([Lip + WallTh, Lip, 0]) 
            cube([BodyWidth - 2 * (WallTh + Lip), BodyHeight, BodyDepth]);
      }
      
   }
}

module CardSlotCuts(CardHeight, CardWidth, FaceTilt = 10, Lip = 2)
{
   rotate([BodyTilt,0,0]) translate([ 0, 1, WallTh])
   {
      // Slot cut
      translate([WallTh, 0, 0])
         cube([(BodyWidth - (2 * WallTh)) + Wiggle, BodyHeight * 2, 1]);
   }
}

module CardHolder()
{
   difference()
   {
      for ( i = [0:1:CardQty] )
      {
         translate([(i * CardWidth) + (i * WallTh * 2), 0, 0])
         {
            crystalGenerator(
               Randomness = 1,
               Seed = (BaseSeed + (10 * i)),
               Number_of_Shards = 20,
               Shard_Sides = 5,
               Shard_Length = CardHeight * 0.5,
               Shard_Length_Variance_Percentage = 150,
               Shard_Tilt = 0,
               Shard_Tilt_Variance_Percentage = 30,
               Shard_Offset = 2,
               Shard_Offset_Variance_Percentage = 60,
               Shard_Diameter = 6,
               Shard_Diameter_Variance_Percentage = 100,
               Hollow_Shards = 0,
               Hollow_Shard_Wall_Thickness = WallTh,
               Base_Type = 0
            );
            
            translate([0,9,0]) // TODO: Paramaterise
            {
               crystalGenerator(
                  Randomness = 1,
                  Seed = (BaseSeed / 2 - (10 * i)),
                  Number_of_Shards = 20,
                  Shard_Sides = 5,
                  Shard_Length = CardHeight * 0.6,
                  Shard_Length_Variance_Percentage = 150,
                  Shard_Tilt = 0,
                  Shard_Tilt_Variance_Percentage = 30,
                  Shard_Offset = 2,
                  Shard_Offset_Variance_Percentage = 60,
                  Shard_Diameter = 5,
                  Shard_Diameter_Variance_Percentage = 70,
                  Hollow_Shards = 0,
                  Hollow_Shard_Wall_Thickness = WallTh,
                  Base_Type = 0
               );
            }
                 
            if (i < CardQty)
               CardSlotBody(CardHeight, CardWidth, FaceTilt, FaceLips);
         }
      } // for
      
      for ( i = [0:1:CardQty] )
      {
      translate([(i * CardWidth) + (i * WallTh * 2), 0, 0])
         if (i < CardQty)
            CardSlotCuts(CardHeight, CardWidth, FaceTilt, FaceLips);
      }
   }
}

//CardSlotBody(CardHeight, CardWidth, FaceTilt, FaceLips);
CardHolder();