void main(void){
        

   ///////////////////////////////////////////////
   //Inital Configuaration                      //                                          
   ///////////////////////////////////////////////

   // Sets map parameters
   rmSetStatusText("Init Cfig",0.01);

   int tileCount=8000;
   int size=2.0*sqrt(cNumberNonGaiaPlayers*tileCount/0.9);
   rmSetMapSize(size, size);

   // Default water level and type
   rmSetSeaLevel(0.0);
   rmSetSeaType("Egyptian Nile");
	
	//Map base texture
	rmTerrainInitialize("SandA");

	rmSetStatusText("Init Cfig Cleared",0.07);  


   ///////////////////////////////////////////////
   //Class Declarations                         //                                     
   ///////////////////////////////////////////////

   rmSetStatusText("Class Dec",0.08);

	int classPlayer = rmDefineClass("player");
	int classGold = rmDefineClass("gold");
	int classWood = rmDefineClass("wood");
	int classStartTC = rmDefineClass("startTC");
	int classBackTC = rmDefineClass("backTC");

	rmSetStatusText("Class Dec Cleared",0.13);

   ///////////////////////////////////////////////
   //Global Constraints                         //                                        
   ///////////////////////////////////////////////

   rmSetStatusText("Global Const",0.14);

	int constraintEdge=rmCreateBoxConstraint("edgeConst", rmXTilesToFraction(1), rmZTilesToFraction(1), 1.0-rmXTilesToFraction(1), 1.0-rmZTilesToFraction(1));
	int constraintPlayer=rmCreateClassDistanceConstraint("playersConst", classPlayer, 20);  
	int constraintImpassable=rmCreateTerrainDistanceConstraint("impassableConst","land", 5.0);
	// Constraints for general map conflicts
	
	rmSetStatusText("Global Const Cleared",0.20);

   ///////////////////////////////////////////////
   //Player Constraints                         //                                  
   ///////////////////////////////////////////////

   rmSetStatusText("pInit",0.21);
	
	// Initial resource deployment
	for(i=1; <cNumberPlayers){
		rmAddPlayerResource(i,"Food", 300);
		rmAddPlayerResource(i,"Wood", 200);
		rmAddPlayerResource(i,"Gold", 100);
	}
	
	// Constraints
	int constraintLightSettlement=rmCreateTypeDistanceConstraint ("TCLightConst", "AbstractSettlement", 20.0);
	int constraintMediumSettlement=rmCreateTypeDistanceConstraint ("TCMediumConst", "AbstractSettlement", 40.0);
	int constraintHeavySettlement=rmCreateTypeDistanceConstraint ("TCHeavyConst", "AbstractSettlement", 60.0);
	// Avoids conflicts with TC locations and the objects surrounding them
	
	int constraintTowerToTower=rmCreateTypeDistanceConstraint("TowerTowerConst", "tower", 20.0);
   int constraintTowerToObject=rmCreateTypeDistanceConstraint("TowerObjectConst","tower", 250);
	// Avoids tower conflicts 
	
	rmSetStatusText("pInit cleared",0.25);

   ///////////////////////////////////////////////
   //Light Constraints                          //                                          
   ///////////////////////////////////////////////

   // Gold constraints
	int constraintLightGold=rmCreateTypeDistanceConstraint("goldLightConst", "gold", 10.0);
   int constraintHeavyGold=rmCreateTypeDistanceConstraint("goldHeavyConst", "gold", 30.0);

	// Hunt constraints
	int constraintHerdable=rmCreateTypeDistanceConstraint("herdableConst", "herdable", 30.0);
   int constraintPredator=rmCreateTypeDistanceConstraint("predatorConst", "animalPredator", 20.0);
   int constraintFood=rmCreateTypeDistanceConstraint("animalConst", "food", 6.0);	

   int startingSettlementID=rmCreateObjectDef("startTC");
   	
	rmAddObjectDefItem(startingSettlementID, "Settlement Level 1", 1, 0.0);
   rmAddObjectDefToClass(startingSettlementID, rmClassID("startTC"));
   rmSetObjectDefMinDistance(startingSettlementID, 0.0);
   rmSetObjectDefMaxDistance(startingSettlementID, 0.0);
	// Constraints make sure inital placement of TC is in the center of player zone

	int startingTowerID=rmCreateObjectDef("Starting tower");
   rmAddObjectDefItem(startingTowerID, "tower", 1, 0.0);
  	rmSetObjectDefMinDistance(startingTowerID, 22.0);
   rmSetObjectDefMaxDistance(startingTowerID, 28.0);
   rmAddObjectDefConstraint(startingTowerID, constraintTowerToTower);
   rmAddObjectDefConstraint(startingTowerID, constraintImpassable);
	// Constraints used for tower placement around inital TC
	// Avoids placing down multiple towers to avoid them bunching up
	
	int startingGoldID=rmCreateObjectDef("Starting gold");
   rmAddObjectDefItem(startingGoldID, "Gold mine small", 1, 0.0);
   rmSetObjectDefMinDistance(startingGoldID, 20.0);
   rmSetObjectDefMaxDistance(startingGoldID, 25.0);
   rmAddObjectDefConstraint(startingGoldID, constraintHeavyGold);
   rmAddObjectDefConstraint(startingGoldID, constraintImpassable);
	// Constraints for the close gold near the initial TC

	float pigNumber=rmRandFloat(2, 4);
   int lightPigsID=rmCreateObjectDef("light pigs");
   rmAddObjectDefItem(lightPigsID, "pig", pigNumber, 2.0);
   rmSetObjectDefMinDistance(lightPigsID, 25.0);
   rmSetObjectDefMaxDistance(lightPigsID, 30.0);
   rmAddObjectDefConstraint(lightPigsID, constraintImpassable);
   rmAddObjectDefConstraint(lightPigsID, constraintFood);
	// Constraints used for the herdables (this case pigs)
	// Random number of pigs is defined to avoid random number spawning creating problems
	
	int lightChickensID=rmCreateObjectDef("light Chickens");

   if(rmRandFloat(0,1)<0.5){
      rmAddObjectDefItem(lightChickensID, "chicken", rmRandInt(6,10), 5.0); 
	} else {
      rmAddObjectDefItem(lightChickensID, "berry bush", rmRandInt(4,6), 4.0);
   }

   rmSetObjectDefMinDistance(lightChickensID, 20.0);
   rmSetObjectDefMaxDistance(lightChickensID, 25.0);
   rmAddObjectDefConstraint(lightChickensID, constraintImpassable);
   rmAddObjectDefConstraint(lightChickensID, constraintFood); 
	// Constraints for the placement of close berries or chickens
	// Which close hunt spawns is determined by a coin flip
	
   int lightBoarID=rmCreateObjectDef("light Boar");

   if(rmRandFloat(0,1)<0.7) {
      rmAddObjectDefItem(lightBoarID, "boar", rmRandInt(1,3), 4.0);
   } else {
      rmAddObjectDefItem(lightBoarID, "aurochs", rmRandInt(1,2), 2.0);
	}

   rmSetObjectDefMinDistance(lightBoarID, 30.0);
   rmSetObjectDefMaxDistance(lightBoarID, 50.0);
   rmAddObjectDefConstraint(lightBoarID, constraintImpassable);
	// Constraints for the wild hunt of either boars or auroches
	// Similar operation to the chickens and berries	

   ///////////////////////////////////////////////
   //Medium Constraints                         //                                           
   ///////////////////////////////////////////////

   int mediumGoldID=rmCreateObjectDef("medium gold");
   rmAddObjectDefItem(mediumGoldID, "Gold mine", 1, 0.0);
   rmSetObjectDefMinDistance(mediumGoldID, 40.0);
   rmSetObjectDefMaxDistance(mediumGoldID, 60.0);
   rmAddObjectDefConstraint(mediumGoldID, constraintHeavyGold);
   rmAddObjectDefConstraint(mediumGoldID, constraintEdge);
   rmAddObjectDefConstraint(mediumGoldID, constraintLightSettlement);
   rmAddObjectDefConstraint(mediumGoldID, constraintImpassable);
   rmAddObjectDefConstraint(mediumGoldID, constraintHeavySettlement);
	// Constraints for gold objects that have medium distance from starting TC

   int mediumPigsID=rmCreateObjectDef("medium pigs");
   rmAddObjectDefItem(mediumPigsID, "pig", 2, 4.0);
   rmSetObjectDefMinDistance(mediumPigsID, 50.0);
   rmSetObjectDefMaxDistance(mediumPigsID, 70.0);
   rmAddObjectDefConstraint(mediumPigsID, constraintImpassable);
   rmAddObjectDefConstraint(mediumPigsID, constraintHerdable);
   rmAddObjectDefConstraint(mediumPigsID, constraintHeavySettlement);
	// Constraints for Hunt objects that have medium distance from starting TC

   ///////////////////////////////////////////////
   //Heavy Constraints                          //                                    
   ///////////////////////////////////////////////

   int heavyGoldID=rmCreateObjectDef("far gold");
   rmAddObjectDefItem(heavyGoldID, "Gold mine", 1, 0.0);
   rmSetObjectDefMinDistance(heavyGoldID, 70.0);
   rmSetObjectDefMaxDistance(heavyGoldID, 160.0);
   rmAddObjectDefConstraint(heavyGoldID, constraintHeavyGold);
   rmAddObjectDefConstraint(heavyGoldID, constraintImpassable);
   rmAddObjectDefConstraint(heavyGoldID, constraintHeavySettlement);
	// Constraints for gold objects that have heavy distance from starting TC

	int heavyPigsID=rmCreateObjectDef("far pigs");
   rmAddObjectDefItem(heavyPigsID, "pig", 2, 4.0);
   rmSetObjectDefMinDistance(heavyPigsID, 80.0);
   rmSetObjectDefMaxDistance(heavyPigsID, 150.0);
   rmAddObjectDefConstraint(heavyPigsID, constraintImpassable);
   rmAddObjectDefConstraint(heavyPigsID, constraintHerdable);
   rmAddObjectDefConstraint(heavyPigsID, constraintHeavySettlement);
	// Constraints for herdables objects that have heavy distance from starting TC

   int heavyPredatorID=rmCreateObjectDef("far predator");
   float predatorSpecies=rmRandFloat(0, 1);

   if(predatorSpecies<0.5) { 
     	rmAddObjectDefItem(heavyPredatorID, "lion", 2, 4.0);
	} else {
     	rmAddObjectDefItem(heavyPredatorID, "bear", 1, 4.0);
	}

   rmSetObjectDefMinDistance(heavyPredatorID, 50.0);
   rmSetObjectDefMaxDistance(heavyPredatorID, 100.0);
   rmAddObjectDefConstraint(heavyPredatorID, constraintPredator);
   rmAddObjectDefConstraint(heavyPredatorID, constraintHeavySettlement);
   rmAddObjectDefConstraint(heavyPredatorID, constraintImpassable);
   // Constraints for predators that have heavy distance from starting TC
   // Coin flip decides if the spawn is bears or lions

   int farBerriesID=rmCreateObjectDef("far berries");
   rmAddObjectDefItem(farBerriesID, "berry bush", 10, 4.0);
   rmSetObjectDefMinDistance(farBerriesID, 0.0);
   rmSetObjectDefMaxDistance(farBerriesID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(farBerriesID, constraintImpassable);
	rmAddObjectDefConstraint(farBerriesID, constraintHeavySettlement);
   // Constraints for berries that have heavy distance from starting TC

 

   int bonusHuntableID=rmCreateObjectDef("bonus huntable");
   float bonusChance=rmRandFloat(0, 1);

   if(bonusChance<0.5)  
      rmAddObjectDefItem(bonusHuntableID, "boar", rmRandInt(2,3), 4.0);
   else if(bonusChance<0.8)
      rmAddObjectDefItem(bonusHuntableID, "deer", rmRandInt(6,8), 8.0);
   else
      rmAddObjectDefItem(bonusHuntableID, "aurochs", rmRandInt(1,3), 4.0);

   rmSetObjectDefMinDistance(bonusHuntableID, 0.0);
   rmSetObjectDefMaxDistance(bonusHuntableID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(bonusHuntableID, constraintHerdable);
   rmAddObjectDefConstraint(bonusHuntableID, constraintPredator);
   rmAddObjectDefConstraint(bonusHuntableID, constraintHeavySettlement);
   rmAddObjectDefConstraint(bonusHuntableID, constraintImpassable);
   // Constraints for huntables that have heavy distance from starting TC
   // 50% boars spawn, 30% deer spawn, 10% auroch spawn
   

}