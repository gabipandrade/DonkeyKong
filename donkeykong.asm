jmp main;pula para main

;variaveis
posMario: var #1
posAntMario: var #1

posBarril: var #1
posBarril2: var #1
posAntBarril: var #1
DirecaoBarril:var #1
countBarril: var #1
letra: var #1

;mensagens
Msn1: string "Voce Morreu :( Obrigado por jogar" 
Msn2: string "Voce Venceu :) Obrigado por jogar"

;---- Inicio da Main -----
main:
	loadn r1, #tela2Linha00;cenario exibido
	loadn r2, #2304 ;cor
	call ImprimeTela ; chama ImprimeTela
	
	loadn r1, #tela3Linha00 
	loadn r2, #3584
	call ImprimeTela
	
	call DrawKong
	call DrawMario
	loadn r3,#'O'
	loadn r4,#163
	store posBarril,r4
	outchar r3, r4
	
	loadn R0, #1082			
	store posMario, R0		; Posicao Atual do Mario
	store posAntMario, R0	; Posicao Anterior do Mario
	
	
	loadn R0,#163
	store posBarril, R0
	store posAntBarril, R0
	store posBarril2, R0
	
	
	loadn R0,#2500
	store countBarril, R0
	
	
	loadn R0, #0			; Contador para os Mods	= 0
	loadn R2, #0			; Para verificar se (mod(c/10)==0
	store DirecaoBarril,R0
	
	Loop:
		load R3, countBarril
		dec R3
    	store countBarril, R3
    	loadn R4,#0
    	cmp R3, R4
    	ceq AdicionaBarril
    	
    	loadn R1, #10
		mod R1, R0, R1
		cmp R1, R2		; if (mod(c/10)==0
		ceq MoveMario	; Chama Rotina de movimentacao do Mario
		
		loadn R1, #99999
		mod R1, R0, R1
		cmp R1, R2		; if (mod(c/10)==0
		ceq Atualiza_Barril
    	
    	call VerificaMorteBarril
		call VerificaVoceVenceu
		
		inc R0 	;c++
		jmp Loop
		
	halt 
	
AdicionaBarril:

rts	
VerificaVoceVenceu:
	push r0
	push r1
	load r0,posMario
	loadn r1,#162
	cmp r1,r0
	jeq VoceVenceu
	pop r0
	pop r1
	rts
	
VerificaMorteBarril:
	push r0
	push r1
	load r0,posMario
	load r1,posBarril
	cmp r1,r0
	jeq GameOver
	pop r0
	pop r1
	rts
		
DrawKong:
	push r0
	push r1
	loadn r0,#'K'
	loadn r1,#162
	outchar r0, r1
	pop r0
	pop r1
	rts
DrawMario:
	push r0
	push r1
	loadn r0,#'M'
	loadn r1,#1082
	outchar r0, r1
	pop r0
	pop r1
	rts
	
	
	
GameOver:
	call ApagaTela
	loadn r0, #526
	loadn r1, #Msn1 ;mensagem game over
	loadn r2, #2816
	call ImprimeStr2
	halt ;parar execução
	
	
	
VoceVenceu:
	call ApagaTela ;chama para apagar a tela
	loadn r0, #526
	loadn r1, #Msn2 
	loadn r2, #2816
	call ImprimeStr2 ;imprime mensagem
	
	halt ;parar execução
	
Atualiza_Barril:
    push r0;protege r0
    push r1;protege r1
    push r2;protege r2
    push r3;protege r3
    push r4;protege r4
    push r5;protege r5
    
    load r0, posBarril; Carrega a posição atual do barril
	call Delay;chama Delay
	  ;r0=posBarril
	  ;r1=tela3Linha00
    ; Calcula o endereço do caractere do cenário correspondente à posição do barril
    loadn r1, #tela3Linha00   ; Endereço inicial do cenário
    add r2, r1, r0           ; r2 = Tela3Linha00 + posBarril
    loadn r3, #40  			 ;r3=40 (caracteres)
    div r3, r0, r3           ; r3 = posBarril / 40
    add r2, r2, r3           ; r2 = Tela3Linha00 + posBarril + (posBarril / 40)
    loadi r1, r2             ; Carrega o caractere do cenário r1 na posição do barril r2
    outchar r1, r0           ; Restaura o caractere do cenário r1 na posição do barril r0 
    
    loadn r6,#0 ; r6=0
    loadn r5,#39;r5 =39
    loadn r3,#40; r3=40
    
    mod r4,r0,r3 ; Calcula o resto da divisão da posição do barril por 40, r4=mod (posBarril/40)
    cmp r4,r5 ; Compara o resto com 39
    jne NaoMudaDirecao  ; Se não for igual a 39, pula para NaoMudaDirecao
    
    
    ;Mudar Direcao
    loadn r5,#1;r5=1
    ;r0=posBarril
    add r0,r0,r3;r0=r0+40 cair 1 linha
    add r0,r0,r3;r0=r0+40
    ;add r0,r0,r3;r0=r0+40
    ;add r0,r0,r3;r0=r0+40
    
    
    load r2,DirecaoBarril; r2= endereço memoria DireçãoBarril
 
    cmp r2,r5;compara r2 com 1
    jeq MudaDirecaoDireita; se for igual muda direcao direita
    jne MudaDirecaoEsquerda;se não for igual muda direçao esquerda
    
    NaoMudaDirecao: ;nao muda direcao
    loadn r5,#0
    mod r4,r0,r3
    cmp r4,r5 ;r6=verificador se o mod eh igual a 0
    jne NaoMudaDirecao2
    add r0,r0,r3
    add r0,r0,r3
    add r0,r0,r3
    add r0,r0,r3
    jmp MudaDirecaoEsquerda    
    
    
    
    NaoMudaDirecao2:
    
    load r2,DirecaoBarril
    loadn r3,#0
    cmp r2,r3
    jeq MoveBarrilDireita
    
    load r2,DirecaoBarril
    loadn r3,#1
    cmp r2,r3
    jeq MoveBarrilEsquerda


    
 
Atualiza_Barril_Skip:
    store posBarril, r0      ; Atualiza a posição do barril
    call Delay
    
    loadn r1, #'O'           ; Caractere do Barril
    outchar r1, r0           ; Desenha o Barril na nova posição
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts
MoveBarrilDireita:
    inc r0                   ; Incrementa a posição do barril
    inc r0
    
    loadn r1,#1119
    cmp r0, r1               ; Verifica se a posição do barril ultrapassou o limite
    jne Atualiza_Barril_Skip
    loadn r0, #163             ; Se ultrapassou, volta para o início
    jmp Atualiza_Barril_Skip
MoveBarrilEsquerda:    
	dec r0                   ; decrementa a posição do barril
    dec r0
    
    loadn r1,#1119
    cmp r0, r1               ; Verifica se a posição do barril ultrapassou o limite
    jne Atualiza_Barril_Skip
    loadn r0, #163             ; Se ultrapassou, volta para o início
    jmp Atualiza_Barril_Skip

    
MudaDirecaoDireita:;muda direção direita
	load r2,DirecaoBarril;
    dec r2;decrementa direcao barril
    store DirecaoBarril,r2;carrega direcao barril com r2		    
    
    jmp NaoMudaDirecao
    
MudaDirecaoEsquerda: ;muda direção esquerda
	load r2,DirecaoBarril
    inc r2
    store DirecaoBarril,r2		    
    
    jmp NaoMudaDirecao2


MoveMario:
	push r0
	push r1
	push r2
	
	call MoveMario_RecalculaPos		; Recalcula Posicao do Mario

; So' Apaga e Redezenha se (pos != posAnt)
;	If (posMario != posAntMario)	{	
	load r0, posMario
	load r1, posAntMario
	cmp r0, r1
	jeq MoveMario_Skip	
	;Se Próxima instrucao do mario for o chao ou parede, nao move
		call MoveMario_Apaga
		call MoveMario_Apaga2
		call MoveNave_Desenha		;}
  MoveMario_Skip:
	
	pop r2
	pop r1
	pop r0
	rts

;--------------------------------
		
MoveMario_Apaga:		; Apaga o Mario preservando o Cenario!
	push R0
	push R1
	push R2
	push R3
	push R4
	push R5

	load R0, posAntMario	; R0 = posAnt
	
	loadn R1, #tela3Linha00	; Endereco onde comeca a primeira linha do cenario!!
	add R2, R1, r0	; R2 = Tela3Linha0 + posAnt
	loadn R4, #40
	div R3, R0, R4	; R3 = posAnt/40
	add R2, R2, R3	; R2 = Tela3Linha0 + posAnt + posAnt/40
	
	loadi R5, R2	; R5 = Char (Tela(posAnt))
	
	outchar R5, R0	; Apaga o Obj na tela com o Char correspondente na memoria do cenario
	
	pop R5
	pop R4
	pop R3
	pop R2
	pop R1
	pop R0
	rts
;----------------------------------	
	
MoveMario_Apaga2:		; Apaga o Mario preservando o Cenario!
	push R0
	push R1
	push R2
	push R3
	push R4
	push R5

	load R0, posAntMario	; R0 = posAnt
	loadn R4, #40
	sub R0, R0, R4
	
	; --> R2 = Tela1Linha0 + posAnt + posAnt/40  ; tem que somar posAnt/40 no ponteiro pois as linas da string terminam com /0 !!

	loadn R1, #tela3Linha00	; Endereco onde comeca a primeira linha do cenario!!
	add R2, R1, r0	; R2 = Tela1Linha0 + posAnt
	div R3, R0, R4	; R3 = posAnt/40
	add R2, R2, R3	; R2 = Tela1Linha0 + posAnt + posAnt/40
	
	loadi R5, R2	; R5 = Char (Tela(posAnt))
	
	outchar R5, R0	; Apaga o Obj na tela com o Char correspondente na memoria do cenario
	
	pop R5
	pop R4
	pop R3
	pop R2
	pop R1
	pop R0
	rts
;----------------------------------		

MoveMario_venceu:
			
	call ApagaTela   		;  Rotina para limpar a tela
	loadn r0, #526
	loadn r2, #2816
	call ImprimeStr2
		
	loadn r0, #605
	loadn r1, #Msn1
	loadn r2, #2816
	call ImprimeStr2
	
	
	; Se quiser jogar novamente...
	call ApagaTela
	
	pop r6
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0

	pop r0	; Da um Pop a mais para acertar o ponteiro da pilha, pois nao vai dar o RTS !!
	jmp main

MoveMario_RecalculaPos:		; Recalcula posicao da Mario em funcao das Teclas pressionadas
	push R0
	push R1
	push R2
	push R3
	push R4
	push R5
	push R6

	load R0, posMario
	
	load r1, posAntMario
	loadn r2, #120
	cmp r1, r2
	;jle MoveMario_venceu
	
	inchar R1				; Le Teclado para controlar a Mario
	loadn R2, #'a'
	cmp R1, R2
	jeq MoveMario_RecalculaPos_A
	
	loadn R2, #'d'
	cmp R1, R2
	jeq MoveMario_RecalculaPos_D
		
	loadn R2, #'w'
	cmp R1, R2
	jeq MoveMario_RecalculaPos_W
		
	loadn R2, #'s'
	cmp R1, R2
	jeq MoveMario_RecalculaPos_S
	
	
  MoveMario_RecalculaPos_Fim:	; Se nao for nenhuma tecla valida, vai embora
	store posMario, R0
	pop R6
	pop R5
	pop R4
	pop R3
	pop R2
	pop R1
	pop R0
	rts

  MoveMario_RecalculaPos_A:	; Move Mario para Esquerda
	loadn R1, #40
	loadn R2, #0
	mod R1, R0, R1		; Testa condicoes de Contorno 
	cmp R1, R2
	jeq MoveMario_RecalculaPos_Fim
	dec R0	; pos = pos -1
	loadn R1, #0
	loadn R3, #tela3Linha00
	loadn R4, #0
	loadn R2, #40
	;----Testa se saiu do chao--------
	loadn R5, #' '
	add R4, R0, R2 
	div R1, R4, R2  ;R1 = posMario / 40
	add R3, R3, R1  ;R3 = R3 + R1
	add R3, R3, R4  ;R3 = R3 + 41
	loadi R6, R3
	cmp R5, R6		;if (' ' == R6)
	jeq Queda_Mario
	jmp MoveMario_RecalculaPos_Fim
		
  MoveMario_RecalculaPos_D:	; Move Mario para Direita	
	loadn R1, #40
	loadn R2, #39
	mod R1, R0, R1		; Testa condicoes de Contorno 
	cmp R1, R2
	jeq MoveMario_RecalculaPos_Fim
	inc R0	; pos = pos + 1
	loadn R1, #0
	loadn R3, #tela3Linha00
	loadn R4, #0
	loadn R2, #40
	;----Testa se saiu do chao--------
	loadn R5, #' '
	add R4, R0, R2 
	div R1, R4, R2  ;R1 = posMario / 40
	add R3, R3, R1  ;R3 = R3 + R1
	add R3, R3, R4  ;R3 = R3 + 41
	loadi R6, R3
	cmp R5, R6		;if (' ' == R6)
	jeq Queda_Mario
	jmp MoveMario_RecalculaPos_Fim
	
  MoveMario_RecalculaPos_W:	; Move Mario para Cima
	loadn R1, #0
	loadn R2, #40
	loadn R3, #tela2Linha00
	loadn R4, #0
	loadn R5, #'H'
	
	add R4, R4, R0 
	div R1, R4, R2 ;Encontra a posicao atual do Mario / 40
	add R3, R3, R1 ;A posicao inicial da tela recebe o R1
	add R3, R3, R4 ;A posicao recebe o fator de correcao da tela para a memoria de video
	loadi R6, R3
	cmp R5, R6
	jne MoveMario_RecalculaPos_Fim
	loadn R1, #40
	sub R0, R0, R1	; pos = pos - 40
	jmp MoveMario_RecalculaPos_Fim

  MoveMario_RecalculaPos_S:	; Move Mario para Baixo
	loadn R1, #0
	loadn R3, #tela3Linha00
	loadn R4, #0
	loadn R2, #40

	;----Testa colisão com o chão--------
	loadn R5, #3619
	add R4, R0, R2 
	div R1, R4, R2  ;R1 = posMario / 40
	add R3, R3, R1  ;R3 = R3 + R1
	add R3, R3, R4  ;R3 = R3 + 41
	loadi R6, R3
	cmp R5, R6		;if ('#' == R6)
	jeq MoveMario_RecalculaPos_Fim
	add R0, R0, R2	; pos = pos + 40
	jmp MoveMario_RecalculaPos_Fim	
	
MoveNave_Desenha:	; Desenha caractere da Nave
	push R0
	push R1
	
	Loadn R1, #'M'	; Personagem
	load R0, posMario
	outchar R1, R0
	store posAntMario, R0	; Atualiza Posicao Anterior da Nave = Posicao Atual
	
	pop R1
	pop R0
	rts
;----------------------------------

Queda_Mario:
	loadn R1, #1160		; Testa condicoes de Contorno 	
	cmp R0, R1			; Se Barril chegou na ultima linha
	jle Queda_Mario2
	
	call ApagaTela
	
	call DigLetra
	loadn r0, #'s'
	load r1, letra
	cmp r0, r1				; tecla == 's' ?
	
	; Se quiser jogar novamente...
	call ApagaTela
	
	pop r6
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0

	pop r0	; Da um Pop a mais para acertar o ponteiro da pilha, pois nao vai dar o RTS !!
	jmp main
	
	Queda_Mario2:
	
	
	loadn R1, #0
	loadn R3, #tela3Linha00
	loadn R4, #0
	loadn R2, #40
	
	;----Testa colisão com o chão--------
	loadn R5, #3619
	add R4, R0, R2 
	div R1, R4, R2  ;R1 = posMario / 40
	add R3, R3, R1  ;R3 = R3 + R1
	add R3, R3, R4  ;R3 = R3 + 41
	loadi R6, R3
	cmp R5, R6		;if ('#' == R6) para de cair
	jeq MoveMario_RecalculaPos_Fim
	loadn R1, #40
	add R0, R0, R1
	store posMario, R0
	call Delay
	call MoveMario_Apaga
	call MoveMario_Apaga2
	call MoveNave_Desenha
	jmp Queda_Mario

;------------------------		
;********************************************************
;                   DIGITE UMA LETRA
;********************************************************

DigLetra:	; Espera que uma tecla seja digitada e salva na variavel global "Letra"
	push r0
	push r1
	loadn r1, #255	; Se nao digitar nada vem 255

   DigLetra_Loop:
		inchar r0			; Le o teclado, se nada for digitado = 255
		cmp r0, r1			;compara r0 com 255
		jeq DigLetra_Loop	; Fica lendo ate' que digite uma tecla valida

	store letra, r0			; Salva a tecla na variavel global "Letra"

	pop r1
	pop r0
	rts

;----------------	
ApagaTela:
	push r0
	push r1
	
	loadn r0, #1200		; apaga as 1200 posicoes da Tela
	loadn r1, #' '		; com "espaco"
	
	   ApagaTela_Loop:	;;label for(r0=1200;r3>0;r3--)
		dec r0
		outchar r1, r0
		jnz ApagaTela_Loop
 
	pop r1
	pop r0
	rts	

;Delay para a animacao de queda do mario quando passa da plataforma	
Delay:	
	push R1
	push R2
	
	loadn R1, #5
	loopj:
		loadn R2, #3000
	loopi:
		dec R2
		jnz loopi
		dec R1
		jnz loopj
		
	pop R2
	pop R1
	rts
DelayBarril:	
	push R1
	push R2
	
	loadn R1, #5
	loopj:
		loadn R2, #60000
	loopi:
		dec R2
		jnz loopi
		dec R1
		jnz loopj
		
	pop R2
	pop R1
	rts
	
ImprimeTela: ;  Rotina de Impresao de Cenario na Tela Inteira
		;  r1 = endereco onde comeca a primeira linha do Cenario
		;  r2 = cor do Cenario para ser impresso

	push r0	; protege o r3 na pilha para ser usado na subrotina
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	push r5	; protege o r5 na pilha para ser usado na subrotina
	push r6	; protege o r6 na pilha para ser usado na subrotina

	loadn R0, #0  	; posicao inicial tem que ser o comeco da tela!
	loadn R3, #40  	; Incremento da posicao da tela!
	loadn R4, #41  	; incremento do ponteiro das linhas da tela
	loadn R5, #1200 ; Limite da tela!
	loadn R6, #tela3Linha00	; Endereco onde comeca a primeira linha do cenario!!
	
   ImprimeTela2_Loop:
		call ImprimeStr2
		add r0, r0, r3  	; incrementaposicao para a segunda linha na tela -->  r0 = R0 + 40
		add r1, r1, r4  	; incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!) --> r1 = r1 + 41
		add r6, r6, r4  	; incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!) --> r1 = r1 + 41
		cmp r0, r5			; Compara r0 com 1200
		jne ImprimeTela2_Loop	; Enquanto r0 < 1200

	pop r6	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
				
