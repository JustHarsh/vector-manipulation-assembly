;; ====================================
;; This file contains the code
;; to take an array (referred
;; to as a vector in this file)
;; and either print, rotate
;; left/right, exchange elements.
;; Functions in the file
;; (signatures written in C
;; style for readability):
;;
;; 1. inVect(int size, int[] vector)
;; Constructs a vector of integers
;; of size 'size' where each
;; integer is entered by the user.
;;
;; 2. prinVect(int size, int[] vector)
;; Prints vector entered by the user.
;;
;; 3. rotLeft(int size, int[] vector)
;; Rotates the input vector left by
;; one position.
;;
;; 4. rotRight(int size, int[] vector)
;; Rotates the input vector right by
;; one position.
;;
;; 5. exchange(int loc1, int loc2,
;;       int size, int[] vector)
;; Exchanges 2 elements in the input
;; vector based on their locations.
;;
;; 6. main()
;; Driver code for the whole program.
;;
;; Author: Sarthak Kaushik, Harsh Darji
;; Date: Nov 21, 2024
;; ====================================

;; Call to main
         CALL    main        
         STOP 
               
;; allocate memory on the heap
malloc:  LDWX    heapPtr,d   
         ADDA    heapPtr,d   
         STWA    heapPtr,d   
         RET                 

; ==================================
; FUNCTIONS START
; ==================================

;; ======= inVect =======
;; Function takes as input size
;; and address of vector and populates
;; the vector by asking user for input
;;
;; @param sizeI size of vector
;; @param vAddrI address of vector
;;
;Stack picture
;===============
;void inVect(int size, 
;        int[] vector)
cntr:    .EQUATE 0 ;#2d local var
;return address at 2
vAddrI:  .EQUATE 4 ;#2h parameter
sizeI:   .EQUATE 6 ;#2d parameter
;===============
inVect:  SUBSP   2,i ;#cntr push local var
         
         ;; setting index register to 0
         ;; to move through the array
         LDWX    0,i         
         LDWA    1,i
         ;; to print [1]:, [2]: and so on        
         STWA    cntr,s      

forIn:   CPWX    sizeI,s 
         ;; compare index register to
         ;; to sizeI and branch out of
         ;; forIn to endForIn if greater
         ;; than or equal to 0.  
         BRGE    endForIn    
         
         ;; print '[' and ']:'
         STRO    opnBr,d     
         DECO    cntr,s      
         STRO    clsBr,d     

         ;; take number as input
         ;; in vector at current
         ;; index
         ASLX ;; integers take 2 bytes         
         DECI    vAddrI,sfx  
         ASRX ;; undo ASLX      

         ADDX    1,i  ;; increment index       
         ADDA    1,i  ;; incremet counter to      
         STWA    cntr,s   ;; print next
                          ;; "[cntr]:" 

         BR      forIn       
endForIn:ADDSP   2,i ;#cntr pop local var
         RET
;; ======================               

;; ====== prinVect ======
;; Function to print the
;; input vector.
;;
;; @param sizeP size of vector
;; @param vAddrP address of vector
;;
;Stack picture
;===============
;void prinVect(int size, 
;        int[] vector)
;return address at 0
vAddrP:  .EQUATE 2 ;#2h parameter
sizeP:   .EQUATE 4 ;#2d parameter
;===============
prinVect:LDWX    0,i         

forPr:   CPWX    sizeP,s     
         BRGE    endForPr    

         ASLX                
         DECO    vAddrP,sfx  
         ASRX                

         LDBA    ' ',i       
         STBA    charOut,d   

         ADDX    1,i         
         BR      forPr       

endForPr:RET         
;; ======================

;; ====== rotLeft =======
;; Function to rotate a
;; vector left by one
;; position. This means
;; that the first and last
;; element will exchange
;; positions and all other 
;; elements will move one
;; position to the left.
;; 
;; @param sizeL size of
;;       vector
;; @param vAddrL address 
;;       of vector
;Stack picture
;===============
;void rotLeft(int size, 
;        int[] vector)
;
;store element at first
;position of vector
first:   .EQUATE 0 ;#2d local var
;return address at 2
vAddrL:  .EQUATE 4 ;#2h parameter
sizeL:   .EQUATE 6 ;#2d paramater
;===============
rotLeft: SUBSP   2,i ;#first
         
         ;;do not rotate if
         ;;lenth of array equals 1
         LDWA    sizeL,s    
         CPWA    1,i         
         BRLE    endRotL     
         
         ;;load index register
         ;;with 0 to traverse
         ;;array
         LDWX    0,i         
         
         ;;store vector[0] in first
         ASLX                
         LDWA    vAddrL,sfx  
         STWA    first,s     
         ASRX                

         LDWA    sizeL,s     
         SUBA    1,i         
         STWA    sizeL,s ;;size - 1

