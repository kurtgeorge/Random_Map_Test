
include "MmM_FE_lib.xs";


void mapInitialisation(){

	// Loading bar 
	rmSetStatusText("",0.01);
	int mapSizeMultiplier = 1;
	int playerTiles=8000;
	
	// Size of map (tile count)
	if(cMapSize == 1) {
		playerTiles = 10000;
		rmEchoInfo("Large map");
	}
	else if(cMapSize == 2) {
		playerTiles = 16000;
		rmEchoInfo("Giant map");
		mapSizeMultiplier = 2;
	}
	
	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles/0.9);
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);

	
	// Default water level
	rmSetSeaLevel(0.0);
	
	// Init map
	string terrainBase = "JungleA"; //"GrassA";
	rmTerrainInitialize(terrainBase);
	rmSetGaiaCiv(cCivZeus);
	
	// Changes loading bar
	rmSetStatusText("",0.07);
	
	
} 

void classDeclations(){

	
	int classPlayer = rmDefineClass("player");
	int classPlayerCore = rmDefineClass("player core");
	int classForest=rmDefineClass("forest");
	int classHill = rmDefineClass("classHill");
	int pathClass = rmDefineClass("path");
	int classStartingSettlement = rmDefineClass("starting settlement");
	
	// Changes loading bar
	rmSetStatusText("",0.13);


}


void globalConstraints(){
	
	int tinyAvoidImpassableLand = rmCreateTerrainDistanceConstraint("tiny avoid impassable land", "land", false, 1.0);
	int pathConstraint = rmCreateClassDistanceConstraint("areas vs path", pathClass, 2.0);
	int playerConstraint = rmCreateClassDistanceConstraint("stay away from players", classPlayer, 20);
	int avoidPlayerCore = rmCreateClassDistanceConstraint("stay away from player core", classPlayerCore, 30.0);
	int edgeConstraint = rmCreateBoxConstraint("edge of map", rmXTilesToFraction(8), rmZTilesToFraction(8), 1.0-rmXTilesToFraction(8), 1.0-rmZTilesToFraction(8));
	
	// Dunno
	int et = 20;
	int farEdgeConstraint = rmCreateBoxConstraint("far edge of map", rmXTilesToFraction(et), rmZTilesToFraction(et), 1.0-rmXTilesToFraction(et), 1.0-rmZTilesToFraction(et));
	
	// Changes loading bar
	rmSetStatusText("",0.20);
	
	
}


void main(){



	mapInitialisation();
	classDeclations();
	globalConstraints();









}
