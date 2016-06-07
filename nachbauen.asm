; P0 7 LED Display
; P1 simple keypad
; P2 16xLeds

;INIT ANFANG
score_board DATA P0
input DATA P1
output_x DATA P2


;INIT ENDE


mov R7, #03h
lcall three_seg
lcall animation_anfang

mov output_x, #0FFh


start:
	lcall wait
	mov A, score_board
	cjne A, #00h, warte_pins
	jmp game_over
warte_pins:
	dec R2
	inc R5
	mov A, R2
	add A, R5
	mov R2, A
	mov A, input
	cjne A, #00h, warte_pins
	mov A, #010000000b
	orl A, R2
	mov R2, A

	mov output_x, R2
	lcall wait
	mov R0, output_x
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

normal_hoch:
	mov score_board, R4
	jmp animation_richtig

falsch:
	mov A, R7
	dec A
	mov R7, A
	lcall select_7seg
	jmp start
	
normal_runter: 
	mov score_board, R4
	jmp animation_falsch
wait:
	mov R6, #02h
w1_s1:
	mov R7, #001h

w1_s2:
	djnz R7, w1_s2
	djnz R6, w1_s1	
	ret 	

animation_richtig:
	mov output_x, #11110110b
	lcall wait
	mov output_x, #0FFh
	lcall wait
	mov output_x, #00h
	lcall wait
	jmp start

animation_falsch:
	mov output_x, #0FFh
	lcall wait
	mov output_x, #00h
	lcall wait
	mov output_x, #0FFh
	lcall wait
	mov output_x, #00h
	lcall wait
	jmp start

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
	mov output_x, #0FFh
	jmp game_over
end