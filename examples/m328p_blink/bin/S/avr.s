	.text
	.file	"avr.ll"
	.weak	memeq                           ; -- Begin function memeq
	.p2align	1
	.type	memeq,@function
memeq:                                  ; @memeq
; %bb.0:
	push	r2
	push	r3
	push	r4
	push	r5
	push	r6
	push	r7
	push	r8
	push	r9
	push	r10
	push	r11
	push	r12
	push	r13
	push	r14
	push	r15
	push	r16
	push	r17
	push	r28
	push	r29
	in	r28, 61
	in	r29, 62
	sbiw	r28, 14
	in	r0, 63
	cli
	out	62, r29
	out	63, r0
	out	61, r28
	std	Y+5, r22                        ; 2-byte Folded Spill
	std	Y+6, r23                        ; 2-byte Folded Spill
	std	Y+3, r24                        ; 2-byte Folded Spill
	std	Y+4, r25                        ; 2-byte Folded Spill
	ldi	r24, 0
	ldi	r25, 0
	std	Y+13, r24
	std	Y+14, r25
	std	Y+11, r24
	std	Y+12, r25
	std	Y+9, r24
	std	Y+10, r25
	std	Y+7, r24
	std	Y+8, r25
	mov	r30, r20
	mov	r31, r21
	mov	r31, r30
	swap	r31
	andi	r31, 240
	clr	r30
	lsl	r31
	mov	r24, r18
	mov	r25, r19
	lsr	r25
	ror	r24
	lsr	r25
	ror	r24
	lsr	r25
	ror	r24
	or	r24, r30
	or	r25, r31
	mov	r19, r18
	swap	r19
	andi	r19, 240
	clr	r18
	lsl	r19
	mov	r12, r16
	mov	r13, r17
	lsr	r13
	ror	r12
	lsr	r13
	ror	r12
	lsr	r13
	ror	r12
	or	r12, r18
	or	r13, r19
	mov	r17, r16
	swap	r17
	andi	r17, 240
	clr	r16
	lsl	r17
	std	Y+1, r14                        ; 2-byte Folded Spill
	std	Y+2, r15                        ; 2-byte Folded Spill
	mov	r18, r14
	mov	r19, r15
	lsr	r19
	ror	r18
	lsr	r19
	ror	r18
	lsr	r19
	ror	r18
	or	r18, r16
	or	r19, r17
	lsr	r21
	ror	r20
	lsr	r21
	ror	r20
	lsr	r21
	ror	r20
.LBB0_1:                                ; %again_1
                                        ; =>This Inner Loop Header: Depth=1
	ldd	r30, Y+7
	ldd	r31, Y+8
	ldd	r10, Y+9
	ldd	r11, Y+10
	ldd	r8, Y+11
	ldd	r9, Y+12
	ldd	r6, Y+13
	ldd	r7, Y+14
	ldi	r17, 1
	cp	r30, r18
	cpc	r31, r19
	cpc	r10, r12
	cpc	r11, r13
	cpc	r8, r24
	cpc	r9, r25
	cpc	r6, r20
	cpc	r7, r21
	brsh	.LBB0_3
; %bb.2:                                ; %again_1
                                        ;   in Loop: Header=BB0_1 Depth=1
	mov	r17, r1
.LBB0_3:                                ; %again_1
                                        ;   in Loop: Header=BB0_1 Depth=1
	andi	r17, 1
	cpi	r17, 0
	breq	.LBB0_4
	rjmp	.LBB0_8
.LBB0_4:                                ; %body_1
                                        ;   in Loop: Header=BB0_1 Depth=1
	ldd	r26, Y+7
	ldd	r27, Y+8
	lsl	r26
	rol	r27
	lsl	r26
	rol	r27
	lsl	r26
	rol	r27
	ldd	r16, Y+5                        ; 2-byte Folded Reload
	ldd	r17, Y+6                        ; 2-byte Folded Reload
	add	r16, r26
	adc	r17, r27
	mov	r30, r16
	mov	r31, r17
	ld	r10, Z
	ldd	r11, Z+1
	ldd	r22, Y+3                        ; 2-byte Folded Reload
	ldd	r23, Y+4                        ; 2-byte Folded Reload
	add	r26, r22
	adc	r27, r23
	mov	r30, r26
	mov	r31, r27
	ld	r8, Z
	ldd	r9, Z+1
	mov	r22, r30
	mov	r23, r31
	mov	r30, r16
	mov	r31, r17
	ldd	r6, Z+2
	ldd	r7, Z+3
	mov	r30, r22
	mov	r31, r23
	ldd	r4, Z+2
	ldd	r5, Z+3
	mov	r30, r16
	mov	r31, r17
	ldd	r2, Z+4
	ldd	r3, Z+5
	mov	r30, r22
	mov	r31, r23
	ldd	r26, Z+4
	ldd	r27, Z+5
	mov	r30, r16
	mov	r31, r17
	ldd	r14, Z+6
	ldd	r15, Z+7
	mov	r30, r22
	mov	r31, r23
	ldd	r22, Z+6
	ldd	r23, Z+7
	ldi	r17, 1
	cp	r8, r10
	cpc	r9, r11
	cpc	r4, r6
	cpc	r5, r7
	cpc	r26, r2
	cpc	r27, r3
	cpc	r22, r14
	cpc	r23, r15
	breq	.LBB0_6
; %bb.5:                                ; %body_1
                                        ;   in Loop: Header=BB0_1 Depth=1
	mov	r17, r1
.LBB0_6:                                ; %body_1
                                        ;   in Loop: Header=BB0_1 Depth=1
	andi	r17, 1
	cpi	r17, 0
	brne	.LBB0_7
	rjmp	.LBB0_14