forL:    CPWX    sizeL,s
         ;; compare index register
         ;; to 0 and branch out of
         ;; forL to tmpAsnL     
         BRGE    tmpAsnL     
         
         ;; vector[i] = vector[i + 1]
         ;; where i is the current
         ;; index.
         ADDX    1,i         

         ASLX
         ;; vector[i + 1]                
         LDWA    vAddrL,sfx  
         ASRX                

         SUBX    1,i         

         ASLX
         ;; vector[i]              
         STWA    vAddrL,sfx  
         ASRX                
         
         ;; increment current index
         ADDX    1,i       
         BR      forL        

tmpAsnL: NOP1
         ;; vector[size - 1] = first
         ASLX                
         LDWA    first,s     
         STWA    vAddrL,sfx  
         ASRX                

         ;; reset sizeL
         LDWA    sizeL,s     
         ADDA    1,i         
         STWA    sizeL,s     

         BR      endRotL     

endRotL: ADDSP   2,i ;#first
         RET                 


;; ====== rotRight =======
;; Function to rotate a
;; vector right by one
;; position. This means
;; that the last and first
;; element will exchange
;; positions and all other 
;; elements will move one
;; position to the right.
;; 
;; @param sizeL size of
;;       vector
;; @param vAddrL address 
;;       of vector
;Stack picture
;===============
;void rotRight(int size, 
;        int[] vector)
;
;store element at last
;position of vector
last:    .EQUATE 0 ;#2d local variable
;return address 2
vAddrR:  .EQUATE 4 ;#2h parameter
sizeR:   .EQUATE 6 ;#2d parameter
;===============
rotRight:SUBSP   2,i ;#last

         ;; do not rotate if
         ;; lenth of array equals 1
         LDWA    sizeR,s     
         CPWA    1,i         
         BRLE    endRotR     

         SUBA    1,i         
         STWA    sizeR,s ;; sizeR - 1
         
         ;; load sizeR-1 into 
         ;; index register
         LDWX    sizeR,s     

         ;; store vector[sizeR-1] in last
         ASLX                
         LDWA    vAddrR,sfx  
         STWA    last,s      
         ASRX                

forR:    CPWX    0,i
         ;; compare index register
         ;; to 0 and branch out of
         ;; forR to tmpAsnR           
         BRLE    tmpAsnR     

         ;; vector[i] = vector[i - 1]
         ;; where i is the current
         ;; index.
         SUBX    1,i         

         ASLX    
         ;; vector[i - 1]           
         LDWA    vAddrR,sfx  
         ASRX                

         ADDX    1,i         

         ASLX    
         ;; vector[i]            
         STWA    vAddrR,sfx  
         ASRX                

         ;; decrement current index
         SUBX    1,i         
         BR      forR        

tmpAsnR: ASLX    
         ;; vector[0] = last             
         LDWA    last,s      
         STWA    vAddrR,sfx  
         ASRX                

         ;; reset sizeR
         LDWA    sizeR,s     
         ADDA    1,i         
         STWA    sizeR,s     

         BR      endRotR     

endRotR: ADDSP   2,i         ;#last
         RET                 


