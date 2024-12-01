	.text
.set __tmp_reg__, 0
.set __zero_reg__, 1
.set __SREG__, 63
.set __SP_H__, 62
.set __SP_L__, 61
	.file	"delay.ll"
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
	sbiw	r28, 16
	in	r0, 63
	cli
	out	62, r29
	out	63, r0
	out	61, r28
	mov	r26, r20
	mov	r27, r21
	mov	r20, r16
	mov	r21, r17
	std	Y+8, r23                        ; 2-byte Folded Spill
	std	Y+7, r22                        ; 2-byte Folded Spill
	std	Y+6, r25                        ; 2-byte Folded Spill
	std	Y+5, r24                        ; 2-byte Folded Spill
	ldi	r24, 0
	ldi	r25, 0
	std	Y+16, r25
	std	Y+15, r24
	std	Y+14, r25
	std	Y+13, r24
	std	Y+12, r25
	std	Y+11, r24
	std	Y+10, r25
	std	Y+9, r24
	mov	r31, r18
	swap	r31
	andi	r31, 240
	lsl	r31
	mov	r30, r1
	mov	r13, r1
	mov	r12, r1
	lsr	r21
	ror	r20
	mov	r17, r15
	ror	r17
	std	Y+2, r15                        ; 2-byte Folded Spill
	std	Y+1, r14                        ; 2-byte Folded Spill
	mov	r16, r14
	ror	r16
	lsr	r21
	ror	r20
	ror	r17
	ror	r16
	lsr	r21
	ror	r20
	ror	r17
	ror	r16
	or	r20, r30
	or	r21, r31
	or	r16, r12
	or	r17, r13
	lsr	r27
	ror	r26
	ror	r19
	ror	r18
	lsr	r27
	ror	r26
	ror	r19
	ror	r18
	lsr	r27
	ror	r26
	std	Y+4, r27                        ; 2-byte Folded Spill
	std	Y+3, r26                        ; 2-byte Folded Spill
	ror	r19
	ror	r18
.LBB0_1:                                ; %again_1
                                        ; =>This Inner Loop Header: Depth=1
	ldd	r12, Y+9
	ldd	r13, Y+10
	ldd	r10, Y+11
	ldd	r11, Y+12
	ldd	r8, Y+13
	ldd	r9, Y+14
	ldd	r6, Y+15
	ldd	r7, Y+16
	ldi	r30, 1
	cp	r12, r16
	cpc	r13, r17
	cpc	r10, r20
	cpc	r11, r21
	cpc	r8, r18
	cpc	r9, r19
	ldd	r24, Y+3                        ; 2-byte Folded Reload
	ldd	r25, Y+4                        ; 2-byte Folded Reload
	cpc	r6, r24
	cpc	r7, r25
	brsh	.LBB0_3
; %bb.2:                                ; %again_1
                                        ;   in Loop: Header=BB0_1 Depth=1
	mov	r30, r1
.LBB0_3:                                ; %again_1
                                        ;   in Loop: Header=BB0_1 Depth=1
	andi	r30, 1
	cpi	r30, 0
	breq	.LBB0_4
	rjmp	.LBB0_8
.LBB0_4:                                ; %body_1
                                        ;   in Loop: Header=BB0_1 Depth=1
	ldd	r26, Y+9
	ldd	r27, Y+10
	lsl	r26
	rol	r27
	lsl	r26
	rol	r27
	lsl	r26
	rol	r27
	ldd	r12, Y+7                        ; 2-byte Folded Reload
	ldd	r13, Y+8                        ; 2-byte Folded Reload
	add	r12, r26
	adc	r13, r27
	mov	r22, r12
	mov	r23, r13
	mov	r30, r22
	mov	r31, r23
	ld	r12, Z
	ldd	r13, Z+1
	ldd	r24, Y+5                        ; 2-byte Folded Reload
	ldd	r25, Y+6                        ; 2-byte Folded Reload
	add	r26, r24
	adc	r27, r25
	mov	r30, r26
	mov	r31, r27
	ld	r10, Z
	ldd	r11, Z+1
	mov	r24, r30
	mov	r25, r31
	mov	r30, r22
	mov	r31, r23
	ldd	r8, Z+2
	ldd	r9, Z+3
	mov	r30, r24
	mov	r31, r25
	ldd	r6, Z+2
	ldd	r7, Z+3
	mov	r30, r22
	mov	r31, r23
	ldd	r4, Z+4
	ldd	r5, Z+5
	mov	r30, r24
	mov	r31, r25
	ldd	r2, Z+4
	ldd	r3, Z+5
	mov	r30, r22
	mov	r31, r23
	ldd	r26, Z+6
	ldd	r27, Z+7
	mov	r30, r24
	mov	r31, r25
	ldd	r14, Z+6
	ldd	r15, Z+7
	ldi	r30, 1
	cp	r10, r12
	cpc	r11, r13
	cpc	r6, r8
	cpc	r7, r9
	cpc	r2, r4
	cpc	r3, r5
	cpc	r14, r26
	cpc	r15, r27
	breq	.LBB0_6
