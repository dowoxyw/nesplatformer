;
; File generated by cc65 v 2.19 - Git 6ea1f8e
;
	.fopt		compiler,"cc65 v 2.19 - Git 6ea1f8e"
	.setcpu		"6502"
	.smart		on
	.autoimport	on
	.case		on
	.debuginfo	off
	.importzp	sp, sreg, regsave, regbank
	.importzp	tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
	.macpack	longbranch
	.forceimport	__STARTUP__
	.import		_pal_bg
	.import		_pal_spr
	.import		_ppu_wait_nmi
	.import		_ppu_off
	.import		_ppu_on_all
	.import		_oam_clear
	.import		_oam_meta_spr
	.import		_music_play
	.import		_pad_poll
	.import		_bank_spr
	.import		_vram_adr
	.import		_vram_put
	.import		_vram_write
	.import		_memcpy
	.import		_memfill
	.import		_get_pad_new
	.import		_get_frame_count
	.import		_set_scroll_x
	.export		_bankLevel
	.export		_bankBuffer
	.export		_banked_call
	.export		_bank_push
	.export		_bank_pop
	.import		_set_prg_8000
	.import		_get_prg_8000
	.import		_set_chr_mode_5
	.import		_set_mirroring
	.import		_set_irq_ptr
	.import		_is_irq_done
	.export		_RoundSprL
	.export		_RoundSprR
	.export		_arg1
	.export		_arg2
	.export		_pad1
	.export		_pad1_new
	.export		_char_state
	.export		_scroll_top
	.export		_scroll2
	.export		_scroll3
	.export		_scroll4
	.export		_temp
	.export		_sprite_x
	.export		_sprite_y
	.export		_dirLR
	.export		_irq_array
	.export		_double_buffer
	.export		_wram_array
	.export		_palette_bg
	.export		_palette_spr
	.export		_TEXT0
	.export		_function_bank0
	.export		_TEXT1
	.export		_function_bank2
	.export		_function_bank1
	.export		_TEXT2
	.export		_function_same_bank
	.export		_TEXT3
	.export		_function_bank3
	.export		_TEXT6
	.export		_function_bank6
	.export		_text
	.export		_draw_sprites
	.export		_main

.segment	"RODATA"

.segment	"STARTUP"
_RoundSprL:
	.byte	$FF
	.byte	$FF
	.byte	$02
	.byte	$00
	.byte	$07
	.byte	$FF
	.byte	$03
	.byte	$00
	.byte	$FF
	.byte	$07
	.byte	$12
	.byte	$00
	.byte	$07
	.byte	$07
	.byte	$13
	.byte	$00
	.byte	$80
_RoundSprR:
	.byte	$FF
	.byte	$FF
	.byte	$00
	.byte	$00
	.byte	$07
	.byte	$FF
	.byte	$01
	.byte	$00
	.byte	$FF
	.byte	$07
	.byte	$10
	.byte	$00
	.byte	$07
	.byte	$07
	.byte	$11
	.byte	$00
	.byte	$80
_palette_bg:
	.byte	$0F
	.byte	$00
	.byte	$10
	.byte	$30
	.byte	$0F
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$0F
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$0F
	.byte	$00
	.byte	$00
	.byte	$00
_palette_spr:
	.byte	$0F
	.byte	$09
	.byte	$19
	.byte	$29
	.byte	$0F
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$0F
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$0F
	.byte	$00
	.byte	$00
	.byte	$00
.segment	"BANK0"
_TEXT0:
	.byte	$42,$41,$4E,$4B,$30,$00
.segment	"BANK1"
_TEXT1:
	.byte	$42,$41,$4E,$4B,$31,$00
.segment	"BANK2"
_TEXT2:
	.byte	$42,$41,$4E,$4B,$32,$00
.segment	"BANK3"
_TEXT3:
	.byte	$42,$41,$4E,$4B,$33,$00
.segment	"BANK6"
_TEXT6:
	.byte	$42,$41,$4E,$4B,$36,$00
