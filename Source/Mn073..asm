# chuong trinh nhan 2 so nguyen co dau 32 bit chap nhan sai so khi ket qua qua 64 bit
.data
readInts: .space 8
fileName: .asciiz "INT2.BIN"
fdescr: .word 0 
file_error: .asciiz "file error"
multiplicand: .word 0
multiplier: .word 0
operatorX: .asciiz "x"
operatorEqual: .asciiz "="
result: .word 0
.text
main:	
	# dia chi file can doc
	la $a0,fileName
	# doc file
	jal readFile 
	
	#input cho ham multiplication
	lw $a0, readInts	# so nguyen thu 1
	lw $a1, readInts+4	# so nguyen thu 2
	
	# luu vao bo nho
	sw $a0, multiplicand
	sw $a1, multiplier
	# nhan 2 so nguyen 
	jal multiplication
	# luu vao bo nho
	sw $v0, result
	#in so thu 1 
	lw $a0, multiplicand
	jal print_integer
	#?n dau nhan
	la $a0, operatorX
	jal print_string
	#in so thu 2 
	lw $a0, multiplier
	jal print_integer
	#?n dau bang
	la $a0, operatorEqual
	jal print_string
	# in ket qua
	lw $a0, result
	addi $v0, $zero, 1
	syscall
	j exit

#ham nhan 2 so 32 bit co dau
#input: a0, a1 la 2 so nguyen can nhan
#ouput: v0 la ket qua cua phep nhan
multiplication:
	#luu dau cua 2 so nguyen
    sra $t2, $a0, 31    # t2 = dau cua so thu 1, 0 la duong, -1 la am
    sra $t3, $a1, 31    # t3 = dau cua so thu 2, 0 la duong, -1 la am

    # lay gia tri tuyet doi 
    xor $a0, $a0, $t2   # dao dau neu am
    sub $a0, $a0, $t2   # tru cho -1 neu am
    xor $a1, $a1, $t3   # dao dau neu am
    sub $a1, $a1, $t3   # tru cho -1 neu am

    # khoi tao ket qua
    addi $t4,$zero, 0           # t4 = luu ket qua 32 bit thap
    addi $t9, $zero, 0		# t9 = luu ket qua 32 bit cao
    addi $t5,$zero, 32          # t5 = so lan lap
multiply_loop:
    beqz $a1, end_loop  # neu multiplier  = 0 thi ket thuc
    andi $t6, $a1, 1    # lay bit cuoi 
    beqz $t6, skip_add  # neu = 0  bo qua
    add $t4, $t4, $a0   # cong vao ket qua neu  = 1
     # X? lý ph?n cao c?a k?t qu? n?u có tràn bit
  	sltu $t8, $t4, $a0   # Ki?m tra tràn bit
    addu $t9, $t9, $t8   # N?u có tràn bit, thêm 1 vào ph?n cao c?a k?t qu?
skip_add:
    srl $a1, $a1, 1     # dich phai multiplier	
    sll $a0, $a0, 1     # dich trai multiplicand
    sub $t5, $t5, 1     # giam so lan lap
    bnez $t5, multiply_loop # tiep tuc neu so lan lap chua bang 0
end_loop:
    # tinh toan dau cho ket qua
    xor $t7, $t2, $t3   # neu dau khac nhau, thi ket qua la am
    xor $t4, $t4, $t7   # dao dau neu can
    sub $t4, $t4, $t7   # tru cho -1 neu am
    # dua ket qua ra output
    add $v0, $zero, $t4
jr $ra
# ham mo file va doc du lieu
#input: a0 = dia chi file can doc
#output: none
readFile:
	addi $v0, $zero, 13
	addi $a1, $zero, 0 # che do doc file
	syscall
	bgez $v0, success
error:  #mo file bi loi
	addi $v0, $zero,4
	la $a0, file_error
	syscall
	j exit
success: sw $v0,fdescr #luu file descriptor 

	# doc file
	addi $v0,$zero, 14            # syscall doc file
	lw $a0, fdescr	
    	la $a1, readInts             # dia chi cua noi luu du lieu
    	addi $a2,$zero, 8                    # doc 8 bytes
   	syscall
 	# dong file
 	lw $a0,fdescr
 	addi $v0,$zero,16
 	syscall
jr $ra	
#ham in so nguyen
#input: a0 = so nguyen can in
#output: ket qua ra man hinh
print_integer:
	addi $v0, $zero, 1
	syscall
	jr $ra
# ham in string
# input: a0 = dia chi chuoi can in
# ouput: ket qua ra man hinh
print_string:
	addi $v0, $zero, 4
	syscall
	jr $ra
#exit	
exit: 
	addi $v0, $zero, 10
	syscall
	                    
