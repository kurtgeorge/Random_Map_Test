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
	
	int towerConstraint=rmCreateTypeDistanceConstraint("TowerTowerConst", "tower", 20.0);
   	int towerConstraint=rmCreateTypeDistanceConstraint("TowerObjectConst","tower", 250);
	// Avoids tower conflicts 
	
	rmSetStatusText("pInit cleared",0.25);
}

void resourceInit()
	
	int goldLightConstraint=rmCreateTypeDistanceConstraint("goldLightConst", "gold", 10.0);
   	int goldHeavyConstraint=rmCreateTypeDistanceConstraint("goldHeavyConst", "gold", 30.0);



	int herdableConstraint=rmCreateTypeDistanceConstraint("herdableConst", "herdable", 30.0);
   	int predatorConstraint=rmCreateTypeDistanceConstraint("predatorConst", "animalPredator", 20.0);
   	int foodConstraint=rmCreateTypeDistanceConstraint("animalConst", "food", 6.0);


	
}

void main(){

        initialConfig();
	classDeclarations();
	globalConstraints();
	playerInit();
	resourceInit();



}
