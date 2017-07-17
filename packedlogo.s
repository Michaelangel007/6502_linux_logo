PackedLen
        dfb $D2
PackedBits
        ;     0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34 byte
        ;     0  16  32  48  64  80  96 112 128 144 160 176 192 208 224 240 256 272   8  24  40  56  72  88 104 120 136 152 168 184 200 216 232 248 264 px
        dfb $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$0F,$C0,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$3F,$00,$F0,$FF,
        dfb $FF,$FF,$FF,$DF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$C3,$0C,$FF,$0F,$00,$FF,$7F,$F1,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$3F,$AA,$F2,$FF,
        dfb $0F,$FF,$FF,$CF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$3F,$BC,$FA,$F0,$FF,$F0,$FF,$57,$0F,$0C,$F0,$03,$FF,$C0,$03,$30,$00,$FF,$FC,$FF,$3F,$FC,
        dfb $0F,$FF,$DF,$C7,$03,$FF,$F0,$F0,$3F,$FC,$C3,$0F,$FF,$F3,$FF,$FF,$0F,$FF,$F0,$7F,$7F,$3C,$FC,$0F,$0F,$FF,$C3,$FF,$30,$FC,$3F,$FF,$FF,$FF,$C0,
        dfb $0F,$FF,$FF,$C5,$C3,$FF,$F0,$F0,$3F,$FC,$3F,$F0,$FF,$CA,$FF,$FF,$0F,$FE,$F0,$3F,$17,$3F,$FC,$0F,$0F,$FF,$C3,$FF,$30,$FC,$AB,$CA,$FF,$8F,$AA,
        dfb $0F,$FF,$70,$31,$C3,$FF,$F0,$C0,$0F,$FC,$C3,$0F,$BF,$AA,$F2,$3F,$AA,$0A,$00,$00,$0F,$0C,$F0,$03,$FC,$00,$03,$03,$30,$00,$AF,$2A,$00,$A0,$EA,
