       0:	r6 = r1
       1:	r0 = get_prandom_u32:7()
       2:	r1 = r0
       3:	r1 &= 1
       4:	if r1 == 0 goto +11 <16>
       5:	r0 <<= 2
       6:	r0 &= 60
       7:	r1 = *(u32 *)(r6 + 0)
       8:	r1 += r0
       9:	r0 = 1
      10:	r2 = r1
      11:	r2 += 4
      12:	r3 = *(u32 *)(r6 + 4)
      13:	if r2 > r3 goto +13 <27>
      14:	r0 = *(u32 *)(r1 + 0)
      15:	goto +11 <27>
      16:	r0 <<= 2
      17:	r0 &= 60
      18:	r1 = *(u32 *)(r6 + 0)
      19:	r0 += r1
      20:	r1 = r0
      21:	r0 = 1
      22:	r2 = r1
      23:	r2 += 4
      24:	r3 = *(u32 *)(r6 + 4)
      25:	if r2 > r3 goto +1 <27>
      26:	r0 = *(u32 *)(r1 + 0)
      27:	exit
