
# Purpose: Print a formatted score report using reusable leaf procedures sep and stars.

.data
title:    .asciiz "SCORE REPORT\n"
endMsg:   .asciiz "END\n"
line:     .asciiz "----------\n"
starLine: .asciiz "**********\n"

.text
.globl main
main:
    jal  stars              # Print top star border
    li   $v0, 4
    la   $a0, title         # Print "SCORE REPORT"
    syscall
    jal  sep                # Print dashed separator
    li   $v0, 4
    la   $a0, endMsg        # Print "END"
    syscall
    jal  stars              # Print bottom star border
    li   $v0, 10            # Exit
    syscall

# sep(): prints a dashed separator line
sep:
    li   $v0, 4
    la   $a0, line
    syscall
    jr   $ra

# stars(): prints a star separator line
stars:
    li   $v0, 4
    la   $a0, starLine
    syscall
    jr   $ra