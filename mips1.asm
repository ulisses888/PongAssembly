#Unit Width 8
#Unit Height 8
#Display Width 256
#Display Height 256
#Base address 0x10010000 (static data)


.data
	bitmap: .space 4096
	tamanho: .word 4
	vetor: .word 0xFF000000, 0xff873800, 0xff0022, 0x0400ff, 0xFFFFFFFF #Preto,Marrom,Vermelho,Azul e Branco
	fraseMenu: .asciiz "\n\nEscolha uma das opções abaixo:\n 1 - Jogar\n 2 - Como Jogar\n 3 - Sair\n"
	comoJogar1: .asciiz "\n\nConecte o Bitmap display e o Teclado\n Unit 8x8 Display 256x256\n Base adress - Static data"
	comoJogar2: .asciiz "\nPlayer 1 - W Para cima e S Para baixo\nPlayer 2 - O Para cima e L Para baixo\nNao segure os botoes apenas clique!"
	comoJogar3: .asciiz "\nDesative o CAPSLOCK do teclado!"
	comoJogar4: .asciiz "\nBom jogo, ganha o usuario que fizer 5 pontos primeiro\n"
	comoJogar5: .asciiz "Digite 1 para continuar ou qualquer outra tecla para sair\n"
	pontosP1: .word 0
	pontosP2: .word 0
	p1Pontua: .asciiz "Ponto do Player 1"
	p2Pontua: .asciiz "Ponto do Player 2"
	placar: .asciiz "\nPlacar:\n"
	placarX: .asciiz " X "
	continuar: .asciiz "Continuar partida"
	vitoriaP1: .asciiz "Player 1 Ganhou!!"
	vitoriaP2: .asciiz "Player 2 Ganhou!!"
	fim: .asciiz "Fim da partida voce voltara ao menu!"
.text

menu:
li $v0,4
la $a0,fraseMenu
syscall

li $v0,5
syscall

beq $v0,1,iniciar
beq $v0,2,tutorial

j sair

tutorial:
li $v0,4
la $a0,comoJogar1
syscall

la $a0,comoJogar2
syscall

la $a0,comoJogar3
syscall

la $a0,comoJogar4
syscall

la $a0,comoJogar5
syscall

li $v0,5
syscall

beq $v0,1,menu

sair:
li $v0,10
syscall

iniciar:

li $t0,0x10010000 #endereco base
li $s6, 0xFFFF0000   # Keyboard Control
li $s7, 0xFFFF0004   # Keyboard Data

jal reset
jal bordas

li  $t9, 0       # contador de delay da bols
#li  $s7, 40000)

li $s0,13 #base p1
li $s1,13 #base p2
li $s2,15 #x bola
li $s3,15 #y bola
li $s4,1 # 1 direita -1 esquerda
li $s5,0 # 1 = cima, 0 = reto, -1 baixo
#tamanho raquete 5
# 32 x 32 tamanho grid
jal raquetes
jal bola

j loopPrincipal


loopPrincipal:
lw   $t0, 0($s6)      # Lê Keyboard Control
andi $t0, $t0, 1
beq  $t0, $zero, atualizar

# Lê a tecla
lw   $t1, 0($s7)      # ASCII da tecla

# Compara com 'w'
li   $t2, 'w'
beq  $t1, $t2, player1Cima

# Compara com 's'
li   $t2, 's'
beq  $t1, $t2, player1Baixo

# Compara com 'o'
li   $t2, 'o'
beq  $t1, $t2, player2Cima

# Compara com 'l'
li   $t2, 'l'
beq  $t1, $t2, player2Baixo

atualizar:
addi $t9, $t9, 1
bne  $t9, 40000, pulaAtualizar
jal  atualizarBola
li   $t9, 0
pulaAtualizar:
j    loopPrincipal

li $v0,10
syscall
###############
bola:
addi $sp,$sp,-4
sw $ra,($sp)

move $a0,$s2
move $a1,$s3
li $a2,4
jal pintar

