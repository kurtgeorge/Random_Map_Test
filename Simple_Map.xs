include "MmM_FE_lib.xs";


void initialConfig(){
        
        // Sets map parameters
        rmSetStatusText("Init Cfig",0.01);
        int tileCount = 8000;
        int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles/0.9);
        rmSetMapSize(size, size);

        // Default water level and type
	rmSetSeaLevel(0.0);
	rmSetSeaType(Egyptian Nile);
	
	// Map base texture
	string terrainBase = "SandA";
	rmTerrainInitialize(terrainBase);
	rmSetGaiaCiv(cCivZeus);

	rmSetStatusText("Init Cfig Cleared",0.07);  
}

void classDeclarations(){
	
	rmSetStatusText("Class Dec",0.08);

	int classPlayer = rmDefineClass("player");
	int classGold = rmDefineClass("gold");
	int classWood = rmDefineClass("wood");
	int classStartTC = rmDefineClass("startTC");
	int classBackTC = rmDefineClass("backTC");

	rmSetStatus("Class Dec Cleared",0.13);
	
}

void globalConstraints(){
	
	rmSetStatusText("Global Const",0.14);

	int edgeConstraint=rmCreateBoxConstraint("edgeConst", rmXTilesToFraction(1), rmZTilesToFraction(1), 1.0-rmXTilesToFraction(1), 1.0-rmZTilesToFraction(1));
	int playerConstraint=rmCreateClassDistanceConstraint("playersConst", classPlayer, 20);  
	int centerConstraint=rmCreateClassDistanceConstraint("centerConst", rmClassID("center"), 15.0);
	int impassableConstraint=rmCreateTerrainDistanceConstraint("impassConst","land", 5.0);
	// Avoids general map conflicts
	
	rmSetStatusText("Global Const Cleared",0.20);
}

void playerInit(){
	
	rmSetStatusText("pInit",0.21);
	
	// Initial resource deployment
	for(i=1; <cNumberPlayers){
		rmAddPlayerResource(i,"Food", 300);
		rmAddPlayerResource(i,"Wood", 200);
		rmAddPlayerResource(i,"Gold", 100);
	}
	
	// Constraints
	int settlementLightConstraint=rmCreateTypeDistanceConstraint ("TCLightConst", "AbstractSettlement", 20.0);
	int settlementMediumConstraint=rmCreateTypeDistanceConstraint ("TCMediumConst", "AbstractSettlement", 40.0);
	int settlementHeavyConstraint=rmCreateTypeDistanceConstraint ("TCHeavyConst", "AbstractSettlement", 60.0);
	// Avoids conflicts with TC locations and the objects surrounding them
	
	int towerToTowerConstraint=rmCreateTypeDistanceConstraint("TowerTowerConst", "tower", 20.0);
   	int towerToObjectConstraint=rmCreateTypeDistanceConstraint("TowerObjectConst","tower", 250);
	// Avoids tower conflicts 
	
	rmSetStatusText("pInit cleared",0.25);
}

void resourceInit()

	// Gold constraints
	int goldLightConstraint=rmCreateTypeDistanceConstraint("goldLightConst", "gold", 10.0);
   	int goldHeavyConstraint=rmCreateTypeDistanceConstraint("goldHeavyConst", "gold", 30.0);

	// Hunt constraints
	int herdableConstraint=rmCreateTypeDistanceConstraint("herdableConst", "herdable", 30.0);
   	int predatorConstraint=rmCreateTypeDistanceConstraint("predatorConst", "animalPredator", 20.0);
   	int foodConstraint=rmCreateTypeDistanceConstraint("animalConst", "food", 6.0);	
}

void lightObjects(){
	
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
   	rmAddObjectDefConstraint(startingTowerID, towerToTowerConstraint);
   	rmAddObjectDefConstraint(startingTowerID, impassableConstraint);
	// Constraints used for tower placement around inital TC
	// Avoids placing down multiple towers to avoid them bunching up
	
	int startingGoldID=rmCreateObjectDef("Starting gold");
   	rmAddObjectDefItem(startingGoldID, "Gold mine small", 1, 0.0);
   	rmSetObjectDefMinDistance(startingGoldID, 20.0);
   	rmSetObjectDefMaxDistance(startingGoldID, 25.0);
   	rmAddObjectDefConstraint(startingGoldID, goldHeavyConstraint);
   	rmAddObjectDefConstraint(startingGoldID, impassableConstraint);
	// Constraints for the close gold near the initial TC

	float pigNumber=rmRandFloat(2, 4);
   	int closePigsID=rmCreateObjectDef("close pigs");
   	rmAddObjectDefItem(closePigsID, "pig", pigNumber, 2.0);
   	rmSetObjectDefMinDistance(closePigsID, 25.0);
   	rmSetObjectDefMaxDistance(closePigsID, 30.0);
   	rmAddObjectDefConstraint(closePigsID, impassableConstraint);
   	rmAddObjectDefConstraint(closePigsID, foodConstraint);
	// Constraints used for the herdables (this case pigs)
	// Random number of pigs is defined to avoid random number spawning creating problems
	
	
	int closeChickensID=rmCreateObjectDef("close Chickens");
   	if(rmRandFloat(0,1)<0.5){
      		rmAddObjectDefItem(closeChickensID, "chicken", rmRandInt(6,10), 5.0); 
	}
   	else {
      		rmAddObjectDefItem(closeChickensID, "berry bush", rmRandInt(4,6), 4.0);
	}
   	rmSetObjectDefMinDistance(closeChickensID, 20.0);
   	rmSetObjectDefMaxDistance(closeChickensID, 25.0);
   	rmAddObjectDefConstraint(closeChickensID, impassableConstraint);
   	rmAddObjectDefConstraint(closeChickensID, foodConstraint); 
	// Constraints for the placement of close berries or chickens
	// Which close hunt spawns is determined by a coin flip
	
	
   	int closeBoarID=rmCreateObjectDef("close Boar");
   	if(rmRandFloat(0,1)<0.7) {
      		rmAddObjectDefItem(closeBoarID, "boar", rmRandInt(1,3), 4.0);
	} else {
      		rmAddObjectDefItem(closeBoarID, "aurochs", rmRandInt(1,2), 2.0);
	}
   	rmSetObjectDefMinDistance(closeBoarID, 30.0);
   	rmSetObjectDefMaxDistance(closeBoarID, 50.0);
   	rmAddObjectDefConstraint(closeBoarID, impassableConstraint);
	// Constraints for the wild hunt of either boars or auroches
	// Similar operation to the chickens and berries	
}

