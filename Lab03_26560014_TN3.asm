# Purpose: Gradebook library computing total scores and pass counts (M = 71) for Class A and Class B.

.data
classA: .word 72, 55, 90, 48, 63, 85, 39, 77, 60, 94
classB: .word 45, 81, 66, 50, 92, 38, 70, 59
msgA:   .asciiz "Class A total: "
msgB:   .asciiz "Class B total: "
passA:  .asciiz "Class A passed: "
passB:  .asciiz "Class B passed: "
nl:     .asciiz "\n"

.text
.globl main
main:
    # --- Totals ---
    la   $a0, classA
    addi $a1, $zero, 10
    jal  sum_array
    la   $a0, msgA
    add  $a1, $v0, $zero
    jal  show

    la   $a0, classB
    addi $a1, $zero, 8
    jal  sum_array
    la   $a0, msgB
    add  $a1, $v0, $zero
    jal  show

    # --- Pass Counts (Pass mark M = 71 for D = 4) ---
    la   $a0, classA
    addi $a1, $zero, 10
    addi $a2, $zero, 71         # mark M = 71
    jal  count_pass
    la   $a0, passA
    add  $a1, $v0, $zero
    jal  show

    la   $a0, classB
    addi $a1, $zero, 8
    addi $a2, $zero, 71         # mark M = 71
    jal  count_pass
    la   $a0, passB
    add  $a1, $v0, $zero
    jal  show

    li   $v0, 10
    syscall

# sum_array(addr = $a0, n = $a1): returns the sum of n words in $v0
sum_array:
    addi $v0, $zero, 0          # sum = 0
    addi $t0, $zero, 0          # i = 0
sum_loop:
    slt  $t1, $t0, $a1          # $t1 = 1 if i < n
    beq  $t1, $zero, sum_end
    sll  $t2, $t0, 2            # $t2 = 4 * i
    add  $t2, $t2, $a0          # $t2 = address of element i
    lw   $t3, 0($t2)
    add  $v0, $v0, $t3          # sum = sum + element i
    addi $t0, $t0, 1            # i = i + 1
    j    sum_loop
sum_end:
    jr   $ra

# count_pass(addr = $a0, n = $a1, mark = $a2): returns count of words >= mark in $v0
count_pass:
    addi $v0, $zero, 0          # count = 0
    addi $t0, $zero, 0          # i = 0
cp_loop:
    slt  $t1, $t0, $a1          # $t1 = 1 if i < n
    beq  $t1, $zero, cp_end     # if i >= n, exit loop
    sll  $t2, $t0, 2            # $t2 = 4 * i
    add  $t2, $t2, $a0          # $t2 = address of element i
    lw   $t3, 0($t2)            # $t3 = array[i]
    slt  $t4, $t3, $a2          # $t4 = 1 if array[i] < mark
    bne  $t4, $zero, cp_next    # if array[i] < mark, skip increment
    addi $v0, $v0, 1            # count = count + 1
cp_next:
    addi $t0, $t0, 1            # i = i + 1
    j    cp_loop
cp_end:
    jr   $ra

# show(msg = $a0, value = $a1): prints msg, value and a new line
show:
    li   $v0, 4
    syscall
    li   $v0, 1
    add  $a0, $a1, $zero
    syscall
    li   $v0, 4
    la   $a0, nl
    syscall
    jr   $ra