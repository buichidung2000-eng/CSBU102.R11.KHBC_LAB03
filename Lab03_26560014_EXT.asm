# Purpose: Return both minimum ($v0) and maximum ($v1) of an array from a single call.

.data
classA: .word 72, 55, 90, 48, 63, 85, 39, 77, 60, 94
classB: .word 45, 81, 66, 50, 92, 38, 70, 59
minA:   .asciiz "Class A min: "
maxA:   .asciiz "Class A max: "
minB:   .asciiz "Class B min: "
maxB:   .asciiz "Class B max: "
nl:     .asciiz "\n"

.text
.globl main
main:
    # --- Class A ---
    la   $a0, classA
    addi $a1, $zero, 10
    jal  min_max
    add  $s0, $v0, $zero        # Save min in $s0
    add  $s1, $v1, $zero        # Save max in $s1

    la   $a0, minA
    add  $a1, $s0, $zero
    jal  show
    la   $a0, maxA
    add  $a1, $s1, $zero
    jal  show

    # --- Class B ---
    la   $a0, classB
    addi $a1, $zero, 8
    jal  min_max
    add  $s0, $v0, $zero
    add  $s1, $v1, $zero

    la   $a0, minB
    add  $a1, $s0, $zero
    jal  show
    la   $a0, maxB
    add  $a1, $s1, $zero
    jal  show

    li   $v0, 10
    syscall

# min_max(addr = $a0, n = $a1): returns min in $v0 and max in $v1
min_max:
    lw   $v0, 0($a0)            # min = array[0]
    lw   $v1, 0($a0)            # max = array[0]
    addi $t0, $zero, 1          # i = 1
mm_loop:
    slt  $t1, $t0, $a1          # $t1 = 1 if i < n
    beq  $t1, $zero, mm_end
    sll  $t2, $t0, 2            # $t2 = 4 * i
    add  $t2, $t2, $a0          # address of array[i]
    lw   $t3, 0($t2)            # $t3 = array[i]

    slt  $t4, $t3, $v0          # is array[i] < min?
    beq  $t4, $zero, check_max
    add  $v0, $t3, $zero        # update min
check_max:
    slt  $t4, $v1, $t3          # is max < array[i]?
    beq  $t4, $zero, mm_next
    add  $v1, $t3, $zero        # update max
mm_next:
    addi $t0, $t0, 1
    j    mm_loop
mm_end:
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