.segment	"CODE"
_text:
	.byte	$42,$41,$43,$4B,$20,$49,$4E,$20,$46,$49,$58,$45,$44,$20,$42,$41
	.byte	$4E,$4B,$00

.segment	"BSS"

_bankLevel:
	.res	1,$00
_bankBuffer:
	.res	10,$00
.segment	"ZEROPAGE"
_arg1:
	.res	1,$00
_arg2:
	.res	1,$00
_pad1:
	.res	1,$00
_pad1_new:
	.res	1,$00
_char_state:
	.res	1,$00
_scroll_top:
	.res	2,$00
_scroll2:
	.res	2,$00
_scroll3:
	.res	2,$00
_scroll4:
	.res	2,$00
_temp:
	.res	1,$00
_sprite_x:
	.res	1,$00
_sprite_y:
	.res	1,$00
_dirLR:
	.res	1,$00
.segment	"BSS"
_irq_array:
	.res	32,$00
_double_buffer:
	.res	32,$00
.segment	"XRAM"
_wram_array:
	.res	8192,$00

; ---------------------------------------------------------------
; void __near__ banked_call (unsigned char bankId, void (*method)(void))
; ---------------------------------------------------------------

.segment	"STARTUP"

.proc	_banked_call: near

.segment	"STARTUP"

;
; void banked_call(unsigned char bankId, void (*method)(void)) {
;
	jsr     pushax
;
; bank_push(bankId);
;
	ldy     #$02
	lda     (sp),y
	jsr     _bank_push
;
; (*method)();
;
	ldy     #$01
	lda     (sp),y
	tax
	dey
	lda     (sp),y
	jsr     callax
;
; bank_pop();
;
	jsr     _bank_pop
;
; }
;
	jmp     incsp3

.endproc

; ---------------------------------------------------------------
; void __near__ bank_push (unsigned char bankId)
; ---------------------------------------------------------------

.segment	"STARTUP"

.proc	_bank_push: near

.segment	"STARTUP"

;
; void bank_push(unsigned char bankId) {
;
	jsr     pusha
;
; bankBuffer[bankLevel] = get_prg_8000();
;
	lda     #<(_bankBuffer)
	ldx     #>(_bankBuffer)
	clc
	adc     _bankLevel
	bcc     L0002
	inx
L0002:	jsr     pushax
	jsr     _get_prg_8000
	ldy     #$00
	jsr     staspidx
;
; ++bankLevel;
;
	inc     _bankLevel
;
; set_prg_8000(bankId);
;
	ldy     #$00
	lda     (sp),y
	jsr     _set_prg_8000
;
; }
;
	jmp     incsp1

.endproc

; ---------------------------------------------------------------
; void __near__ bank_pop (void)
; ---------------------------------------------------------------

.segment	"STARTUP"

.proc	_bank_pop: near

.segment	"STARTUP"

;
; if (bankLevel != 0) {
;
	lda     _bankLevel
	beq     L0002
;
; --bankLevel;
;
	dec     _bankLevel
;
; set_prg_8000(bankBuffer[bankLevel]);
;
	ldy     _bankLevel
	lda     _bankBuffer,y
	jmp     _set_prg_8000
;
; }
;
L0002:	rts

.endproc

; ---------------------------------------------------------------
; void __near__ function_bank0 (void)
; ---------------------------------------------------------------

.segment	"BANK0"

.proc	_function_bank0: near

.segment	"BANK0"

;
; ppu_off();
;
	jsr     _ppu_off
;
; vram_adr(NTADR_A(1,4));
;
	ldx     #$20
	lda     #$81
	jsr     _vram_adr
;
; vram_write(TEXT0,sizeof(TEXT0));
;
	lda     #<(_TEXT0)
	ldx     #>(_TEXT0)
	jsr     pushax
	ldx     #$00
	lda     #$06
	jsr     _vram_write
;
; ppu_on_all();
;
	jmp     _ppu_on_all

.endproc

