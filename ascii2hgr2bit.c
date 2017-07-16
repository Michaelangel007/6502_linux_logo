/*
Michaelangel007
6502 Linux Logo
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
#if 0
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
"@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-"
#endif
;

int main( const int nArg, const char *aArg[] )
{
    const    char *src = gaLogo70;
    unsigned char *dst = gaLogoBits;

    unsigned char  bit = 0;
    unsigned char  shl = 0;
    unsigned int   len = 0;
    unsigned int   i;

    while( *src )
    {
        bit |= (*src & 3) << shl;
        shl += 2;

        if( shl >= 8 )
        {
            shl -= 8 ;
           *dst++ = bit;
            bit  = 0;
        }

        src++;
    }

    len = (unsigned int)(dst - gaLogoBits);
    printf( "        dfb $%02X\n", len );

    for( i = 0; i < len; i++ )
    {
        if( (i % (70 / 2)) == 0 )
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
