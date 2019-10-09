
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
	
	rmSetStatusText("",0.07);
	
	
} 

void classDeclations(){

	
	int classPlayer = rmDefineClass("player");
	int classpatchCore = rmDefineClass("playercore");
	int classCliff = rmDefineClass("cliff");
	int classOcean =  rmDefineClass("ocean");
	rmDefineClass("corner");
	rmDefineClass("starting settlement");
	


}

void createdConstraints(){
	
	int edgeConstraint = rmCreateBoxConstraint("edge of map", rmXtilesToFraction(3), rmZTilesToFraction(3), 1.0-rmXtilesToFraction(3), 1.0-rmZTilesToFraction(3));
	
	
	
		
		
		
		
}

void main(){



	mapInitialisation();
	classDeclations();
	createdConstraints();









}