;---------------------
;---- Inicio das Subrotinas -----
	
ImprimeStr2:	;  Rotina de Impresao de Mensagens:    r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso;  r1 = endereco onde comeca a mensagem; r2 = cor da mensagem.   Obs: a mensagem sera' impressa ate' encontrar "/0"
	push r0	; protege o r0 na pilha para preservar seu valor
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	push r5	; protege o r5 na pilha para ser usado na subrotina
	push r6	; protege o r6 na pilha para ser usado na subrotina
	
	
	loadn r3, #'\0'	; Criterio de parada
	loadn r5, #' '	; Espaco em Branco
	ImprimeStr2_Loop:
		loadi r4, r1
		cmp r4, r3		; If (Char == \0)  vai Embora
		jeq ImprimeStr2_Sai
		cmp r4, r5		; If (Char == ' ')  vai Pula outchar do espaco para na apagar outros caracteres
		jeq ImprimeStr2_Skip
		add r4, r2, r4	; Soma a Cor
		outchar r4, r0	; Imprime o caractere na tela
		storei r6, r4
   ImprimeStr2_Skip:
		inc r0			; Incrementa a posicao na tela
		inc r1			; Incrementa o ponteiro da String
		inc r6			; Incrementa o ponteiro da String da Tela 0
		jmp ImprimeStr2_Loop
	
   ImprimeStr2_Sai:	
	pop r6	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
	