; %bb.5:                                ; %body_1
                                        ;   in Loop: Header=BB0_1 Depth=1
	mov	r30, r1
.LBB0_6:                                ; %body_1
                                        ;   in Loop: Header=BB0_1 Depth=1
	andi	r30, 1
	cpi	r30, 0
	brne	.LBB0_7
	rjmp	.LBB0_14
.LBB0_7:                                ; %endif_0
                                        ;   in Loop: Header=BB0_1 Depth=1
	ldd	r30, Y+9
	ldd	r31, Y+10
	ldd	r26, Y+11
	ldd	r27, Y+12
	ldd	r22, Y+13
	ldd	r23, Y+14
	ldd	r24, Y+15
	ldd	r25, Y+16
	subi	r30, 255
	sbci	r31, 255
	sbci	r26, 255
	sbci	r27, 255
	sbci	r22, 255
	sbci	r23, 255
	sbci	r24, 255
	sbci	r25, 255
	std	Y+14, r23
	std	Y+13, r22
	std	Y+16, r25
	std	Y+15, r24
	std	Y+10, r31
	std	Y+9, r30
	std	Y+12, r27
	std	Y+11, r26
	rjmp	.LBB0_1
.LBB0_8:                                ; %break_1
	ldi	r24, 0
	ldi	r25, 0
	mov	r18, r24
	mov	r19, r25
	std	Y+14, r19
	std	Y+13, r18
	std	Y+16, r19
	std	Y+15, r18
	std	Y+12, r19
	std	Y+11, r18
	ldd	r24, Y+9
	ldd	r25, Y+10
	std	Y+10, r19
	std	Y+9, r18
	lsl	r24
	rol	r25
	lsl	r24
	rol	r25
	lsl	r24
	rol	r25
	ldd	r18, Y+7                        ; 2-byte Folded Reload
	ldd	r19, Y+8                        ; 2-byte Folded Reload
	add	r18, r24
	adc	r19, r25
	std	Y+8, r19                        ; 2-byte Folded Spill
	std	Y+7, r18                        ; 2-byte Folded Spill
	ldd	r18, Y+5                        ; 2-byte Folded Reload
	ldd	r19, Y+6                        ; 2-byte Folded Reload
	add	r18, r24
	adc	r19, r25
	std	Y+6, r19                        ; 2-byte Folded Spill
	std	Y+5, r18                        ; 2-byte Folded Spill
	ldd	r16, Y+1                        ; 2-byte Folded Reload
	ldd	r17, Y+2                        ; 2-byte Folded Reload
	andi	r16, 7
	andi	r17, 0
.LBB0_9:                                ; %again_2
                                        ; =>This Inner Loop Header: Depth=1
	ldd	r24, Y+9
	ldd	r25, Y+10
	ldd	r20, Y+11
	ldd	r21, Y+12
	ldd	r22, Y+13
	ldd	r23, Y+14
	ldd	r30, Y+15
	ldd	r31, Y+16
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
	ldd	r30, Y+9
	ldd	r31, Y+10
	ldd	r26, Y+7                        ; 2-byte Folded Reload
	ldd	r27, Y+8                        ; 2-byte Folded Reload
	add	r26, r30
	adc	r27, r31
	ld	r24, X
	ldd	r18, Y+5                        ; 2-byte Folded Reload
	ldd	r19, Y+6                        ; 2-byte Folded Reload
	add	r30, r18
	adc	r31, r19
	ld	r25, Z
	cp	r25, r24
	brne	.LBB0_14
; %bb.13:                               ; %endif_1
                                        ;   in Loop: Header=BB0_9 Depth=1
	ldd	r24, Y+9
	ldd	r25, Y+10
	ldd	r18, Y+11
	ldd	r19, Y+12
	ldd	r20, Y+13
	ldd	r21, Y+14
	ldd	r22, Y+15
	ldd	r23, Y+16
	subi	r24, 255
	sbci	r25, 255
	sbci	r18, 255
	sbci	r19, 255
	sbci	r20, 255
	sbci	r21, 255
	sbci	r22, 255
	sbci	r23, 255
	std	Y+14, r21
	std	Y+13, r20
	std	Y+16, r23
	std	Y+15, r22
	std	Y+10, r25
	std	Y+9, r24
	std	Y+12, r19
	std	Y+11, r18
	rjmp	.LBB0_9