void mediumObjects(){
	
	int mediumGoldID=rmCreateObjectDef("medium gold");
   	rmAddObjectDefItem(mediumGoldID, "Gold mine", 1, 0.0);
   	rmSetObjectDefMinDistance(mediumGoldID, 40.0);
   	rmSetObjectDefMaxDistance(mediumGoldID, 60.0);
   	rmAddObjectDefConstraint(mediumGoldID, goldHeavyConstraint);
   	rmAddObjectDefConstraint(mediumGoldID, edgeConstraint);
   	rmAddObjectDefConstraint(mediumGoldID, settlementLightConstraint);
   	rmAddObjectDefConstraint(mediumGoldID, impassableConstraint);
   	rmAddObjectDefConstraint(mediumGoldID, settlementHeavyConstraint);
	// Constraints for gold objects that have medium distance from starting TC

   	int mediumPigsID=rmCreateObjectDef("medium pigs");
   	rmAddObjectDefItem(mediumPigsID, "pig", 2, 4.0);
   	rmSetObjectDefMinDistance(mediumPigsID, 50.0);
   	rmSetObjectDefMaxDistance(mediumPigsID, 70.0);
   	rmAddObjectDefConstraint(mediumPigsID, impassableConstraint);
   	rmAddObjectDefConstraint(mediumPigsID, herdableConstraint);
   	rmAddObjectDefConstraint(mediumPigsID, settlementHeavyConstraint);
	// Constraints for Hunt objects that have medium distance from starting TC
	
}


void heavyObjects(){
	

	int farGoldID=rmCreateObjectDef("far gold");
   	rmAddObjectDefItem(farGoldID, "Gold mine", 1, 0.0);
   	rmSetObjectDefMinDistance(farGoldID, 70.0);
   	rmSetObjectDefMaxDistance(farGoldID, 160.0);
   	rmAddObjectDefConstraint(farGoldID, goldHeavyConstraint);
   	rmAddObjectDefConstraint(farGoldID, impassableConstraint);
   	rmAddObjectDefConstraint(farGoldID, settlementShortConstraint);
   	rmAddObjectDefConstraint(farGoldID, settlementHeavyConstraint);
	// Constraints for gold objects that have heavy distance from starting TC

	int farPigsID=rmCreateObjectDef("far pigs");
   	rmAddObjectDefItem(farPigsID, "pig", 2, 4.0);
   	rmSetObjectDefMinDistance(farPigsID, 80.0);
   	rmSetObjectDefMaxDistance(farPigsID, 150.0);
   	rmAddObjectDefConstraint(farPigsID, impassableConstraint);
   	rmAddObjectDefConstraint(farPigsID, herdableConstraint);
   	rmAddObjectDefConstraint(farPigsID, settlementHeavyConstraint);
	// Constraints for hunt objects that have heavy distance from starting TC
	
	
   	int farPredatorID=rmCreateObjectDef("far predator");
   	float predatorSpecies=rmRandFloat(0, 1);
   	if(predatorSpecies<0.5) { 
      		rmAddObjectDefItem(farPredatorID, "lion", 2, 4.0);
	} else {
      	rmAddObjectDefItem(farPredatorID, "bear", 1, 4.0);
	}
   	rmSetObjectDefMinDistance(farPredatorID, 50.0);
   	rmSetObjectDefMaxDistance(farPredatorID, 100.0);
   	rmAddObjectDefConstraint(farPredatorID, predatorConstraint);
   	rmAddObjectDefConstraint(farPredatorID, settlementHeavyConstraint);
   	rmAddObjectDefConstraint(farPredatorID, impassableConstraint);

	
}


void main(void){

        initialConfig();
	classDeclarations();
	globalConstraints();
	playerInit();
	resourceInit();
	lightObjects();
	mediumObjects();
	heavyObjects();


}
