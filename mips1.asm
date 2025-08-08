# endereco base 0x10010000

.data
	bitmap: .space 4096 
	tamanho: .word 4
	vetor: .word 0xFF000000, 0xFFFFFFFF, 0xff0022, 0x0400ff #Preto,Branco,Vermelho e Azul
	
.text

jal reset










li $v0,10
syscall

bordas:





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

pintar: # a0 = x, a1 = y, a2 = cor (0 = preto, 1 = branco)
    move $t7, $t0           # endereço base do bitmap display em $t7

    li $t6, 32             
    mult $a1, $t6          
    mflo $t6
    add $t6, $t6, $a0       

    li $t5, 4
    mult $t6, $t5           
    mflo $t6

    add $t7, $t7, $t6       

    beqz $a2, preto         # se a2 == 0, cor preta
branco:
    li $t5, 0xFFFFFFFF      # branco
    sw $t5, 0($t7)
    jr $ra
preto:
    li $t5, 0xFF000000      # preto
    sw $t5, 0($t7)
    jr $ra

