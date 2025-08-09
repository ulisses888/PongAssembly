# endereco base 0x10010000

.data
	bitmap: .space 4096
	tamanho: .word 4
	vetor: .word 0xFF000000, 0xff873800, 0xff0022, 0x0400ff, 0xFFFFFFFF #Preto,Marrom,Vermelho,Azul e Branco
.text
li $t0,0x10010000 #endereco base
# Endereços MMIO
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
###############
atualizarBola:

addi $sp,$sp,-4
sw $ra,($sp)

jal colisaoEsquerda
jal colisaoDireita

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
jr $ra
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
jr $ra
devolve:
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