;; ====== exchange =======
;; Function to exchange
;; elements in position 
;; loc1 and loc2 in the 
;; vector. The locations 
;; are indexed starting at
;; 0.
;;
;;
;; @param sizeE size of
;;       vector
;; @param vAddrE address 
;;       of vector
;; @param loc1 first 
;;       location to be 
;;       swapped
;; @param loc2 second
;;       location to be
;;       swapped
;; @param confE contains
;;       value that will 
;;       be returned at 
;;       end of the function
;;
;Stack picture
;===============
;boolean exchange (int loc1,
;                int loc2,
;                int size,
;                int[] vector)
;
;store value of loc1
temp:    .EQUATE 0           ;#2d local var
;return address at 2
vAddrE:  .EQUATE 4           ;#2h
sizeE:   .EQUATE 6           ;#2d
loc2:    .EQUATE 8           ;#2d
loc1:    .EQUATE 10          ;#2d
confE:   .EQUATE 12          ;#2d return value
;===============
exchange:SUBSP   2,i         ;#temp


         LDWA    sizeE,s     

         ;; If the size of vector is 
         ;; 1 then branch to endExc
         CPWA    1,i         
         BRLE    endExc      

         ;; Checks for possible invalid
         ;; loc1 entered. so when loc1
         ;; is either less than 0 or 
         ;; greater than or equal to 
         ;; the size of the vector, then
         ;; branch to inval.
         LDWA    loc1,s      

         BRLT    inval       
         CPWA    sizeE,s     
         BRGE    inval       

         ;; Checks for possible invalid
         ;; loc1 entered. so when loc2
         ;; is either less than 0 or 
         ;; greater than or equal to 
         ;; the size of the vector, then
         ;; branch to inval.
         LDWA    loc2,s      

         BRLT    inval       
         CPWA    sizeE,s     
         BRGE    inval       
         
         ;; Load loc1 and store the 
         ;; value of loc1 in temp
         LDWX    loc1,s      
         ASLX                
         LDWA    vAddrE,sfx  
         STWA    temp,s      
         ASRX                

         ;; Load loc2 and the value
         ;; stored in loc2 which will 
         ;; now be stored in loc1 
         LDWX    loc2,s      
         ASLX                
         LDWA    vAddrE,sfx  
         ASRX                

         LDWX    loc1,s      
         ASLX                
         STWA    vAddrE,sfx  
         ASRX                

         ;; Load temp which contains
         ;; the original value of loc1
         ;; and store it in loc2
         LDWA    temp,s      
         LDWX    loc2,s      
         ASLX                
         STWA    vAddrE,sfx  
         ASRX                

         ;; In the case of successful 
         ;; exchange, 1 will be loaded
         ;; into confE to be returned. 
         LDWA    1,i         
         STWA    confE,s     
         
         ;; Branch to endExc
         BR      endExc      

;; In the case of unsuccessful 
;; exchange, 1 will be loaded
;; into confE to be returned. 
inval:   LDWA    0,i         
         STWA    confE,s     

endExc:  ADDSP   2,i         ;#temp
         RET                 

; ==================================
; FUNCTIONS END
; ==================================



; ===================================
; switch jump table
switchJt:.ADDRSS caseL       
         .ADDRSS caseR       
         .ADDRSS caseE       
         .ADDRSS caseQ       
         .ADDRSS default    

; ===================================
; START MAIN
; ===================================

;Stack picture
;===============
vAddr:   .EQUATE 0           ;#2h local var
size:    .EQUATE 2           ;#2d local var
loc1M:   .EQUATE 4           ;#2d local var
loc2M:   .EQUATE 6           ;#2d local var
input:   .EQUATE 8           ;#2d local var
isExch:  .EQUATE 10          ;#2d local var
;===============
main:    SUBSP   12,i        ;#isExch #input #loc2M #loc1M #size #vAddr
         
         ;; To keep track of isExch return
         ;; value
         LDWA    -1,i        
         STWA    isExch,s    
         
         ;; Output the start prompt
         ;; which asks for user 
         ;; input for size of vector
         STRO    szPrmpt,d   
         
         ;; Input and load the size
         ;; into the accumulator
         DECI    size,s      
         LDWA    size,s      
         ASLA                

         ;; Allocate memory using 
         ;; custom malloc
         CALL    malloc      
         STWX    vAddr,s     

;Stack picture for inVect
;===============
vAddrIM: .EQUATE 0           ;#2h
sizeIM:  .EQUATE 2           ;#2d
v:       .EQUATE 4           
sz:      .EQUATE 6           
;===============
         SUBSP   4,i         ;#sizeIM #vAddrIM
         
         LDWA    sz,s        
         STWA    sizeIM,s    

         LDWA    v,s         
         STWA    vAddrIM,s   

         ;; Calling inVect to fill
         ;; the vector with the 
         ;; right number of elements
         CALL    inVect      

         ADDSP   4,i         ;#vAddrIM #sizeIM

;Stack picture for prinVect
;===============
vAddrPM: .EQUATE 0           ;#2h
sizePM:  .EQUATE 2           ;#2d
vPM:     .EQUATE 4           
szPM:    .EQUATE 6           
;===============
         SUBSP   4,i         ;#sizePM #vAddrPM

         LDWA    szPM,s      
         STWA    sizePM,s    

         LDWA    vPM,s       
         STWA    vAddrPM,s   

         ;; Calling prinVect to print
         ;; the vector
         CALL    prinVect    

         ADDSP   4,i         ;#vAddrPM #sizePM

;; =================================
;; Switch case checking start
;; =================================

;; Prints prompt that asks for user input.
forM:    STRO    prompt,d    