.LBB0_14:                               ; %then_0
	mov	r24, r1
	rjmp	.LBB0_16
.LBB0_15:                               ; %break_2
	ldi	r24, 1
.LBB0_16:                               ; %then_0
	adiw	r28, 16
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
	.globl	delay_ms                        ; -- Begin function delay_ms
	.p2align	1
	.type	delay_ms,@function
delay_ms:                               ; @delay_ms
; %bb.0:
	push	r28
	push	r29
	in	r28, 61
	in	r29, 62
	sbiw	r28, 4
	in	r0, 63
	cli
	out	62, r29
	out	63, r0
	out	61, r28
	std	Y+4, r25
	std	Y+3, r24
	std	Y+2, r23
	std	Y+1, r22
	ldi	r24, 0
	ldi	r25, 0
	rjmp	.LBB1_2
.LBB1_1:                                ; %break_2
                                        ;   in Loop: Header=BB1_2 Depth=1
	ldd	r18, Y+1
	ldd	r19, Y+2
	ldd	r20, Y+3
	ldd	r21, Y+4
	subi	r18, 1
	sbci	r19, 0
	sbci	r20, 0
	sbci	r21, 0
	std	Y+2, r19
	std	Y+1, r18
	std	Y+4, r21
	std	Y+3, r20
.LBB1_2:                                ; %again_1
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB1_6 Depth 2
	ldd	r20, Y+1
	ldd	r21, Y+2
	ldd	r22, Y+3
	ldd	r23, Y+4
	ldi	r18, 1
	cp	r20, r1
	cpc	r21, r1
	cpc	r22, r24
	cpc	r23, r25
	breq	.LBB1_4
; %bb.3:                                ; %again_1
                                        ;   in Loop: Header=BB1_2 Depth=1
	mov	r18, r1
.LBB1_4:                                ; %again_1
                                        ;   in Loop: Header=BB1_2 Depth=1
	andi	r18, 1
	cpi	r18, 0
	breq	.LBB1_5
	rjmp	.LBB1_10
.LBB1_5:                                ; %body_1
                                        ;   in Loop: Header=BB1_2 Depth=1
	sts	delayCounter+3, r25
	sts	delayCounter+2, r24
	sts	delayCounter+1, r25
	sts	delayCounter, r24
.LBB1_6:                                ; %again_2
                                        ;   Parent Loop BB1_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lds	r20, delayCounter
	lds	r21, delayCounter+1
	lds	r22, delayCounter+2
	lds	r23, delayCounter+3
	ldi	r18, 1
	cpi	r20, 124
	cpc	r21, r18
	cpc	r22, r24
	cpc	r23, r25
	brsh	.LBB1_8
; %bb.7:                                ; %again_2
                                        ;   in Loop: Header=BB1_6 Depth=2
	mov	r18, r1
.LBB1_8:                                ; %again_2
                                        ;   in Loop: Header=BB1_6 Depth=2
	andi	r18, 1
	cpi	r18, 0
	breq	.LBB1_9
	rjmp	.LBB1_1
.LBB1_9:                                ; %body_2
                                        ;   in Loop: Header=BB1_6 Depth=2
	lds	r18, delayCounter
	lds	r19, delayCounter+1
	lds	r20, delayCounter+2
	lds	r21, delayCounter+3
	subi	r18, 255
	sbci	r19, 255
	sbci	r20, 255
	sbci	r21, 255
	sts	delayCounter+1, r19
	sts	delayCounter, r18
	sts	delayCounter+3, r21
	sts	delayCounter+2, r20
	rjmp	.LBB1_6
.LBB1_10:                               ; %break_1
	adiw	r28, 4
	in	r0, 63
	cli
	out	62, r29
	out	63, r0
	out	61, r28
	pop	r29
	pop	r28
	ret
.Lfunc_end1:
	.size	delay_ms, .Lfunc_end1-delay_ms
                                        ; -- End function
	; Declaring this symbol tells the CRT that it should
	;clear the zeroed data section on startup
	.globl	__do_clear_bss
	.type	delayCounter,@object            ; @delayCounter
	.local	delayCounter
	.comm	delayCounter,4,1
