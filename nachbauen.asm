; The following program is a small game in assembler. It will only run in the MCU8051 IDE due to some simulation components. The game is about a random pattern is showed for a short time period, and the user has to rebuild this pattern. The user will start with the score 3 and will +1 hen he has the pattern corect. -1 when the rebuild pattern is wrong.

; We the need the following components
; P0 7 LED Display
; P1 simple keypad
; P2 column of LED Matrix P2.0 - P2.6. P2.7 is unused
; P3 only P3.0 is used for the first row

;INIT Begin
score_board DATA P0
input DATA P1
output_x DATA P2
output_y DATA P3

;Constanly enable 1 to A in LED matrix
mov output_y, #01h
jmp init


;INIT END

win:
	mov output_x, #11000000b
	lcall wait
	mov output_x, #00110000b
	lcall wait
	mov output_x, #00001100b
	lcall wait
	mov output_x, #00000011b
	lcall wait
	mov output_x, #11000000b
	lcall wait
	mov output_x, #00110000b
	lcall wait
	mov output_x, #00001100b
	lcall wait
	mov output_x, #00000011b
	lcall wait
	jmp init


init:
	;The score of the user is saved in R7
	;Starting with score R7 =3
	mov R7, #03h
	;Set 7seg to 3
	lcall three_seg
	;Starting begin simulation
	lcall animation_anfang
	mov output_x, #0FFh

start:
	lcall wait
	mov A, R7
checkifwin:
	jmp iswin
checkiflost:
	cjne A, #00h, random
	jmp game_over

iswin:
	cjne A, #05h, checkiflost
	jmp win
random:
	dec R2
	inc R5
	mov A, R2
	add A, R5
	mov R2, A
	mov output_x, R2
	mov A, input
	cjne A, #00h, random
	mov A, R2

	mov output_x, R2
	lcall wait
	mov R0, output_x
	mov A, #001111111b
	anl A, R0
	mov R0, A
	mov output_x, #0FFh
eingabe: ;Eingabe des Musterrs
zeile_1: 
	mov A, input
	mov output_x, A
	jnb P1.7, zeile_1
abfrage: 
	mov A, R0
	cjne A, output_x, falsch

richtig: 
	mov A, R7
	inc A
	mov R7, A
	lcall select_7seg
	jmp start

falsch:
	mov A, R7
	dec A
	mov R7, A
	lcall select_7seg
	jmp start

wait:
	mov R5, #02h
w1_s1:
	mov R6, #001h

w1_s2:
	djnz R6, w1_s2
	djnz R5, w1_s1	
	ret 	

animation_anfang:
	mov output_x, #10101010b
	lcall wait
	mov output_x, #01010101b
	lcall wait
	mov output_x, #10101010b
	lcall wait
	ret

select_7seg:
	cjne R7, #00h, one_seg
	mov score_board, #00111111b  
	jmp game_over
	ret

one_seg:
	cjne R7, #01h, two_seg
	mov score_board, #00000110b
	ret
two_seg:
	cjne R7, #02h, three_seg
	mov score_board, #01011011b
	ret
three_seg:
	cjne R7, #03h, four_seg
	mov score_board, #01001111b
	ret 
four_seg:
	cjne R7, #04h, five_seg
	mov score_board, #01100110b
	ret
five_seg:
	cjne R7, #05h, game_over
	mov score_board, #01101101b
	ret
game_over:
	lcall wait
	lcall animation_anfang
	lcall wait
	lcall animation_anfang
	lcall wait
	jmp init
	
end