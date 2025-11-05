.model small                    ; Define the memory model as small (separate code and data segments)
.stack 100h                     ; Reserve 256 bytes of stack memory (100h = 256 in hex)
               
               
               
.data                               ; Begin data segment
  nums DB 23, 45, 67, 45, 23, 56    ; Define a list of 6 numbers (bytes)
  count DB 6                        ; Define count = 6, used for loop control
  label DB 'DataSet = ', '$'        ; Text label to print before numbers (terminated by '$')
  space DB ' ', '$'                 ; A single space character for separation (terminated by '$')
  newline DB 13, 10, '$'            ; Carriage return (13) + line feed (10) for newline (terminated by '$')
                  
                  
                  
                  
                  
.code                    ; Begin code segment
start:                   ; Entry point of the program
  mov ax, @data          ; Load address of data segment into AX
  mov ds, ax             ; Copy AX into DS (data segment register)
                   
                   
                   
  ; === Print label ===
  lea dx, label                                 ; Load address of label string into DX
  mov ah, 09h                                   ; Function 09h of int 21h = Print string until '$'
  int 21h                                       ; Call DOS interrupt to print the label
              
              
              
  ; === Initialize loop ===
  mov cl, count          ; Set loop counter (CL) to 6
  mov si, 0              ; Initialize index (SI) to 0
                 
                 
                 
print_loop:
  ; === Load current number ===
  mov al, [nums + si]               ; Load current number from nums[si] into AL
  mov ah, 0                         ; Clear AH (prepare for division)
  mov bl, 10                        ; Set divisor to 10 (for decimal split)
  div bl                            ; Divide AX by 10 ? AH = quotient (tens), AL = remainder (units)
         
         
  ; === Print tens digit ===
  add ah, 30h                   ; Convert tens digit to ASCII by adding 48 (30h)
  mov dl, ah                    ; Move ASCII digit into DL
  mov ah, 02h                   ; Function 02h of int 21h = Print character in DL
  int 21h                       ; Call DOS interrupt to print tens digit
                    
                    
  ; === Print units digit ===
  add al, 30h                                            ; Convert units digit to ASCII
  mov dl, al                                             ; Move ASCII digit into DL
  mov ah, 02h                                            ; Prepare for print
  int 21h                                                ; Print units digit
            
            
            
  ; === Print space ===
  lea dx, space                     ; Load address of space string
  mov ah, 09h                       ; Function 09h = Print string until '$'
  int 21h                           ; Print space
          
          
          
  inc si                            ; Move to next number in array
  loop print_loop                   ; Decrease CL and repeat if CL ? 0
                     
                     
                     
  ; === Move to newline (optional) ===
  lea dx, newline                   ; Load address of newline characters (CR + LF)
  mov ah, 09h                       ; Function to print string
  int 21h                           ; Print newline
                 
                 
                 
                 
  ; === Exit ===
  mov ah, 4Ch            ; Function 4Ch = Terminate program
  int 21h                ; Exit to DOS
