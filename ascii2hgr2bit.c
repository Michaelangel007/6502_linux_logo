/*
6502 Linux Logo
Michaelangel007
https://github.com/Michaelangel007/6502_linux_logo

gcc -Wall -Wextra ascii2hgr2bit.c -o ascii2hgr2bit
*/

#include <stdio.h>

/*
  Cleaned up crappy logo by Albert Lai <aylai@unixg.ubc.ca>

    * Width is now 70 chars to be exact 4 pixels/char for 280 resolution
    * X is now symmetrical
    * Fixed L,i,n kerning
    * Fixed x Penguin kerning
    * Fixed L to fit
    * Chopped off 2 columsn of penguin to fit 70 chars

  https://github.com/deater/linux_logo/blob/master/logos/banner.logo

*/
int gbOutputHgr = 0; // 0 = 2bits/2pixel, 1=HGR bytes

unsigned char  gaLogoBits[ 280 / 2 * 192 / 8 ]; // packed bits
const    char* gaLogo70 = 
/*
ASCII:
    70 chars * 12 scanlines = 840 bytes

Bitpacked 1-bit/4 pixels
    

Bitpacked 2-bits/2 pixels
    70 chars * 2 bits/char / 8 bits/byte = 17.5 bytes / scanline
    17.5 bytes/scanline * 12 scanlines = 210 bytes

   Char &3 Color
   @   00 Black
   A   01 Blue
   B   10 Orange
   _   11 White

 0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  16  17.5
 <--><--><--><--><--><--><--><--><--><--><--><--><--><--><--><--><--><-->
*/
#if 1
"__________________________________________________________@@@@@_______"
"_________________________________________________________@@@@@@@______"
"______________A__________________________________________@@_@_@@______"
"@@@@@@_______AA@_________________________________________@BBBBB@______"
"__@@__________@________________________________________@@__BBB__@@____"
"__@@_______AAA__@@@_@@@@___@@@____@@@__@@@@@_@@@@@____@__________@@___"
"__@@______A__A@__@@@____@@__@@_____@@____@@___@@_____@____________@@__"
"__@@_____A___A@__@@_____@@__@@_____@@_____@@_@@______@____________@@@_"
"__@@________AA@__@@_____@@__@@_____@@______@@@______BB@___________@@B_"
"__@@_____@_AA@___@@_____@@__@@_____@@_____@@_@@____BBBBB@_______@BBBBB"
"__@@____@@_AA@_@_@@_____@@__@@@___@@@____@@___@@___BBBBBB@_____@BBBBBB"
"@@@@@@@@@@__@@@_@@@@___@@@@___@@@@_@@@_@@@@@_@@@@@__BBBBB@@@@@@@BBBBB_"
#else

// _@_@_@_@_@_@_@ = PACK: $33,$33,$33,$33 -> HGR: $33,$66,$4C,$19 (MSB=0)
//                  1100110011001100110011001100  $B3,$E6,$CC,$99 (MSB=1)
//"_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@"


/*
Bit Packing 2 bits / 1 pixels

 <--CC--> <--CC--> <--CC--> <--CC-->  Packed Bytes
|11001100|11001100|11001100|11001100| Packed Bits
|hgfedcba|ponmlkji|xwvutsrq|FEDCBAzy|
|        |        |        |        |
|76543210|76543210|76543210|76543210| Bit Position
|    0   |    1   |    2   |    3   | Byte
|        |        |        |        |
|1gfedcba|1nmlkjih|1utsrqpo|1BAzyxwv|
|11001100|10011001|10110011|11100110|
 <--CC--> <--99--> <--B3--> <--E6-->  HGR Bytes

 @_@_@_@_@_@_@_ = 00110011001100110011001100
                = 11001100110011001100110011 (reverse bits)
                = PACK: $CC,$CC,$CC,$CC
                -> HGR: $CC,$99,$B3,$E6 (MSB=1)
                   HGR: $4C,$19,$33,$66 (MSB=0)
*/
"@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_@_"

#endif
;

int main( const int nArg, const char *aArg[] )
{
    (void) aArg;
    if( nArg > 1 )
        gbOutputHgr = 1;

    const    char *src = gaLogo70;
    unsigned char *dst = gaLogoBits;

    unsigned int   bit = 0;
    unsigned char  shl = 0;
    unsigned int   len = 0;
    unsigned int   i;

    while( *src )
    {
        bit |= (*src & 3) << shl;
        shl += 2;

if( gbOutputHgr )
{
        if( shl >= 8 )
        {
            shl -= 7 ;
           *dst++= (0x80 | bit);
            bit >>= 7;
        }
} else {
        if( shl >= 8 )
        {
            shl -= 8 ;
           *dst++= bit;
            bit  = 0;
        }
}
        src++;
    }

    len = (unsigned int)(dst - gaLogoBits);
    printf( "PackedLen\n" );
    printf( "        dfb $%02X\n", len );
    printf( "PackedBits\n");
    printf( "        ;     0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34 byte\n" );
    printf( "        ;     0  16  32  48  64  80  96 112 128 144 160 176 192 208 224 240 256 272   8  24  40  56  72  88 104 120 136 152 168 184 200 216 232 248 264 px\n"   );

    for( i = 0; i < len; i++ )
    {
        if( (i % (35)) == 0 )
        {
            if( i > 0 )
                printf( "\n" );
            printf( "        dfb " );
        }
        printf( "$%02X,", gaLogoBits[ i ] );
    }
    printf( "\n" );

    return 0;
}