.LBB0_7:                                ; %endif_0
                                        ;   in Loop: Header=BB0_1 Depth=1
	ldd	r22, Y+7
	ldd	r23, Y+8
	ldd	r30, Y+9
	ldd	r31, Y+10
	ldd	r26, Y+11
	ldd	r27, Y+12
	ldd	r16, Y+13
	ldd	r17, Y+14
	subi	r22, 255
	sbci	r23, 255
	sbci	r30, 255
	sbci	r31, 255
	sbci	r26, 255
	sbci	r27, 255
	sbci	r16, 255
	sbci	r17, 255
	std	Y+11, r26
	std	Y+12, r27
	std	Y+13, r16
	std	Y+14, r17
	std	Y+7, r22
	std	Y+8, r23
	std	Y+9, r30
	std	Y+10, r31
	rjmp	.LBB0_1
.LBB0_8:                                ; %break_1
	ldi	r24, 0
	ldi	r25, 0
	mov	r18, r24
	mov	r19, r25
	std	Y+11, r18
	std	Y+12, r19
	std	Y+13, r18
	std	Y+14, r19
	std	Y+9, r18
	std	Y+10, r19
	ldd	r24, Y+7
	ldd	r25, Y+8
	std	Y+7, r18
	std	Y+8, r19
	lsl	r24
	rol	r25
	lsl	r24
	rol	r25
	lsl	r24
	rol	r25
	ldd	r18, Y+5                        ; 2-byte Folded Reload
	ldd	r19, Y+6                        ; 2-byte Folded Reload
	add	r18, r24
	adc	r19, r25
	std	Y+5, r18                        ; 2-byte Folded Spill
	std	Y+6, r19                        ; 2-byte Folded Spill
	ldd	r18, Y+3                        ; 2-byte Folded Reload
	ldd	r19, Y+4                        ; 2-byte Folded Reload
	add	r18, r24
	adc	r19, r25
	std	Y+3, r18                        ; 2-byte Folded Spill
	std	Y+4, r19                        ; 2-byte Folded Spill
	ldd	r16, Y+1                        ; 2-byte Folded Reload
	ldd	r17, Y+2                        ; 2-byte Folded Reload
	andi	r16, 7
	andi	r17, 0
.LBB0_9:                                ; %again_2
                                        ; =>This Inner Loop Header: Depth=1
	ldd	r24, Y+7
	ldd	r25, Y+8
	ldd	r20, Y+9
	ldd	r21, Y+10
	ldd	r22, Y+11
	ldd	r23, Y+12
	ldd	r30, Y+13
	ldd	r31, Y+14
	ldi	r18, 1
	cp	r24, r16
	cpc	r25, r17
	ldi	r24, 0
	ldi	r25, 0
	cpc	r20, r24
	cpc	r21, r25
	cpc	r22, r24
	cpc	r23, r25
	cpc	r30, r24
	cpc	r31, r25
	brsh	.LBB0_11
; %bb.10:                               ; %again_2
                                        ;   in Loop: Header=BB0_9 Depth=1
	mov	r18, r1
.LBB0_11:                               ; %again_2
                                        ;   in Loop: Header=BB0_9 Depth=1
	andi	r18, 1
	cpi	r18, 0
	breq	.LBB0_12
	rjmp	.LBB0_15
.LBB0_12:                               ; %body_2
                                        ;   in Loop: Header=BB0_9 Depth=1
	ldd	r30, Y+7
	ldd	r31, Y+8
	ldd	r26, Y+5                        ; 2-byte Folded Reload
	ldd	r27, Y+6                        ; 2-byte Folded Reload
	add	r26, r30
	adc	r27, r31
	ld	r24, X
	ldd	r18, Y+3                        ; 2-byte Folded Reload
	ldd	r19, Y+4                        ; 2-byte Folded Reload
	add	r30, r18
	adc	r31, r19
	ld	r25, Z
	cp	r25, r24
	brne	.LBB0_14
; %bb.13:                               ; %endif_1
                                        ;   in Loop: Header=BB0_9 Depth=1
	ldd	r24, Y+7
	ldd	r25, Y+8
	ldd	r18, Y+9
	ldd	r19, Y+10
	ldd	r20, Y+11
	ldd	r21, Y+12
	ldd	r22, Y+13
	ldd	r23, Y+14
	subi	r24, 255
	sbci	r25, 255
	sbci	r18, 255
	sbci	r19, 255
	sbci	r20, 255
	sbci	r21, 255
	sbci	r22, 255
	sbci	r23, 255
	std	Y+11, r20
	std	Y+12, r21
	std	Y+13, r22
	std	Y+14, r23
	std	Y+7, r24
	std	Y+8, r25
	std	Y+9, r18
	std	Y+10, r19
	rjmp	.LBB0_9
.LBB0_14:                               ; %then_0
	mov	r24, r1
	rjmp	.LBB0_16
.LBB0_15:                               ; %break_2
	ldi	r24, 1
.LBB0_16:                               ; %then_0
	adiw	r28, 14
	in	r0, 63
	cli
	out	62, r29
	out	63, r0
	out	61, r28
	pop	r29
	pop	r28
	pop	r17
	pop	r16
	pop	r15
	pop	r14
	pop	r13
	pop	r12
	pop	r11
	pop	r10
	pop	r9
	pop	r8
	pop	r7
	pop	r6
	pop	r5
	pop	r4
	pop	r3
	pop	r2
	ret
.Lfunc_end0:
	.size	memeq, .Lfunc_end0-memeq
                                        ; -- End function
	; Declaring this symbol tells the CRT that it should
	;copy all variables from program memory to RAM on startup
	.globl	__do_copy_data
	; Declaring this symbol tells the CRT that it should
	;clear the zeroed data section on startup
	.globl	__do_clear_bss
