/********************************************************************************
* PROJECTO: 	Econometría LAMBDA                           
* TITULO: 		Master Do File
* YEAR:			  2022
* Author: 		Rony Rodríguez-Ramírez
*********************************************************************************
	
*** Outline:
	0. Set initial configurations and globals
	1. RCT
	2. RDD

*********************************************************************************
*** PART 0: Set initial configurations and globals
********************************************************************************/

*** 0.0 Install required packages:
	local packages ietoolkit iefieldkit winsor estout outreg2 asdoc xml_tab outwrite reghdfe ftools
		
	foreach pgks in `packages' {	
	  				
		capture which `pgks'
		
		if (_rc != 111) {
			display as text in smcl "Paquete {it:`pgks'} está instalado "
		}
		
		else {
			display as error in smcl `"Paquete {it:`pgks'} necesita instalarse."'
			
			capture ssc install `pgks', replace
			
			if (_rc == 601) {
				display as error in smcl `"Package `pgks' is not found at SSC;"' _newline ///
				`"Please check if {it:`pgks'} is spelled correctly and whether `pgks' is indeed a user-written command."'
			}
			
			else {
				display as result in smcl `"Paquete `pgks' ha sido instalado."'
			}
		}
	}
	
	ieboilstart, version(14.0)
	
*** 0.1 Setting up users	
	if ("`c(username)'" == "ifyou") {
		// Absoluto
		global project 				"C:/Users/ifyou/Documents/RA Jobs/LAMBDA/econometria-avanzada"
	}
	
  else if ("`c(username)'" == "USERNAME") {
		global project 				""
	}
	
*** 0.2 Setting up folders		

	// Dinámicos 
	global codes						"${project}/codes"
	global data							"${project}/data"
	global outputs 					"${project}/outputs"
	
	// RCT
	global codes_rct				"${codes}/01-RCT"
	global data_rct					"${data}/01-RCT"
	global outputs_rct			"${outputs}/01-RCT"
	
	// RDD
	global codes_rdd				"${codes}/02-RDD"
	global data_rdd					"${data}/02-RDD"
	global outputs_rdd			"${outputs}/02-RDD"	
	
*** 0.3 Setting up execution 
	global rct 0
	global rdd 0

********************************************************************************
***	PART 1:RCT
********************************************************************************
	if (${rct} == 1) {
		do "${codes_rct}/01-RCT-tab-1.do"
		do "${codes_rct}/01-RCT-tab-3.do"
	} 

********************************************************************************
***	PART 2: RDD
********************************************************************************
	if (${rdd} == 1) {
		do "${codes_rdd}/02-RDD.do"
	} 


