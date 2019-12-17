include "MmM_FE_lib.xs";


void initialConfig(){
        
        // Sets map parameters
        rmSetStatusText("Inital Config",0.01);
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
	
	// Changes loading bar
	rmSetStatusText("Inital Config Cleared",0.07);  
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


void main(){

        initialConfig();
	classDeclarations();





}
