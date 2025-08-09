# endereco base 0x10010000

.data
	bitmap: .space 4096 
	tamanho: .word 4
	vetor: .word 0xFF000000, 0xff873800, 0xff0022, 0x0400ff #Preto,Marrom,Vermelho e Azul
	
.text
li $t0,0x10010000 #endereco base

#jal reset
jal reset
jal bordas
jal raquetes







li $v0,10
syscall

##############
raquetes: #13-17
li $a0,1
li $a1,13
li $a2 2
jal pintar
li $a1,14
jal pintar
li $a1,15
jal pintar
li $a1,16
jal pintar
li $a1,17
jal pintar

li $a0,30
li $a1,13
li $a2 3
jal pintar
li $a1,14
jal pintar
li $a1,15
jal pintar
li $a1,16
jal pintar
li $a1,17
jal pintar




##############

##############
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
#############

#############
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

###########
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
############