; ---------------------------------------------------------------
; void __near__ function_bank2 (void)
; ---------------------------------------------------------------

.segment	"BANK2"

.proc	_function_bank2: near

.segment	"BANK2"

;
; ppu_off();
;
	jsr     _ppu_off
;
; vram_adr(NTADR_A(1,8));
;
	ldx     #$21
	lda     #$01
	jsr     _vram_adr
;
; vram_write(TEXT2,sizeof(TEXT2));
;
	lda     #<(_TEXT2)
	ldx     #>(_TEXT2)
	jsr     pushax
	ldx     #$00
	lda     #$06
	jsr     _vram_write
;
; function_same_bank();
;
	jsr     _function_same_bank
;
; ppu_on_all();
;
	jmp     _ppu_on_all

.endproc

; ---------------------------------------------------------------
; void __near__ function_bank1 (void)
; ---------------------------------------------------------------

.segment	"BANK1"

.proc	_function_bank1: near

.segment	"BANK1"

;
; ppu_off();
;
	jsr     _ppu_off
;
; vram_adr(NTADR_A(1,6));
;
	ldx     #$20
	lda     #$C1
	jsr     _vram_adr
;
; vram_write(TEXT1,sizeof(TEXT1));
;
	lda     #<(_TEXT1)
	ldx     #>(_TEXT1)
	jsr     pushax
	ldx     #$00
	lda     #$06
	jsr     _vram_write
;
; ppu_on_all();
;
	jsr     _ppu_on_all
;
; banked_call(2, function_bank2);
;
	lda     #$02
	jsr     pusha
	lda     #<(_function_bank2)
	ldx     #>(_function_bank2)
	jmp     _banked_call

.endproc

; ---------------------------------------------------------------
; void __near__ function_same_bank (void)
; ---------------------------------------------------------------

.segment	"BANK2"

.proc	_function_same_bank: near

.segment	"BANK2"

;
; vram_put(0);
;
	lda     #$00
	jsr     _vram_put
;
; vram_put('H');
;
	lda     #$48
	jsr     _vram_put
;
; vram_put('I');
;
	lda     #$49
	jmp     _vram_put

.endproc

; ---------------------------------------------------------------
; void __near__ function_bank3 (void)
; ---------------------------------------------------------------

.segment	"BANK3"

.proc	_function_bank3: near

.segment	"BANK3"

;
; ppu_off();
;
	jsr     _ppu_off
;
; vram_adr(NTADR_A(1,10));
;
	ldx     #$21
	lda     #$41
	jsr     _vram_adr
;
; vram_write(TEXT3,sizeof(TEXT3));
;
	lda     #<(_TEXT3)
	ldx     #>(_TEXT3)
	jsr     pushax
	ldx     #$00
	lda     #$06
	jsr     _vram_write
;
; vram_put(0);
;
	lda     #$00
	jsr     _vram_put
;
; vram_put(arg1); // these args were passed via globals
;
	lda     _arg1
	jsr     _vram_put
;
; vram_put(arg2);
;
	lda     _arg2
	jsr     _vram_put
;
; ppu_on_all();
;
	jmp     _ppu_on_all

.endproc

; ---------------------------------------------------------------
; void __near__ function_bank6 (void)
; ---------------------------------------------------------------

.segment	"BANK6"

.proc	_function_bank6: near

.segment	"BANK6"

;
; ppu_off();
;
	jsr     _ppu_off
;
; vram_adr(NTADR_A(1,14));
;
	ldx     #$21
	lda     #$C1
	jsr     _vram_adr
;
; vram_write(TEXT6,sizeof(TEXT6));
;
	lda     #<(_TEXT6)
	ldx     #>(_TEXT6)
	jsr     pushax
	ldx     #$00
	lda     #$06
	jsr     _vram_write
;
; vram_put(0);
;
	lda     #$00
	jsr     _vram_put
;
; vram_put(wram_array[0]); // testing the $6000-7fff area
;
	lda     _wram_array
	jsr     _vram_put