reset:   LDWX    -1,i
         ;; Store -1 into input as 
         ;; default value
         STWX    input,s     

         ;; Load -1 into accumulator and
         ;; stores -1 as Default value 
         ;; of isExch
         LDWA    -1,i        
         STWA    isExch,s
    
         ;; Takes in user input using 
         ;; charIn and Compares value 
         ;; of charIn with a newline.
         ;; If input is a newline, 
         ;; branches back to get the
         ;; next possible input
         LDBA    charIn,d    
         CPBA    "\n",i      
         BREQ    reset       

         ;; Compares the user input to 
         ;; 'l' or 'L'. If the user 
         ;; gives input as 'l' or 'L'
         ;; Branch to code block named 
         ;; left which basically sets 
         ;; the input value to 0 which 
         ;; will be used to navigate to 
         ;; the right function call.
         CPBA    'l',i       
         BREQ    left        
         CPBA    'L',i       
         BREQ    left        

         ;; Compares the user input to 
         ;; 'r' or 'R'. If the user 
         ;; gives input as 'r' or 'R'
         ;; Branch to code block named
         ;; right which basically sets 
         ;; the input value to 1 which
         ;; will be used to navigate to 
         ;; the right function call.
         CPBA    'r',i       
         BREQ    right       
         CPBA    'R',i       
         BREQ    right       

         ;; Compares the user input to 
         ;; 'e' or 'E'. If the user 
         ;; gives input as 'e' or 'E'
         ;; Branch to code block named 
         ;; exchng which basically sets 
         ;; the input value to 2 which
         ;; will be used to navigate to 
         ;; the right function call.
         CPBA    'e',i       
         BREQ    exchng      
         CPBA    'E',i       
         BREQ    exchng      

         ;; Compares the user input to 
         ;; 'q' or 'Q'. If the user
         ;; gives input as 'q' or 'Q'
         ;; Branch to code block named
         ;; quit which basically sets
         ;; the input value to 3 which
         ;; will be used to navigate to 
         ;; the right function call.
         CPBA    'q',i       
         BREQ    quit        
         CPBA    'Q',i       
         BREQ    quit        

         ;; If the user inputs anything 
         ;; other than the allowed 
         ;; inputs, the value of input
         ;; will not be changed and 
         ;; thus will remain -1 and so 
         ;; it will branch to the 
         ;; default case.
         CPBX    -1,i        

         BREQ    default     

;; Code block left sets the value
;; of input to 0 and then branches 
;; to the ending code block.
left:    LDWX    0,i         
         STWX    input,s     
         BR      ending      

;; Code block right sets the value
;; of input to 1 and then branches
;; to the ending code block.
right:   LDWX    1,i         
         STWX    input,s     
         BR      ending      

;; Code block exchng sets the value
;; of input to 2 and then branches 
;; to the ending code block.
exchng:  LDWX    2,i         
         STWX    input,s     
         BR      ending      

;; Code block quit sets the value
;; of input to 3 and then branches 
;; to the ending code block.
quit:    LDWX    3,i         
         STWX    input,s     
         BR      ending      

;; Ending code block does a shift 
;; left operation on input
;; and branches to switchJt 
;; to check which switch case 
;; to go to. Since switch cases 
;; are stored with indexes 0, 2,
;; 4, 6,.... and so on, so when 
;; we do a ASLX on the following
;; input values (0, 1, 2, 3) we
;; can point to switch indexes
;; 0, 2, 4, and 6 respectively.
ending:  ASLX                ;2 byte address
         BR      switchJt,x  ;See the "x" mode

;; Code for switches
;; All cases end with a 
;; branch to the print 
;; block which will print 
;; the vector after each 
;; and every call that 
;; the user chooses to make.
caseL:   NOP1                
;Stack picture
;===============
vAddrLM: .EQUATE 0           ;#2h
sizeLM:  .EQUATE 2           ;#2d
vLM:     .EQUATE 4           
szLM:    .EQUATE 6           
;===============
         SUBSP   4,i         ;#sizeLM #vAddrLM

         LDWA    szLM,s      
         STWA    sizeLM,s    

         LDWA    vLM,s       
         STWA    vAddrLM,s   

         ;; Call is made to rotLeft
         CALL    rotLeft     

         ADDSP   4,i         ;#vAddrLM #sizeLM

         BR      print       