lw $ra,($sp)
addi $sp,$sp,4
jr $ra

resetBola:
li $s0,13 #base p1
li $s1,13 #base p2
li $s2,15 #x bola
li $s3,15 #y bola
li $s4,1 # 1 direita -1 esquerda
li $s5,0 # 1 = cima, 0 = reto, -1 baixo

addi $sp,$sp,-4
sw $ra,($sp)

jal reset
jal bordas
jal raquetes
jal bola

lw $ra,($sp)
addi $sp,$sp,4
jr $ra
###############
atualizarBola:

addi $sp,$sp,-4
sw $ra,($sp)

jal colisaoEsquerda
jal colisaoDireita
jal colisaoTopo
jal colisaoBase
jal player1pontua
jal player2pontua

move $a0,$s2
move $a1,$s3
li $a2,0
jal pintar

add $s2,$s2,$s4
add $s3,$s3,$s5

jal bola

lw $ra,($sp)
addi $sp,$sp,4
jr $ra

colisaoEsquerda:
bne $s2,2,devolve
move $t0,$s0
li $t1,0 # contador
loopEsquerda:
beq $t1,5,devolve
beq $t0,$s3,colidiuEsq
addi $t1,$t1,1
addi $t0,$t0,1
j loopEsquerda
colidiuEsq:
li $s4,1
beq $t1,0,colidiuBaixoRaquete
beq $t1,1,colidiuBaixoRaquete
beq $t1,2,colidiuRetoRaquete
beq $t1,3,colidiuCimaRaquete
beq $t1,4,colidiuCimaRaquete
jr $ra
###################
colidiuRetoRaquete:
li $s5,0
j devolve
colidiuCimaRaquete:
li $s5,1
j devolve
colidiuBaixoRaquete:
li $s5,-1
j devolve
# s5 1 = cima, 0 = reto, -1 baixo
###################
colisaoDireita:
bne $s2,29,devolve
move $t0,$s1
li $t1,0 # contador
loopDireita:
beq $t1,5,devolve
beq $t0,$s3,colidiuDir
addi $t1,$t1,1
addi $t0,$t0,1
j loopDireita
colidiuDir:
li $s4,-1
beq $t1,0,colidiuBaixoRaquete
beq $t1,1,colidiuBaixoRaquete
beq $t1,2,colidiuRetoRaquete
beq $t1,3,colidiuCimaRaquete
beq $t1,4,colidiuCimaRaquete
jr $ra
devolve:
jr $ra

colisaoTopo:
bne $s3,1,devolve
li  $t0, -1
bne $s5, $t0, devolve
li  $s5, 1
jr  $ra

colidiuCima:
li $s5,-1
jr $ra

colisaoBase:
bne $s3,30,devolve
li  $t0, 1
bne $s5, $t0, devolve
li  $s5, -1  
jr  $ra

colidiuBaixo:
li $s5,1
jr $ra

###############
#li $s4,1 # 1 direita -1 esquerda
#li $s5,0 # 1 = cima, 0 = reto, -1 baixo
###############

player1Cima:
beq $s0,1,fimMovimento

addi $s0,$s0,-1
jal raquetes
li $a0,1
move $a1,$s0
addi $a1,$a1,5
li $a2,0
jal pintar
j loopPrincipal

player1Baixo:
beq $s0,26,fimMovimento
addi $s0,$s0,1
jal raquetes
li $a0,1
move $a1,$s0
addi $a1,$a1,-1
li $a2,0
jal pintar
j loopPrincipal

###############

player2Cima:
beq $s1,1,fimMovimento

addi $s1,$s1,-1
jal raquetes
li $a0,30
move $a1,$s1
addi $a1,$a1,5
li $a2,0
jal pintar
j loopPrincipal

player2Baixo:
beq $s1,26,fimMovimento
addi $s1,$s1,1
jal raquetes
li $a0,30
move $a1,$s1
addi $a1,$a1,-1
li $a2,0
jal pintar
j loopPrincipal

