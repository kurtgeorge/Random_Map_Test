include "MmM_FE_lib.xs";


initialConfig(){
        
        // Sets map parameters
        rmSetStatusText("",0.01);
        int tileCount = 8000;
        int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles/0.9);
        rmSetMapSize(size, size);

        // Default water level and type
	rmSetSeaLevel(0.0);
	rmSetSeaType(North Atlantic Ocean);
	
	// Map base texture
	string terrainBase = "SandA";
	rmTerrainInitialize(terrainBase);
	rmSetGaiaCiv(cCivZeus);
	
	// Changes loading bar
	rmSetStatusText("",0.07);     
}



void main(){

        initialConfig();






}