;------------------------
;--------Tela em branco-----------------
tela0Linha00 : string "                                        "
tela0Linha01 : string "                                        "
tela0Linha02 : string "                                        "
tela0Linha03 : string "                                        "
tela0Linha04 : string "                                        "
tela0Linha05 : string "                                        "
tela0Linha06 : string "                                        "
tela0Linha07 : string "                                        "
tela0Linha08 : string "                                        "
tela0Linha09 : string "                                        "
tela0Linha10 : string "                                        "
tela0Linha11 : string "                                        "
tela0Linha12 : string "                                        "
tela0Linha13 : string "                                        "
tela0Linha14 : string "                                        "
tela0Linha15 : string "                                        "
tela0Linha16 : string "                                        "
tela0Linha17 : string "                                        "
tela0Linha18 : string "                                        "
tela0Linha19 : string "                                        "
tela0Linha20 : string "                                        "
tela0Linha21 : string "                                        "
tela0Linha22 : string "                                        "
tela0Linha23 : string "                                        "
tela0Linha24 : string "                                        "
tela0Linha25 : string "                                        "
tela0Linha26 : string "                                        "
tela0Linha27 : string "                                        "
tela0Linha28 : string "                                        "
tela0Linha29 : string "                                        "


;------Escadas------------
tela2Linha00 : string "                                        "
tela2Linha01 : string "          HH          H                 "
tela2Linha02 : string "          HH          H                 "
tela2Linha03 : string "          HH          H                 "
tela2Linha04 : string "          HH          H                 "
tela2Linha05 : string "                 H         H            "
tela2Linha06 : string "                 H         H            "
tela2Linha07 : string "                           H            "
tela2Linha08 : string "                 H         H            "
tela2Linha09 : string "        H     H                         "
tela2Linha10 : string "        H     H                         "
tela2Linha11 : string "        H     H          H              "
tela2Linha12 : string "                             H          "
tela2Linha13 : string "                             H          "
tela2Linha14 : string "                             H          "
tela2Linha15 : string "         H                              "
tela2Linha16 : string "         H                              "
tela2Linha17 : string "         H                              "
tela2Linha18 : string "                H                H      "
tela2Linha19 : string "                H                H      "
tela2Linha20 : string "                                 H      "
tela2Linha21 : string "                H                H      "
tela2Linha22 : string "                H                       "
tela2Linha23 : string "                H                       "
tela2Linha24 : string "                H                       "
tela2Linha25 : string "                H                       "
tela2Linha26 : string "                H                       "
tela2Linha27 : string "                H                      "
tela2Linha28 : string "                                        "
tela2Linha29 : string "                                        "

