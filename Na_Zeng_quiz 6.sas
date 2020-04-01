libname classdat "C:/Documents/EPI5143 Winter 2020/class_data"; /*write protecting original dataset*/
libname ex "C:/Documents/EPI5143 Winter 2020/Epi5143 Work Folder/data";/*Save modified datasets in separate class directory*/
proc sort data=classdat.NENCOUNTER out=COUNTER; /*make sure NENCOUNTER sorted by EncPatWID*/   
     by EncPatWID;
     run;
Data period; 
     set COUNTER;
     by EncPatWID;
	 if EncStartDtm=. then delete;
     year=year(datepart(EncStartDtm));
     If year ne 2003 then delete;
	 if EncVisitTypeCd= 'INPT' then inpatient=1;else inpatient=0;
	 if EncVisitTypeCd= 'EMERG' then emergency=1;else emergency=0;
	 if EncVisitTypeCd in ('INPT','EMERG') then either_one=1;else either_one=0;
     run;
	 /*create a flat file with one row per EncPatWID with inpatient encounter flag*/
	 Proc means data=period noprint;/*suppresses output*/
         class EncPatWID;
         types EncPatWID;/*only output results within EncPatWID (and not overall)*/
         Output out=inpatient  max(inpatient)=inpatient  n(inpatient)=count;
         run;
proc printto file="C:/CCHS/inpatient.txt" new;
options formchar="|----|+|---+=|-/\<>*"; 
	proc freq data=inpatient;
     tables count inpatient;
	 run;
	 proc printto;run;
	  /*
	           inpatient    Frequency     Percent     Frequency      Percent
              --------------------------------------------------------------
                      0        1817       62.85          1817        62.85  
                      1        1074       37.15          2891       100.00  
 

Answer for question a):
	 1074 patients had at least 1 inpatient encounter that started in 2003.
	 */


 /*create a flat file with one row per EncPatWID with emergency encounter flag*/
Proc means data=period noprint;
         class EncPatWID;
         types EncPatWID;
         Output out=emergency  max(emergency)=emergency  n(emergency)=count;
         run;
proc printto file="C:/CCHS/emergency.txt" new;
options formchar="|----|+|---+=|-/\<>*"; 
	proc freq data=emergency;
     tables count emergency;
	 run;
proc printto;run;
/*
                                                     Cumulative    Cumulative
              emergency    Frequency     Percent     Frequency      Percent
              --------------------------------------------------------------
                      0         913       31.58           913        31.58  
                      1        1978       68.42          2891       100.00  

                              
Answer for question b):
	 1987 patients had at least 1 emergency encounter that started in 2003.
	 */
 /*create a flat file with one row per EncPatWID with either emergency encounter or inpatient encounter flag*/
Proc means data=period noprint;
         class EncPatWID;
         types EncPatWID;
         Output out=eithertype max(either_one)=either_one n(either_one)=count;
         run;
proc printto file="C:/CCHS/eithertype.txt" new;
options formchar="|----|+|---+=|-/\<>*"; 
proc freq data=eithertype;
     tables either_one count/nopct;
	 run;
proc printto;run;
/*
                             The FREQ Procedure

                                                     Cumulative
                          either_one    Frequency     Frequency
                          -------------------------------------
                                   1        2891          2891 


                                                   Cumulative
                             count    Frequency     Frequency
                             --------------------------------
                                 1        2556          2556 
                                 2         270          2826 
                                 3          45          2871 
                                 4          14          2885 
                                 5           3          2888 
                                 6           1          2889 
                                 7           1          2890 
                                12           1          2891 

Answer for c) 2891 patients had at least 1 visit of either type (inpatient or emergency room encounter) that started in 2003.
Answer fro d) table above is the frequency table of the total encounter number for this dataset.*/