caseR:   NOP1                
;Stack picture
;===============
vAddrRM: .EQUATE 0           ;#2h
sizeRM:  .EQUATE 2           ;#2d
vRM:     .EQUATE 4           
szRM:    .EQUATE 6           
;===============
         SUBSP   4,i         ;#sizeRM #vAddrRM

         LDWA    szRM,s      
         STWA    sizeRM,s    

         LDWA    vRM,s       
         STWA    vAddrRM,s   

         ;; Call is made to rotRight
         CALL    rotRight    

         ADDSP   4,i         ;#vAddrRM #sizeRM

         BR      print       

caseE:   STRO    exMsg,d 
         ;; Takes in input 2 locations
         ;; that are to be replaced 
         ;; after printing message.    
         DECI    loc1M,s     
         DECI    loc2M,s     
;Stack picture
;===============
vAddrEM: .EQUATE 0           ;#2h
sizeEM:  .EQUATE 2           ;#2d
loc1EM:  .EQUATE 4           ;#2d
loc2EM:  .EQUATE 6           ;#2d
confEM:  .EQUATE 8           ;#2d
vzEM:    .EQUATE 10          
szEM:    .EQUATE 12          
l1EM:    .EQUATE 14          
l2EM:    .EQUATE 16          
;isEx:   .EQUATE 10
;===============
         SUBSP   10,i        ;#confEM #loc2EM #loc1EM #sizeEM #vAddrEM

         LDWA    l2EM,s      
         STWA    loc2EM,s    

         LDWA    l1EM,s      
         STWA    loc1EM,s    

         LDWA    szEM,s      
         STWA    sizeEM,s    

         LDWA    vzEM,s      
         STWA    vAddrEM,s   

         ;; Call is made to exchange
         CALL    exchange    
         ;; Return value of the function
         ;; is stored in confEM which is
         ;; then also stored into isExch
         ;; which is used to see if the
         ;; exchange was successfull. 
         ;; Upon a successful exchange,
         ;; the new vector is printed. 
         ;; However when the exchange 
         ;; is not successfull, meaning
         ;; the value of isExch is 0, 
         ;; the vector is printed without
         ;; any changes and a caution
         ;; message is displayed. 
         STWA    confEM,s    

         ADDSP   10,i        ;#vAddrEM #sizeEM #loc1EM #loc2EM #confEM

         STWA    isExch,s    

         BR      print       

caseQ:   STRO    messQ,d     
         BR      print       

default: STRO    messD,d     
         BR      print       


;; start of print
print:   NOP1                
;Stack picture
;===============
vAddrPM2:.EQUATE 0           ;#2h
sizePM2: .EQUATE 2           ;#2d
vPM2:    .EQUATE 4           
szPM2:   .EQUATE 6           
;===============
         SUBSP   4,i         ;#sizePM2 #vAddrPM2

         LDWA    szPM2,s     
         STWA    sizePM2,s   

         LDWA    vPM2,s      
         STWA    vAddrPM2,s  
         
         ;; Call is made to prinVect
         CALL    prinVect    
         ADDSP   4,i         ;#vAddrPM2 #sizePM2

         ;; If isExch is equal to 0, 
         ;; the exchange failed and 
         ;; a branch is made to the 
         ;; caution block which prints
         ;; a caution message.
         LDWA    isExch,s    
         BREQ    caution     
         
         ;; In all other cases, branch
         ;; is made to valid block which
         ;; checks if the program should
         ;; continue.
         BR      valid       

caution: STRO    invalE,d    
         BR      forM        

valid:   LDWX    input,s
         ;; If the input value is 3, 
         ;; this means that the user
         ;; entered 'Q' or 'q' as the
         ;; command choice, meaning 
         ;; the for loop will end 
         ;; and the program will end.
         ;; Otherwise in all other
         ;; cases, an unconditional
         ;; branch is made to forM 
         ;; to continue asking for 
         ;; the next user input.
         CPWX    3,i         
         BREQ    endFor      
         BR      forM        

endFor:  ADDSP   12,i        ;#vAddr #size #loc1M #loc2M #input #isExch
         RET                 


;===================================
; Data - global data
heapPtr: .ADDRSS heap        

szPrmpt: .ASCII  "How big is your vector? \x00"

opnBr:   .ASCII  "[\x00"     

clsBr:   .ASCII  "]: \x00"   

invalE:  .ASCII  "\nCaution: Out of Bounds Exchange Attempted\x00"

exMsg:   .ASCII  "Exchange which 2 locations?\n\x00"


prompt:  .ASCII  "\nEnter command. L = left R = right E = exchange Q = quit \x00"

messQ:   .ASCII  "Bye bye\n\x00"

messD:   .ASCII  "Wrong input please try again\n\x00"

chInput: .BLOCK  1           

heap:    .BLOCK  1           
         .END