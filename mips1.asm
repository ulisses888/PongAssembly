# endereco base 0x10010000
li $t0,0x10010000
li $a2,1










li $v0,10
syscall

pintar: #a0 = x, a1 = y a2 = cor (0,preto,1 branco)
move $t7,$t0 # pega o endereco base
#calcular o y
li $t6,2048
mult $a1,$t6
mflo $t6
add $t7,$t7,$t6 #t7 recebe o y
li $t6, 4
mult $t6,$a0
mflo $t6
add $t7,$t7,$t6 # + endereco x
beqz $a2,preto
branco:
li $t5,0xFFFFFFFF
sw $t5,($t7)
jr $ra
preto:
li $t5, 0xFF000000
sw $t5,($t7)
jr $ra