;
; vram_put(wram_array[2]); // should print A, C
;
	lda     _wram_array+2
	jsr     _vram_put
;
; ppu_on_all();
;
	jmp     _ppu_on_all

.endproc

; ---------------------------------------------------------------
; void __near__ draw_sprites (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_draw_sprites: near

.segment	"CODE"

;
; oam_clear();
;
	jsr     _oam_clear
;
; if(!dirLR) { // left
;
	lda     _dirLR
	bne     L0002
;
; oam_meta_spr(sprite_x, sprite_y, RoundSprL);
;
	jsr     decsp2
	lda     _sprite_x
	ldy     #$01
	sta     (sp),y
	lda     _sprite_y
	dey
	sta     (sp),y
	lda     #<(_RoundSprL)
	ldx     #>(_RoundSprL)
;
; else {
;
	jmp     L0004
;
; oam_meta_spr(sprite_x, sprite_y, RoundSprR);
;
L0002:	jsr     decsp2
	lda     _sprite_x
	ldy     #$01
	sta     (sp),y
	lda     _sprite_y
	dey
	sta     (sp),y
	lda     #<(_RoundSprR)
	ldx     #>(_RoundSprR)
L0004:	jmp     _oam_meta_spr

.endproc

; ---------------------------------------------------------------
; void __near__ main (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_main: near

.segment	"CODE"

;
; set_mirroring(MIRROR_HORIZONTAL);
;
	lda     #$01
	jsr     _set_mirroring
;
; bank_spr(1);
;
	lda     #$01
	jsr     _bank_spr
;
; irq_array[0] = 0xff; // end of data
;
	lda     #$FF
	sta     _irq_array
;
; set_irq_ptr(irq_array); // point to this array
;
	lda     #<(_irq_array)
	ldx     #>(_irq_array)
	jsr     _set_irq_ptr
;
; memfill(wram_array,0,0x2000); 
;
	jsr     decsp3
	lda     #<(_wram_array)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(_wram_array)
	sta     (sp),y
	lda     #$00
	tay
	sta     (sp),y
	ldx     #$20
	jsr     _memfill
;
; wram_array[0] = 'A'; // put some values at $6000-7fff
;
	lda     #$41
	sta     _wram_array
;
; wram_array[2] = 'C'; // for later testing
;
	lda     #$43
	sta     _wram_array+2
;
; ppu_off(); // screen off
;
	jsr     _ppu_off
;
; pal_bg(palette_bg); // load the BG palette
;
	lda     #<(_palette_bg)
	ldx     #>(_palette_bg)
	jsr     _pal_bg
;
; pal_spr(palette_spr); // load the sprite palette
;
	lda     #<(_palette_spr)
	ldx     #>(_palette_spr)
	jsr     _pal_spr
;
; vram_adr(NTADR_A(20,3)); // gear and squares
;
	ldx     #$20
	lda     #$74
	jsr     _vram_adr
;
; vram_put(0xc0);
;
	lda     #$C0
	jsr     _vram_put
;
; vram_put(0xc1);
;
	lda     #$C1
	jsr     _vram_put
;
; vram_put(0xc2);
;
	lda     #$C2
	jsr     _vram_put
;
; vram_put(0xc3);
;
	lda     #$C3
	jsr     _vram_put
;
; vram_adr(NTADR_A(20,4));
;
	ldx     #$20
	lda     #$94
	jsr     _vram_adr
;
; vram_put(0xd0);
;
	lda     #$D0
	jsr     _vram_put
;
; vram_put(0xd1);
;
	lda     #$D1
	jsr     _vram_put
;
; vram_put(0xd2);
;
	lda     #$D2
	jsr     _vram_put
;
; vram_put(0xd3);
;
	lda     #$D3
	jsr     _vram_put
;
; vram_adr(NTADR_A(20,7));
;
	ldx     #$20
	lda     #$F4
	jsr     _vram_adr
;
; vram_put(0xc0);
;
	lda     #$C0
	jsr     _vram_put
;
; vram_put(0xc1);
;
	lda     #$C1
	jsr     _vram_put
;
; vram_put(0xc2);
;
	lda     #$C2
	jsr     _vram_put
;
; vram_put(0xc3);
;
	lda     #$C3
	jsr     _vram_put
;
; vram_adr(NTADR_A(20,8));
;
	ldx     #$21
	lda     #$14
	jsr     _vram_adr
;
; vram_put(0xd0);
;
	lda     #$D0
	jsr     _vram_put
;
; vram_put(0xd1);
;
	lda     #$D1
	jsr     _vram_put
;
; vram_put(0xd2);
;
	lda     #$D2
	jsr     _vram_put
;
; vram_put(0xd3);
;
	lda     #$D3
	jsr     _vram_put
;
; vram_adr(NTADR_A(20,5)); // blocks of color
;
	ldx     #$20
	lda     #$B4
	jsr     _vram_adr
;
; vram_put(0x2);
;
	lda     #$02
	jsr     _vram_put
;
; vram_put(0x2);
;
	lda     #$02
	jsr     _vram_put
;
; vram_put(0x2);
;
	lda     #$02
	jsr     _vram_put
;
; vram_put(0x2);
;
	lda     #$02
	jsr     _vram_put
;
; vram_adr(NTADR_A(20,9));
;
	ldx     #$21
	lda     #$34
	jsr     _vram_adr
;
; vram_put(0x2);
;
	lda     #$02
	jsr     _vram_put
;
; vram_put(0x2);
;
	lda     #$02
	jsr     _vram_put
;
; vram_put(0x2);
;
	lda     #$02
	jsr     _vram_put
;
; vram_put(0x2);
;
	lda     #$02
	jsr     _vram_put
;
; vram_adr(NTADR_A(20,13));
;
	ldx     #$21
	lda     #$B4
	jsr     _vram_adr
;
; vram_put(0x2);
;
	lda     #$02
	jsr     _vram_put
;
; vram_put(0x2);
;
	lda     #$02
	jsr     _vram_put
;
; vram_put(0x2);
;
	lda     #$02
	jsr     _vram_put
;
; vram_put(0x2);
;
	lda     #$02
	jsr     _vram_put
;
; music_play(0);
;
	lda     #$00
	jsr     _music_play
;
; set_chr_mode_5(8); // make sure the gear tiles loaded
;
	lda     #$08
	jsr     _set_chr_mode_5
;
; banked_call(0, function_bank0);
;
	lda     #$00
	jsr     pusha
	lda     #<(_function_bank0)
	ldx     #>(_function_bank0)
	jsr     _banked_call
;
; banked_call(1, function_bank1);
;
	lda     #$01
	jsr     pusha
	lda     #<(_function_bank1)
	ldx     #>(_function_bank1)
	jsr     _banked_call
;
; arg1 = 'G'; // must pass arguments with globals
;
	lda     #$47
	sta     _arg1
;
; arg2 = '4';
;
	lda     #$34
	sta     _arg2
;
; banked_call(3, function_bank3);
;
	lda     #$03
	jsr     pusha
	lda     #<(_function_bank3)
	ldx     #>(_function_bank3)
	jsr     _banked_call
;
; banked_call(6, function_bank6);
;
	lda     #$06
	jsr     pusha
	lda     #<(_function_bank6)
	ldx     #>(_function_bank6)
	jsr     _banked_call
;
; ppu_off(); // screen off
;
	jsr     _ppu_off
;
; vram_adr(NTADR_A(1,16));
;
	ldx     #$22
	lda     #$01
	jsr     _vram_adr
;
; vram_write(text,sizeof(text));
;
	lda     #<(_text)
	ldx     #>(_text)
	jsr     pushax
	ldx     #$00
	lda     #$13
	jsr     _vram_write
;
; sprite_x = 0x50;
;
	lda     #$50
	sta     _sprite_x
;
; sprite_y = 0x30;
;
	lda     #$30
	sta     _sprite_y
;
; draw_sprites();
;
	jsr     _draw_sprites
;
; ppu_on_all(); // turn on screen
;
	jsr     _ppu_on_all
;
; ppu_wait_nmi();
;
L0002:	jsr     _ppu_wait_nmi
;
; pad1 = pad_poll(0);
;
	lda     #$00
	jsr     _pad_poll
	sta     _pad1
;
; pad1_new = get_pad_new(0);
;
	lda     #$00
	jsr     _get_pad_new
	sta     _pad1_new
;
; if(pad1 & PAD_A){ // shift screen right = subtract from scroll
;
	lda     _pad1
	and     #$80
	beq     L0019
;
; scroll_top -= 0x80; // sub pixel movement
;
	lda     _scroll_top
	sec
	sbc     #$80
	sta     _scroll_top
	bcs     L0006
	dec     _scroll_top+1
;
; scroll2 -= 0x100; // 1 pixel
;
L0006:	lda     _scroll2
	sec
	sta     _scroll2
	lda     _scroll2+1
	sbc     #$01
	sta     _scroll2+1
;
; scroll3 -= 0x180;
;
	lda     _scroll3
	sec
	sbc     #$80
	sta     _scroll3
	lda     _scroll3+1
	sbc     #$01
	sta     _scroll3+1
;
; scroll4 -= 0x200; 
;
	lda     _scroll4
	sec
	sta     _scroll4
	lda     _scroll4+1
	sbc     #$02
	sta     _scroll4+1
;
; if(pad1 & PAD_B){ // shift screen right = subtract from scroll
;
L0019:	lda     _pad1
	and     #$40
	beq     L001A
;
; scroll_top += 0x80; // sub pixel movement
;
	lda     #$80
	clc
	adc     _scroll_top
	sta     _scroll_top
	bcc     L001F
	inc     _scroll_top+1
;
; scroll2 += 0x100; // 1 pixel
;
	clc
L001F:	lda     _scroll2
	sta     _scroll2
	lda     #$01
	adc     _scroll2+1
	sta     _scroll2+1
;
; scroll3 += 0x180;
;
	lda     #$80
	clc
	adc     _scroll3
	sta     _scroll3
	lda     #$01
	adc     _scroll3+1
	sta     _scroll3+1
;
; scroll4 += 0x200;
;
	clc
	lda     _scroll4
	sta     _scroll4
	lda     #$02
	adc     _scroll4+1
	sta     _scroll4+1
;
; temp = scroll_top >> 8;
;
L001A:	lda     _scroll_top+1
	sta     _temp
;
; set_scroll_x(temp);
;
	ldx     #$00
	lda     _temp
	jsr     _set_scroll_x
;
; if((get_frame_count() & 0x03) == 0){ // every 4th frame
;
	jsr     _get_frame_count
	and     #$03
	bne     L001B
;
; ++char_state;
;
	inc     _char_state
;
; if(char_state >=4) char_state = 0;
;
	lda     _char_state
	cmp     #$04
	bcc     L001B
	lda     #$00
	sta     _char_state
;
; double_buffer[0] = 0xfc; // CHR mode 5, change the 0xc00-0xfff tiles
;
L001B:	lda     #$FC
	sta     _double_buffer
;
; double_buffer[1] = 8; // top of the screen, static value
;
	lda     #$08
	sta     _double_buffer+1
;
; double_buffer[2] = 47; // value < 0xf0 = scanline count, 1 less than #
;
	lda     #$2F
	sta     _double_buffer+2
;
; double_buffer[3] = 0xf5; // H scroll change, do first for timing
;
	lda     #$F5
	sta     _double_buffer+3
;
; temp = scroll2 >> 8;
;
	lda     _scroll2+1
	sta     _temp
;
; double_buffer[4] = temp; // scroll value
;
	sta     _double_buffer+4
;
; double_buffer[5] = 0xfc; // CHR mode 5, change the 0xc00-0xfff tiles
;
	lda     #$FC
	sta     _double_buffer+5
;
; double_buffer[6] = 8 + char_state; // value = 8,9,10,or 11
;
	lda     _char_state
	clc
	adc     #$08
	sta     _double_buffer+6
;
; double_buffer[7] = 30; // scanline count
;
	lda     #$1E
	sta     _double_buffer+7
;
; double_buffer[8] = 0xf5; // H scroll change
;
	lda     #$F5
	sta     _double_buffer+8
;
; temp = scroll3 >> 8;
;
	lda     _scroll3+1
	sta     _temp
;
; double_buffer[9] = temp; // scroll value
;
	sta     _double_buffer+9
;
; double_buffer[10] = 0xf1; // $2001 test changing color emphasis
;
	lda     #$F1
	sta     _double_buffer+10
;
; double_buffer[11] = 0xfe; // value COL_EMP_DARK 0xe0 + 0x1e
;
	lda     #$FE
	sta     _double_buffer+11
;
; double_buffer[12] = 30; // scanline count
;
	lda     #$1E
	sta     _double_buffer+12
;
; double_buffer[13] = 0xf5; // H scroll change
;
	lda     #$F5
	sta     _double_buffer+13
;
; temp = scroll4 >> 8;
;
	lda     _scroll4+1
	sta     _temp
;
; double_buffer[14] = temp; // scroll value
;
	sta     _double_buffer+14
;
; double_buffer[15] = 30; // scanline count
;
	lda     #$1E
	sta     _double_buffer+15
;
; double_buffer[16] = 0xf5; // H scroll change
;
	lda     #$F5
	sta     _double_buffer+16
;
; double_buffer[17] = 0; // to zero, to set the fine X scroll
;
	lda     #$00
	sta     _double_buffer+17
;
; double_buffer[18] = 0xf6; // 2 writes to 2006 shifts screen
;
	lda     #$F6
	sta     _double_buffer+18
;
; double_buffer[19] = 0x20; // need 2 values...
;
	lda     #$20
	sta     _double_buffer+19
;
; double_buffer[20] = 0x00; // PPU address $2000 = top of screen
;
	lda     #$00
	sta     _double_buffer+20
;
; double_buffer[21] = 0xff; // end of data
;
	lda     #$FF
	sta     _double_buffer+21
;
; if(pad1 & PAD_LEFT){ // shift screen right = subtract from scroll
;
	lda     _pad1
	and     #$02
	beq     L001C
;
; sprite_x -= 1;
;
	dec     _sprite_x
;
; dirLR = 0;
;
	lda     #$00
;
; else if(pad1 & PAD_RIGHT){ // shift screen right = subtract from scroll
;
	jmp     L0017
L001C:	lda     _pad1
	and     #$01
	beq     L001D
;
; sprite_x += 1;
;
	inc     _sprite_x
;
; dirLR = 1;
;
	lda     #$01
L0017:	sta     _dirLR
;
; if(pad1 & PAD_UP){ // shift screen right = subtract from scroll
;
L001D:	lda     _pad1
	and     #$08
	beq     L001E
;
; sprite_y -= 1;
;
	dec     _sprite_y
;
; else if(pad1 & PAD_DOWN){ // shift screen right = subtract from scroll
;
	jmp     L0012
L001E:	lda     _pad1
	and     #$04
	beq     L0012
;
; sprite_y += 1;
;
	inc     _sprite_y
;
; draw_sprites();
;
L0012:	jsr     _draw_sprites
;
; while(!is_irq_done() ){ // have we reached the 0xff, end of data
;
L0013:	jsr     _is_irq_done
	tax
	beq     L0013
;
; memcpy(irq_array, double_buffer, sizeof(irq_array)); 
;
	ldy     #$1F
L0016:	lda     _double_buffer,y
	sta     _irq_array,y
	dey
	bpl     L0016
;
; while (1){ // infinite loop
;
	jmp     L0002

.endproc
