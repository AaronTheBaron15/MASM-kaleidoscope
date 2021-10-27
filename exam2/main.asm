; Program Name:exam2 practical           main.asm

; Program Description: implements the practical portion of exam 2 for CS278-1
; Author: Aaron Borjas (References the pseudocode provided by Matt Bell)
; Date: 4/18/20

INCLUDE Irvine32.inc
.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD

.data
    myColor DWORD ? ;for storing a color value
    colorArr DWORD 24 DUP(?) ;array of 24 values (the numbers in it are palindromes (horizontally symmetrical))
    cSize = ($ - colorArr)/4 ;96 (+ or - 4 to get next/previous element)
    count DWORD ? ;a variable to hold numbers 
    cStr DWORD " ", 0 ;empty string with a space in it (this is what is printed)

.code
main PROC
    call Randomize ;random seed
    mov ecx, 50d ;loops this many times
    L8:
        push ecx ;saves ecx so it doesnt loop infinitely
        call printArrs ;prints the 24x24 4fold symmetry thing
        pop ecx ;gets back ecx

        mov eax, 100 ;0.1 seconds
        call Delay ;waits .1 seconds before clearning the screen
        mov eax, (black*16)
        call SetTextColor
        ;call Clrscr ;clears the screen for the next iteration of the kaleidoscope
    loop L8

    mov dh, 30d ;sets the y value to 30
    mov dl, 1d ;sets the x value to 1 
    call GotoXY ;changes where the cursor is

    INVOKE ExitProcess,0
main ENDP

;////////////////////////////////////////////////////////////////
;function generateLine:
    ;This is a dummy function. Figure it out yourself :-)
    ;HINT: Generate horizontal symmetry here.
    ;HINT: Use this function to generate an array of colors.
generateLine PROC
    ;mov esi, OFFSET colorArr ;moves the first element of colorArr to esi

    ;mov edi, OFFSET [colorArr]+cSize ;moves the last element of the cArr to ebx

    mov esi, 0d; moves 0 to esi (for the first item in colorArr)
    mov edi, 96d ;moves 96 to edi (for the final item in colorArr)
    mov edx, OFFSET cStr ;moves the first character of cStr to edx
    mov ecx, 12d ;moves 12 to ecx (loops 12 times)
    L2:
        call getRandColor ;gets a random color (sets eax to that color)
        mov colorArr[esi], eax ;moves the random color's integer value an element in the first half of the array starting from the first element and moving inwards
        mov eax, myColor ;moves mycolor to eax
        mov colorArr[edi], eax ;moves the random color's integer value to an element in the second half of the array starting at the final element and moving inwards
        add esi, 4d ;adds 4 to esi (moves the pointer from the ith element in the left side of the array to the next element (4 bc DWORD))
        sub edi, 4d ;subtracts 4 from edi (moves the pointer from the ith element of the right side of the array to the previous element (4 bc DWORD))
        
    loop L2
    ret
generateLine ENDP
;///////////////////////////////////////////////////////////////// 

;///////////////////////////////////////////////////////////////// 
printArr PROC
    mov esi, 0 ;resets esi
    mov esi, OFFSET colorArr ;moves the first element of colorArr to esi

    mov ecx, cSize+1 ;loops 24 times over all elements in the array
    L3:
        mov edx, OFFSET cStr ;moves the starting value of cStr to edx to print
        mov eax, [esi] ;moves the element of the array at the current index to eax
        call SetTextColor ;sets the text color to the value stored in eax (which was moved from the color array)
        call WriteString ;prints the value moved into eax from the previous line
        add esi, 4d ;adds 4 to esi to get the next element in the colorArr

    loop L3
    ret
printArr ENDP
;///////////////////////////////////////////////////////////////// 

