ori $16, $0, 1
ori $17, $0, 3
ori $8, $0, 1
ori $12, $0, 0xabab
lui $13, 10

# 插入的SRAV测试 (测试负数的算术右移)
ori $t0, $0, 0xF0000000    # 加载测试值 (负数)
ori $t1, $0, 4             # 移位量 = 4
srav $t2, $t0, $t1         # $t2 = 0xFF000000 (算术右移4位)

start:
    addu $4, $0, $16
    addu $5, $0, $8
    jal newadd
    addu $16, $0, $2
    subu $17, $17, $8
    beq $16, $17, start

ori $8, $0, 4
addiu $24, $0, 0x7fffffff
addiu $9, $24, 3
addiu $10, $24, 5
addu $0, $0, $0

# 第二个SRAV测试 (测试正数的算术右移)
ori $t3, $0, 0x12345678    # 加载测试值 (正数)
ori $t4, $0, 8             # 移位量 = 8
srav $t5, $t3, $t4         # $t5 = 0x00123456 (算术右移8位)

start2:
    sw $9, 0($8)
    lw $14, 0($8)
    sw $10, 4($8)
    lw $15, 4($8)
    sw $4, -4($8)
    lw $18, -4($8)
    addu $4, $0, $8
    addu $5, $0, $9
    jal newadd
    slt $25, $10, $8
    beq $25, $0, end2
    slt $20, $12, $4
    beq $20, $0, end1
    lui $12, 65535

end1:
    ori $0, $0, 1
    lui $19, 0xefef
    addiu $3, $0, 0xababcdcd

start3:
    addiu $4, $3, 2
    addi $23, $3, 5
    jal newadd
    addu $8, $0, $2
    addu $4, $0, $8
    addu $5, $0, $9
    jal newadd
    addu $9, $0, $2
    addu $9, $8, $0
    lui $10, 0x69
    beq $8, $9, start4
    beq $0, $0, start3

start4:
    j end

newadd:
    addu $2, $4, $5
    addi $0, $12, 0x1234
    jr $31

end2:
    addi $26, $0, 0x5678

end:
    # 第三个SRAV测试 (测试最大移位量31)
    ori $t6, $0, 0x80000000  # 最小负数
    ori $t7, $0, 31          # 最大移位量
    srav $t8, $t6, $t7       # $t8 = 0xFFFFFFFF (算术右移31位)