;------Plataforma1---------
tela3Linha00  : string "                                        "
tela3Linha01  : string "              ########                  "
tela3Linha02  : string "                                        "
tela3Linha03  : string "                                        "
tela3Linha04  : string "                                        "
tela3Linha05  : string "  ############### ######### ##          "
tela3Linha06  : string "                                        "
tela3Linha07  : string "                                        "
tela3Linha08  : string "                                        "
tela3Linha09  : string "      ## ##### #######################  "
tela3Linha10 : string "                                        "
tela3Linha11 : string "                                        "
tela3Linha12 : string "   ########################## ##        "
tela3Linha13 : string "                                        "
tela3Linha14 : string "                                        "
tela3Linha15 : string "      ### ##########################    "
tela3Linha16 : string "                                        "
tela3Linha17 : string "                                        "
tela3Linha18 : string "    ############ ################ #     "
tela3Linha19 : string "                                        "
tela3Linha20 : string "                                        "
tela3Linha21 : string "                                        "
tela3Linha22 : string "  ############## ####################   "
tela3Linha23 : string "                                        "
tela3Linha24 : string "                                        "
tela3Linha25 : string "                                        "
tela3Linha26 : string "                                        "
tela3Linha27 : string "                                        "
tela3Linha28 : string "########################################"
tela3Linha29 : string "                                        "