;///////////////////////////////////////////////////////////////// 
;printArrs references printAllLines from Dr. Bell's pseudocode
printArrs PROC
    mov ah, 1d ;sets the x value to zero for later
    mov al, 24d ;sets the x value to 23 for later
    mov ecx, 12d ;moves 12 to ecx to count down from (loops 12 times)
    L6:
        push eax ;saves eax so generateLine doesnt mess it up
        push ecx ;saves the value of ecx so it wont be changed by the generateLine function
        call generateLine ;generates an array of color values 
        pop ecx ;gets back the value of ecx for use in the L6 loop
        pop eax ;gets back the value of eax from the stack

        ;mov edx, 0d
        mov dl, 1d ;moves 1 to the x position for GotoXY
        mov dh, ah ;moves 1 from esi to dh for the y position in GotoXY
        call GotoXY ;sets the x,y position of the cursor to (0,0)

        push eax ;saves eax so printArr doesnt mess it up
        push edx ;saves edx so printArr doesnt mess it up
        push esi ;push esi so it doesnt get messed up by printArr
        push ecx ;push ecx so it doesnt get messed up by printArr
        call printArr ;calls the printArr function and prints the array at the specified xy location
        pop ecx ;pops ecx back so that we can use it again
        pop esi ;pops esi back so we can use it again
        pop edx ;gets back the value of edx from the stack
        pop eax ;gets back the value of eax from the stack

        mov dl, 1d ;moves 1 to dl to make sure the x position is the same
        mov dh, al ;moves 24 from edi to dh for the y position in GotoXY
        call GotoXY ;sets the x,y position of the cursor to (23, 0)

        push eax ;saves eax so printArr doesnt mess it up
        push edx ;saves eax so printArr doesnt mess it up
        push esi ;push esi so it doesnt get messed up by printArr
        push ecx ;push ecx so it doesnt get messed up by printArr
        call printArr ;calls the printArr function and prints the array at the specified xy location
        pop ecx ;pops ecx back so we can use it again
        pop esi ;pops esi back so we can use it again
        pop edx ;gets back the value of edx from the stack
        pop eax ;gets back the value of eax from the stack

        inc ah ;increments esi so it can make the next line
        dec al ;decrements edi so it can make the previous line
    loop L6
    ret
printArrs ENDP
;///////////////////////////////////////////////////////////////// 

;////////////////////////////////////////////////////////////////
;function getRandColor
;gets a random color from irvine library
getRandColor PROC
    mov eax, 10 ;random number from 0 to 10
    call RandomRange ;gets a random number from 0 to 10

    CMP eax, 0 ;compare eax to 0
    JE cBlack ;jump to cBlack if eax is 0
    CMP eax, 1 ;compare eax to 1
    JE cBlue ;jump to cBlue if eax is 1
    CMP eax, 2 ;compare eax to 2
    JE cGreen ;jump to cGreen if eax is 2
    CMP eax, 3 ;compare eax to 3
    JE cCyan ;jump to cCyan if eax is 3
    CMP eax, 4 ;compare eax to 4
    JE cRed ;jump to cREd if eax is 4
    CMP eax, 5 ;compare eax to 5
    JE cMagenta ;jump to cMagenta if eax is 5
    CMP eax, 6 ;compare eax to 6
    JE cBrown ;jump to cBrown if eax is 6
    CMP eax, 7 ;compare eax to 7
    JE cGray ;jump to cGrey if eax is 7
    CMP eax, 8 ;compare eax to 8
    JE cYellow ;jump to cYellow if eax is 8
    CMP eax, 9 ;compare eax to  9
    JE cWhite ;jump to cWhite if eax is 9

    cBlack:
        mov eax, (black*16) ;sets the background color to black, moves that to eax
        call SetTextColor ;sets the text color to what was moved to eax
        jmp finish
    cBlue:
        mov eax, (blue*16) ;sets the background color to blue, moves that to eax
        call SetTextColor ;sets the text color to what was moved to eax
        jmp finish
    cGreen:
        mov eax, (green*16) ;sets the background color to green, moves that to eax
        call SetTextColor ;sets the text color to what was moved to eax
        jmp finish
    cCyan:
        mov eax, (cyan*16) ;sets the background color to cyan, moves that to eax
        call SetTextColor ;sets the text color to what was moved to eax
        jmp finish
    cRed:
        mov eax, (red*16) ;sets the background color to red, moves that to eax
        call SetTextColor ;sets the text color to what was moved to eax
        jmp finish
    cMagenta:
        mov eax, (magenta*16) ;sets the background color to magenta, moves that to eax
        call SetTextColor ;sets the text color to what was moved to eax
        jmp finish
    cBrown:
        mov eax, (brown*16)  ;sets the background color to brown, moves that to eax
        call SetTextColor ;sets the text color to what was moved to eax
        jmp finish
    cGray:
        mov eax, (gray*16) ;sets the background color to gray, moves that to eax
        call SetTextColor ;sets the text color to what was moved to eax
        jmp finish
    cYellow:
        mov eax, (yellow*16) ;sets the background color to yellow, moves that to eax
        call SetTextColor ;sets the text color to what was moved to eax
        jmp finish
    cWhite:
        mov eax, (white*16) ;sets the background color to white, moves that to eax
        call SetTextColor ;sets the text color to what was moved to eax
        jmp finish

    finish:
       mov myColor, eax ;moves the color stored in eax to myColor just in case it needs to be accessed later
       

    ret
getRandColor ENDP
;////////////////////////////////////////////////////////////////

END main