###############
fimMovimento:
j loopPrincipal
###############
raquetes: #13-17 xp1 - 1 x p2 - 30 bases em s0 e s1
addi $sp,$sp,-4
sw $ra,($sp)

li $t8,0 # contador
# a0 = x, a1 = y, a2 = cor (0 = preto, 1 = marrom, 2 = vermelho, 3 = azul)
#desenhar p1

li $a0,1
move $a1,$s0
li $a2,2
desenharp1:
jal pintar
addi $a1,$a1,1
addi $t8,$t8,1
beq $t8,5,proxDesenho
j desenharp1
###############
proxDesenho:
li $t8,0
li $a0,30
move $a1,$s1
li $a2,3
#desenhar p2
desenharp2:
jal pintar
addi $a1,$a1,1
addi $t8,$t8,1
beq $t8,5,eliminarBordas
j desenharp2

eliminarBordas:
lw $ra,($sp)
addi $sp,$sp,4
jr $ra
###############

###############
bordas:
li $a0,0
li $a1,0
li $a2,1
addi $sp,$sp,-4
sw $ra,($sp)

loopBordas:
jal pintar
addi $a0,$a0,1
beq $a0,32,bordaInferior
j loopBordas

bordaInferior:
li $a2,1
li $a0,0
li $a1,31

loopBordas2:
jal pintar
addi $a0,$a0,1
beq $a0,32,fimBordas
j loopBordas2

fimBordas:
lw $ra,($sp)
addi $sp,$sp,4
jr $ra
###############

###############
reset:
li $a0,0
li $a1,0
li $a2,0
addi $sp,$sp,-4
sw $ra,($sp)
loopReset:
jal pintar
addi $a0,$a0,1
beq $a0,32,incrementaY
j loopReset

incrementaY:
li $a0,0
addi $a1,$a1,1
beq $a1,32,fimReset
j loopReset

fimReset:
lw $ra,($sp)
addi $sp,$sp,4
jr $ra
###############

###############
pintar: # a0 = x, a1 = y, a2 = cor (0 = preto, 1 = marrom, 2 = vermelho, 3 = azul)

li $t7,0x10010000 
li $t6, 32 #numero de pixeis linha       
mult $a1, $t6          
mflo $t6
add $t6, $t6, $a0       
li $t5, 4
mult $t6, $t5           
mflo $t6
add $t7, $t7, $t6

mult $a2,$t5
mflo $t5
la $t4,vetor
add $t5,$t4,$t5
lw $t5,($t5)
sw $t5, 0($t7)
jr $ra                    
###############
# $s2 - x bola
player2pontua:
bne $s2,0,devolve
lw $t0,pontosP2
addi $t0,$t0,1
sw $t0,pontosP2

li $v0,55
la $a0,p2Pontua
li $a1,1
syscall
j imprimirPlacar
###############
# $s2 - x bola
player1pontua:
bne $s2,31,devolve
lw $t0,pontosP1
addi $t0,$t0,1
sw $t0,pontosP1

li $v0,55
la $a0,p1Pontua
li $a1,1
syscall
j imprimirPlacar
###############
imprimirPlacar:
li $v0,4
la $a0,placar
syscall

lw $a0,pontosP1
li $v0,1
syscall

li $v0,4
la $a0,placarX
syscall

li $v0,1
lw $a0,pontosP2
syscall

beq $a0,5,p2
lw $a0,pontosP1
beq $a0,5,p1

li $v0,55
la $a0,continuar
li $a1,1
syscall

j resetBola

p1:
li $v0,55
la $a0,vitoriaP1
li $a1,1
syscall
j fimPartida
p2:
li $v0,55
la $a0,vitoriaP2
li $a1,1
syscall

fimPartida:
li $v0,55
la $a0,fim
li $a1,1

li $a0,0
sw $a0,pontosP1
sw $a0,pontosP2

j menu