;Plataforma invisivel
tela4Linha00  : string "                                        "
tela4Linha01  : string "              ########                  "
tela4Linha02  : string "                                        "
tela4Linha03  : string "                                        "
tela4Linha04  : string "                               #        "
tela4Linha05  : string "  ############################ #        "
tela4Linha06  : string "                               #        "
tela4Linha07  : string "                               #        "
tela4Linha08  : string "   #                           #        "
tela4Linha09  : string "   #  ################################  "
tela4Linha10 : string "    #                                   "
tela4Linha11 : string "    #                            #      "
tela4Linha12 : string "   ############################# #      "
tela4Linha13 : string "                                 #      "
tela4Linha14 : string "   #                             #      "
tela4Linha15 : string "   #  ##############################    "
tela4Linha16 : string "   #                                    "
tela4Linha17 : string "   #                                #   "
tela4Linha18 : string "   ################################ #   "
tela4Linha19 : string "                                    #   "
tela4Linha20 : string "                                    #   "
tela4Linha21 : string "#                                   #   "
tela4Linha22 : string "# ###################################   "
tela4Linha23 : string "#                                       "
tela4Linha24 : string "#                                       "
tela4Linha25 : string "#                                       "
tela4Linha26 : string "#                                       "
tela4Linha27 : string "#                                       "
tela4Linha28 : string "########################################"
tela4Linha29 : string "                                        "
