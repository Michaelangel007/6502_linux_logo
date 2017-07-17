
# 6502 Linux Logo

Linux Logo in 6502 assembly language.

Size: 696 ($2B8) bytes


# Screenshots

![Apple \]\[ ](pics/linux_logo_2.png)
![Apple \]\[+](pics/linux_logo_2plus.png)
![Apple //e  ](pics/linux_logo_2e.png)
![Apple //e+ ](pics/linux_logo_2eplus.png)


# Features

* Detects Apple \]\[, \]\[+, //e, //e+, //c, //c+
  * Pretty-print model instead of generic "II_" (bloats from 696 but worth it.)
* Detects 48K/64K/128K 
* System out all uppercase (for Apple \]\[ without lowercase)
* Cleaned up fugly logo by Albert Lai
  * Width is now 70 chars to be exact 4 pixels/char for 280 HGR resolution
  * Bit-packed Logo takes up 210 bytes (2 bits/char) compared to 80*12 = 960 byte
  * X is now symmetrical
  * Fixed L,i,n kerning
  * Fixed x Penguin kerning
  * Fixed L to fit
  * Chopped off 2 columns of penguin to fit 70 chars
* Expands 2 bits to 4 bits = 2 pixels (70 chars * 4 bits = 280 px)

```
..........................................................#####.......
.........................................................#######......
...............@.........................................## # ##......
######........@@#........................................#QQQQQ#......
..##...........#.......................................##..QQQ..##....
..##.......@@@..###.####...###....###..#####.#####....#..........##...
..##......@..@#..###....##..##.....##....##...##.....#............##..
..##.....@...@#..##.....##..##.....##.....##.##......#............###.
..##........@@#..##.....##..##.....##......###......QQ#...........##Q.
..##.....#.@@#...##.....##..##.....##.....##.##....QQQQQ#.......#QQQQQ
..##....##.@@#.#.##.....##..###...###....##...##...QQQQQQ#.....#QQQQQQ
##########..###.####...####...####.###.#####.#####..QQQQQ#######QQQQQ.
```

See: [ascii2hgr2bit](ascii2hgr2bit.c) for packing ASCII to 2 bits/char.
NOTE: PackedLen isn't needed if full 40 bytes HGR width is unpacked to.

Inspired from non-optimized version. Size: 1,573 ($625) bytes
* https://github.com/deater/linux_logo

![Apple \]\[+](pics/ll_6502_2plus.png)
![Apple //e  ](pics/ll_6502_2e.png)


# License

[WTFPl](http://www.wtfpl.net/)

If you use code, please provide a comment link so people can follow it for updates.

