*****************************************************************

** Assignment | Traffic Light Controller
** Hisni Mohammed M.H.  (E/15/131)

*****************************************************************

** Compile and run tb_labkit.v
        
	Compile	: iverilog -o tb_labkit.vvp tb_labkit.V
	Run     : vvp tb_labkit.vvp

*****************************************************************

** Notes    
 * Given code is modified to facilitate the second walk request.
 * Other than the things specified in lab sheet The Controller Takes 2 walk request signals and output is determined accordingly. Output is signals to 8 lights. 6 Street lights and 2 Walk lights.
 * Under normal circumstance, the cycle repeats continuously as specified in lab sheet.
 * When Pedestrian submit a walk request from Main street or Side street controller service the request after the Main Streets yellow light.
 * If Pedestrian submit a walk request from Main street,
	- Main Street Light will be Red and Side Street light will be Green.
	- Main Street Walk light will be ON and Side Street Walk light will be OFF.
* If Pedestrian submit a walk request from Side street,
	- Side Street light will be Red and Main Street Light will be Green.
	- Side Street Walk Light will be ON and Main Street Walk light will be OFF.
* If Pedestrians submits a walk request from both Main & Side street,
	- All the Street lights will be Red.
	- Both Main & Side Street Walk light will be ON.
* In every case, after a walk of tEXT seconds the, the traffic lights will return to their usual routine by turning the Side street Green.
* There is no change in Timing Parameters. Timing Parameters specified in lab sheet is used as it is.
* Procedure for sensor input is same as specified in lab sheet.

*****************************************************************
