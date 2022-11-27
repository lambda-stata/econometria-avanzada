/********************************************************************************
* Título:		RDD
* Autor:		Rony Rodriguez-Ramirez
* Proposito: 	Replicación del paper Pop-Eleches and Urquiola (2013)
*********************************************************************************
	
*** Outline:
	1. 	Analisis
		1.0 Global settings
		1.1 Load data
		1.2 Componer labels
		1.3 Drop observaciones y collapsar data
		1.4 Regresiones a cada lado del cutoffs
		1.5 Figure (scatter plot)
		1.6 Exportar figura
	
	Input: 	pop-eleches-urquiola-2013
	Output: figuras
	
********************************************************************************
***	PART 1: Analisis
*******************************************************************************/

*** 1.0 Global settings
	global fig                                                        ///            
      legend(off) mcolor(black red green)  clcolor(black red green) ///
			scheme(s1color) msymbol(Oh p p) xline(0) sort connect(. l l)
			
***	1.1 Load the data	
	use "${data_rdd}/pop-eleches-urquiola-2013.dta", clear 

*** 1.2	Componer labels
	label var relativescore "transition scores relative to the cutoffs"
	label var score 		    "transition scores"
	label var bexam_grade 	"the baccalaureate exam grade"

*** 1.3 Drop observaciones y collapssar data
  local i = 1
  local values = "1 2 3 4 5"
  foreach val in `values' {
    preserve
      drop if relativescore>=.`val' | relativescore<=-.`val'
      collapse (mean) score bexam_grade, by(relativescore)
      
      // Regresiones
      qui: reg score relativescore if relativescore<0 & relativescore!=0 
      predict panela1 if relativescore<0

      qui: reg score relativescore if relativescore>0 & relativescore!=0
      predict panela2 if relativescore>0

      // Figures
      twoway 	scatter score panela1 panela2 relativescore 		///
          if relativescore!=0, ${fig}							            ///
          ytitle(School level score) 							            ///
          xtitle(Score distance to cutoff) 					          ///
          title(Panel A: Average transition score, position(11) size(medium))
        
      // Export
      graph export "${outputs_rdd}/figs/fig_ex_`i'.pdf", replace    
      local ++i
    restore
  }

*** Código original  
	drop if relativescore>=.2| relativescore<=-.2
	sum score bexam_grade relativescore

	collapse (mean) score bexam_grade, by(relativescore)
	
*** 1.4 Regresiones a cada lado del cutoff
	qui: reg score relativescore if relativescore<0 & relativescore!=0 
	predict panela1 if relativescore<0
	
	qui: reg score relativescore if relativescore>0 & relativescore!=0
	predict panela2 if relativescore>0

*** 1.5 Figure (scatter plot)
	twoway 	scatter score panela1 panela2 relativescore 		///
			if relativescore!=0, ${fig}							            ///
			ytitle(School level score) 							            ///
			xtitle(Score distance to cutoff) 					          ///
			title(Panel A: Average transition score, position(11) size(medium))
      
*** 1.6 Exportar figura
  graph export "${outputs_rdd}/figs/fig1.pdf", replace     
      
*** 1.4 Regresiones a cada lado del cutoff
	reg bexam_grade relativescore if relativescore<0 & relativescore!=0 
	predict panelb1 if relativescore<0
	
	reg bexam_grade relativescore if relativescore>0 & relativescore!=0
	predict panelb2 if relativescore>0

*** 1.5 Figure (scatter plot)
	twoway 	scatter bexam_grade panelb1 panelb2 relativescore ///
			if relativescore!=0, ${fig}                           ///
			ytitle(School level score) 							              ///
			xtitle(Score distance to cutoff) 					            ///
			title(Panel E. Baccalaureate grade, position(11) size(medium))      
	
*** 1.6 Exportar figura
	graph export "${outputs_rdd}/figs/fig2.pdf", replace 

		
		