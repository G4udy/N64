align(256)
  // $00 BRK   #nn               Software Break
  subiu s4,4             // S_REG -= 4 (Decrement Stack)
  andi s4,$FFFF
  addu a2,a0,s4          // STACK = MEM_MAP[$100 + S_REG]
  addiu a2,$100          // A2 = STACK                 
  sb s8,4(a2)            // STACK = PB_REG (65816 Native Mode)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  sb s3,2(a2)            // STACK = PC_REG
  srl t0,s3,8
  sb t0,3(a2)                 
  sb s5,1(a2)            // STACK = P_REG
  ori s5,I_FLAG          // P_REG: I Flag Set
  andi s5,~D_FLAG        // P_REG: D Flag Reset (65816 Native Mode)
  and s8,r0              // PB_REG = 0 (65816 Native Mode)
  lbu t0,BRK1_VEC+1(a0)  // PC_REG: Set To 65816 Break Vector ($FFE6)
  sll t0,8
  lbu s3,BRK1_VEC(a0)
  or s3,t0
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

align(256)
  // $01 ORA   (dp+X)            Logical OR Value From Indirect Absolute Address In Direct Page Offset Added With Value X With A
  lbu t0,1(a2)           // DPXI = MEM_MAP[MEM_MAP[Immediate + X_REG + D_REG]]
  addu t0,s1             // T0 = Immediate + X_REG
  addu t0,s6             // T0 = Immediate + X_REG + D_REG
  addu a2,a0,t0          // A2 = MEM_MAP + Immediate + X_REG + D_REG
  lbu t0,0(a2)
  lbu t1,1(a2)
  sll t1,8
  or t0,t1               // T0 = MEM_MAP[Immediate + X_REG + D_REG]
  addu a2,a0,t0          // A2 = MEM_MAP + MEM_MAP[Immediate + X_REG + D_REG]
  lbu t0,0(a2)
  lbu t1,1(a2)
  sll t1,8
  or t0,t1               // T0 = DPXI
  or s0,t0               // A_REG |= DPXI
  andi t0,s0,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,ORADPXIM0X0    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ORADPXIM0X0:
  addiu s3,1             // PC_REG++
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

align(256)
  // $02 COP   #nn               Co-Processor Enable
  subiu s4,4             // S_REG -= 4 (Decrement Stack)
  andi s4,$FFFF
  addu a2,a0,s4          // STACK = MEM_MAP[$100 + S_REG]
  addiu a2,$100          // A2 = STACK
  sb s8,4(a2)            // STACK = PB_REG (65816 Native Mode)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  sb s3,2(a2)            // STACK = PC_REG
  srl t0,s3,8
  sb t0,3(a2)
  sb s5,1(a2)            // STACK = P_REG
  ori s5,I_FLAG          // P_REG: I Flag Set
  andi s5,~D_FLAG        // P_REG: D Flag Reset
  and s8,r0              // PB_REG = 0 (65816 Native Mode)
  lbu t0,COP1_VEC+1(a0)  // PC_REG: Set To 65816 COP Vector ($FFE4)
  sll t0,8
  lbu s3,COP1_VEC(a0)
  or s3,t0
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

align(256)
  // $03 ORA   sr,S              Logical OR Value From Stack Relative Offset Added With Value S With A
  lbu t0,1(a2)           // SRS = MEM_MAP[Immediate + S_REG]
  addu t0,s4             // T0 = Immediate + S_REG
  addu a2,a0,t0          // A2 = MEM_MAP + Immediate + S_REG
  lbu t0,0(a2)
  lbu t1,1(a2)
  sll t1,8
  or t0,t1               // T0 = SRS
  or s0,t0               // A_REG |= SRS
  andi t0,s0,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,ORASRSM0X0     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ORASRSM0X0:
  addiu s3,1             // PC_REG++
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $04 TSB   dp                Test & Set Bits In Direct Page Offset With A
  lbu t0,1(a2)           // DP = MEM_MAP[Immediate + D_REG]
  addu t0,s6             // T0 = Immediate + D_REG
  addu a2,a0,t0          // A2 = MEM_MAP + Immediate + D_REG
  lbu t0,0(a2)
  lbu t1,1(a2)
  sll t1,8
  or t0,t1               // T0 = DP
  or t1,t0,s0            // Set & Store Bits
  sb t1,0(a2)
  srl t1,8
  sb t1,1(a2)
  and t0,s0              // Test DP AND Accumulator
  beqz t0,TSBDPM0X0      // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  TSBDPM0X0:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

align(256)
  // $05 ORA   dp                Logical OR Value In Direct Page Offset With A
  lbu t0,1(a2)           // DP = MEM_MAP[Immediate + D_REG]
  addu t0,s6             // T0 = Immediate + D_REG
  addu a2,a0,t0          // A2 = MEM_MAP + Immediate + D_REG
  lbu t0,0(a2)
  lbu t1,1(a2)
  sll t1,8
  or t0,t1               // T0 = DP
  or s0,t0               // A_REG |= DP
  andi t0,s0,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,ORADPM0X0      // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ORADPM0X0:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $06 ASL   dp                Arithmetic Shift Left Value In Direct Page Offset Into Carry Flag
  lbu t0,1(a2)           // DP = MEM_MAP[Immediate + D_REG]
  addu t0,s6             // T0 = Immediate + D_REG
  addu a2,a0,t0          // A2 = MEM_MAP + Immediate + D_REG
  lbu t0,0(a2)
  lbu t1,1(a2)
  sll t1,8
  or t0,t1               // T0 = DP
  andi t1,t0,$8000       // C Flag Set To Old MSB
  srl t1,15
  andi s5,~C_FLAG        // P_REG: C Flag Reset
  or s5,t1               // P_REG: C Flag = Old MSB
  sll t0,1               // DP <<= 1
  andi t0,$FFFF
  sb t0,0(a2)            // Store DP
  srl t1,t0,8
  sb t1,1(a2)
  andi t1,t0,$8000       // Test Negative MSB
  srl t1,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t1               // P_REG: N Flag = Result MSB
  beqz t0,ASLDPM0X0      // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ASLDPM0X0:
  addiu s3,1             // PC_REG++
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

align(256)
  // $07 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $08 PHP                     Push Processor Status Register
  addu a2,a0,s4          // STACK = P_REG (8-Bit)
  sb s5,0(a2)
  subiu s4,1             // S_REG-- (Decrement Stack)
  andi s4,$FFFF
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $09 ORA   #nnnn             OR Accumulator With Memory Immediate
  addu a2,a0,s3          // A_REG: OR With 16-Bit Immediate
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  or s0,t0
  andi t0,s0,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,ORAIMMM0X0     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ORAIMMM0X0:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $0A ASL A                   Shift Accumulator Left
  sll s0,1               // A_REG: << 1 (16-Bit)
  andi t0,s0,$8000       // Test Negative MSB / Carry
  srl t0,8
  srl t1,s0,16
  or t0,t1
  andi s5,~(N_FLAG+C_FLAG) // P_REG: N/C Flag Reset
  or s5,t0               // P_REG: N/C Flag = Result MSB / Carry
  andi s0,$FFFF
  beqz s0,ASLAM0X0       // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ASLAM0X0:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $0B PHD                     Push Direct Page Register
  addu a2,a0,s4          // STACK = D_REG (16-Bit)
  sb s6,-1(a2)
  srl t0,s6,8
  sb t0,0(a2)
  subiu s4,2             // S_REG -= 2 (Decrement Stack)
  andi s4,$FFFF
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $0C TSB   nnnn              Test & Set Memory Bits Against Accumulator Absolute
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // Load DB_REG:MEM (16-Bit)
  sll t0,s7,16
  addu a2,t0
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  or t1,t0,s0            // Set & Store Bits (16-Bit)
  sb t1,0(a2)
  srl t1,8
  sb t1,1(a2)
  and t0,s0              // Result AND Accumulator
  beqz t0,TSBABSM0X0     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  TSBABSM0X0:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

align(256)
  // $0D ORA   nnnn              OR Accumulator With Memory Absolute
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // A_REG: OR With DB_REG:MEM (16-Bit)
  sll t0,s7,16
  addu a2,t0
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  or s0,t0
  andi t0,s0,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,ORAABSM0X0     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ORAABSM0X0:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $0E ASL   nnnn              Shift Memory Left Absolute
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // Load DB_REG:MEM (16-Bit)
  sll t0,s7,16
  addu a2,t0
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  sll t0,1               // DB_REG:MEM: << 1 & Store Bits (16-Bit)
  sb t0,0(a2)
  srl t1,t0,8
  sb t1,1(a2)
  andi t1,t0,$8000       // Test Negative MSB / Carry
  srl t1,8
  srl t2,t0,16
  or t1,t2
  andi s5,~(N_FLAG+C_FLAG) // P_REG: N/C Flag Reset
  or s5,t1               // P_REG: N/C Flag = Result MSB / Carry
  andi t0,$FFFF
  beqz t0,ASLABSM0X0     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ASLABSM0X0:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

align(256)
  // $0F ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $10 BPL   nn                Branch IF Plus
  andi t0,s5,N_FLAG      // P_REG: Test N Flag
  bnez t0,BPLM0X0        // IF (N Flag != 0) Minus
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  addu a2,a0,s3          // Load Signed 8-Bit Relative Address
  lb t0,-1(a2)
  add s3,t0              // PC_REG: Set To 8-Bit Relative Address
  addiu v0,1             // Cycles++
  BPLM0X0:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $11 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $12 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $13 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $14 TRB   nn                Test & Reset Memory Bits Against Accumulator Direct Page
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // Load D_REG+MEM (16-Bit)
  addu a2,s6
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  xori t1,s0,$FFFF       // Reset & Store Bits (16-Bit)
  and t1,t0
  sb t1,0(a2)
  srl t1,8
  sb t1,1(a2)
  and t0,s0              // Result AND Accumulator
  beqz t0,TRBDPM0X0      // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  TRBDPM0X0:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

align(256)
  // $15 ORA   nn,X              OR Accumulator With Memory Direct Page Indexed, X
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // A_REG: OR With D_REG+MEM+X_REG (16-Bit)
  addu a2,s6
  addu a2,s1
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  or s0,t0
  andi t0,s0,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,ORADPXM0X0     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ORADPXM0X0:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $16 ASL   nn,X              Shift Memory Left Direct Page Indexed, X
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // Load D_REG+MEM+X_REG (16-Bit)
  addu a2,s6
  addu a2,s1
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  sll t0,1               // D_REG+MEM+X_REG: << 1 & Store Bits (16-Bit)
  sb t0,0(a2)
  srl t1,t0,8
  sb t1,1(a2)
  andi t1,t0,$8000       // Test Negative MSB / Carry
  srl t1,8
  srl t2,t0,16
  or t1,t2
  andi s5,~(N_FLAG+C_FLAG) // P_REG: N/C Flag Reset
  or s5,t1               // P_REG: N/C Flag = Result MSB / Carry
  andi t0,$FFFF
  beqz t0,ASLDPXM0X0     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ASLDPXM0X0:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

align(256)
  // $17 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $18 CLC                     Clear Carry Flag
  andi s5,~C_FLAG        // P_REG: C Flag Reset
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $19 ORA   nnnn,Y            OR Accumulator With Memory Absolute Indexed, Y
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // A_REG: OR With DB_REG:MEM+Y_REG (16-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s2
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  or s0,t0
  andi t0,s0,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,ORAABSYM0X0    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ORAABSYM0X0:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $1A INA                     Increment Accumulator
  addiu s0,1             // A_REG: Set To Accumulator++ (16-Bit)
  andi s0,$FFFF
  andi t0,s0,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,INAM0X0        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  INAM0X0:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $1B TCS                     Transfer Accumulator To Stack Pointer
  andi s4,s0,$FFFF       // S_REG: Set To Accumulator (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $1C TRB   nnnn              Test & Reset Memory Bits Against Accumulator Absolute
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // Load DB_REG:MEM (16-Bit)
  sll t0,s7,16
  addu a2,t0
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  xori t1,s0,$FFFF       // Reset & Store Bits (16-Bit)
  and t1,t0
  sb t1,0(a2)
  srl t1,8
  sb t1,1(a2)
  and t0,s0              // Result AND Accumulator
  beqz t0,TRBABSM0X0     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  TRBABSM0X0:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

align(256)
  // $1D ORA   nnnn,X            OR Accumulator With Memory Absolute Indexed, X
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // A_REG: OR With DB_REG:MEM+X_REG (16-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s1
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  or s0,t0
  andi t0,s0,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,ORAABSXM0X0    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ORAABSXM0X0:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $1E ASL   nnnn,X            Shift Memory Left Absolute Indexed, X
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // Load DB_REG:MEM+X_REG (16-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s1
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  sll t0,1               // DB_REG:MEM+X_REG: << 1 & Store Bits (16-Bit)
  sb t0,0(a2)
  srl t1,t0,8
  sb t1,1(a2)
  andi t1,t0,$8000       // Test Negative MSB / Carry
  srl t1,8
  srl t2,t0,16
  or t1,t2
  andi s5,~(N_FLAG+C_FLAG) // P_REG: N/C Flag Reset
  or s5,t1               // P_REG: N/C Flag = Result MSB / Carry
  andi t0,$FFFF
  beqz t0,ASLABSXM0X0    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ASLABSXM0X0:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,9             // Cycles += 9 (Delay Slot)

align(256)
  // $1F ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $20 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $21 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $22 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $23 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $24 BIT   nn                Test Memory Bits Against Accumulator Direct Page
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // Load D_REG+MEM (16-Bit)
  addu a2,s6
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  andi t1,t0,$C000       // Test Negative MSB / Overflow MSB-1
  srl t1,8
  andi s5,~(N_FLAG+V_FLAG) // P_REG: N/V Flag Reset
  or s5,t1               // P_REG: N/V Flag = Result MSB/MSB-1
  and t0,s0              // Result AND Accumulator
  beqz t0,BITDPM0X0      // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  BITDPM0X0:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $25 AND   nn                AND Accumulator With Memory Direct Page
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // A_REG: AND With D_REG+MEM (16-Bit)
  addu a2,s6
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  and s0,t0
  andi t0,s0,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,ANDDPM0X0      // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ANDDPM0X0:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $26 ROL   nn                Rotate Memory Left Direct Page
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // Load D_REG+MEM (16-Bit)
  addu a2,s6
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  sll t0,1               // D_REG+MEM: Rotate Left & Store Bits (16-Bit)
  andi t1,s5,C_FLAG
  or t0,t1
  sb t0,0(a2)
  srl t1,t0,8
  sb t1,1(a2)
  andi t1,t0,$8000       // Test Negative MSB / Carry
  srl t1,8
  srl t2,t0,16
  or t1,t2
  andi s5,~(N_FLAG+C_FLAG) // P_REG: N/C Flag Reset
  or s5,t1               // P_REG: N/C Flag = Result MSB / Carry
  andi t0,$FFFF
  beqz t0,ROLDPM0X0      // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ROLDPM0X0:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

align(256)
  // $27 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $28 PLP                     Pull Status Flags
  addiu s4,1             // S_REG++ (Increment Stack)
  andi s4,$FFFF
  addu a2,a0,s4          // P_REG = STACK (8-Bit)
  lbu s5,0(a2)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $29 AND   #nnnn             AND Accumulator With Memory Immediate
  addu a2,a0,s3          // A_REG: AND With 16-Bit Immediate
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  and s0,t0
  andi t0,s0,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,ANDIMMM0X0     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ANDIMMM0X0:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $2A ROL A                   Rotate Accumulator Left
  sll s0,1               // A_REG: Rotate Left (16-Bit)
  andi t0,s5,C_FLAG
  or s0,t0
  andi t0,s0,$8000       // Test Negative MSB / Carry
  srl t0,8
  srl t1,s0,16
  or t0,t1
  andi s5,~(N_FLAG+C_FLAG) // P_REG: N/C Flag Reset
  or s5,t0               // P_REG: N/C Flag = Result MSB / Carry
  andi s0,$FFFF
  beqz s0,ROLAM0X0       // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ROLAM0X0:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $2B PLD                     Pull Direct Page Register
  addiu s4,2             // S_REG += 2 (Increment Stack)
  andi s4,$FFFF
  addu a2,a0,s4          // D_REG = STACK (16-Bit)
  lbu t0,0(a2)
  sll t0,8
  lbu s6,-1(a2)
  or s6,t0
  andi t0,s6,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s6,PLDM0X0        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  PLDM0X0:
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $2C BIT   nnnn              Test Memory Bits Against Accumulator Absolute
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // Load DB_REG:MEM (16-Bit)
  sll t0,s7,16
  addu a2,t0
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  andi t1,t0,$C000       // Test Negative MSB / Overflow MSB-1
  srl t1,8
  andi s5,~(N_FLAG+V_FLAG) // P_REG: N/V Flag Reset
  or s5,t1               // P_REG: N/V Flag = Result MSB/MSB-1
  and t0,s0              // Result AND Accumulator
  beqz t0,BITABSM0X0     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  BITABSM0X0:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $2D AND   nnnn              AND Accumulator With Memory Absolute
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // A_REG: AND With DB_REG:MEM (16-Bit)
  sll t0,s7,16
  addu a2,t0
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  and s0,t0
  andi t0,s0,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,ANDABSM0X0     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ANDABSM0X0:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $2E ROL   nnnn              Rotate Memory Left Absolute
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // Load DB_REG:MEM (16-Bit)
  sll t0,s7,16
  addu a2,t0
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  sll t0,1               // DB_REG:MEM: Rotate Left & Store Bits (16-Bit)
  andi t1,s5,C_FLAG
  or t0,t1
  sb t0,0(a2)
  srl t1,t0,8
  sb t1,1(a2)
  andi t1,t0,$8000       // Test Negative MSB / Carry
  srl t1,8
  srl t2,t0,16
  or t1,t2
  andi s5,~(N_FLAG+C_FLAG) // P_REG: N/C Flag Reset
  or s5,t1               // P_REG: N/C Flag = Result MSB / Carry
  andi t0,$FFFF
  beqz t0,ROLABSM0X0     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ROLABSM0X0:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

align(256)
  // $2F ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $30 BMI   nn                Branch IF Minus
  andi t0,s5,N_FLAG      // P_REG: Test N Flag
  beqz t0,BMIM0X0        // IF (N Flag == 0) Plus
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  addu a2,a0,s3          // Load Signed 8-Bit Relative Address
  lb t0,-1(a2)
  add s3,t0              // PC_REG: Set To 8-Bit Relative Address
  addiu v0,1             // Cycles++
  BMIM0X0:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $31 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $32 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $33 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $34 BIT   nn,X              Test Memory Bits Against Accumulator Direct Page Indexed, X
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // Load D_REG+MEM+X_REG (16-Bit)
  addu a2,s6
  addu a2,s1
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  andi t1,t0,$C000       // Test Negative MSB / Overflow MSB-1
  srl t1,8
  andi s5,~(N_FLAG+V_FLAG) // P_REG: N/V Flag Reset
  or s5,t1               // P_REG: N/V Flag = Result MSB/MSB-1
  and t0,s0              // Result AND Accumulator
  beqz t0,BITDPXM0X0     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  BITDPXM0X0:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $35 AND   nn,X              AND Accumulator With Memory Direct Page Indexed, X
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // A_REG: AND With D_REG+MEM+X_REG (16-Bit)
  addu a2,s6
  addu a2,s1
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  and s0,t0
  andi t0,s0,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,ANDDPXM0X0     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ANDDPXM0X0:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $36 ROL   nn,X              Rotate Memory Left Direct Page Indexed, X
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // Load D_REG+MEM+X_REG (16-Bit)
  addu a2,s6
  addu a2,s1
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  sll t0,1               // D_REG+MEM+X_REG: Rotate Left & Store Bits (16-Bit)
  andi t1,s5,C_FLAG
  or t0,t1
  sb t0,0(a2)
  srl t1,t0,8
  sb t1,1(a2)
  andi t1,t0,$8000       // Test Negative MSB / Carry
  srl t1,8
  srl t2,t0,16
  or t1,t2
  andi s5,~(N_FLAG+C_FLAG) // P_REG: N/C Flag Reset
  or s5,t1               // P_REG: N/C Flag = Result MSB / Carry
  andi t0,$FFFF
  beqz t0,ROLDPXM0X0     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ROLDPXM0X0:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

align(256)
  // $37 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $38 SEC                     Set Carry Flag
  ori s5,C_FLAG          // P_REG: C Flag Set
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $39 AND   nnnn,Y            AND Accumulator With Memory Absolute Indexed, Y
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // A_REG: AND With DB_REG:MEM+Y_REG (16-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s2
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  and s0,t0
  andi t0,s0,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,ANDABSYM0X0    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ANDABSYM0X0:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $3A DEA                     Decrement Accumulator
  subiu s0,1             // A_REG: Set To Accumulator-- (16-Bit)
  andi s0,$FFFF
  andi t0,s0,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,DEAM0X0        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  DEAM0X0:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $3B TSC                     Transfer Stack Pointer To 16-Bit Accumulator
  andi s0,s4,$FFFF       // A_REG: Set To Stack Pointer (16-Bit)
  andi t0,s0,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,TSCM0X0        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  TSCM0X0:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $3C BIT   nnnn,X            Test Memory Bits Against Accumulator Absolute Indexed, X
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // Load DB_REG:MEM+X_REG (16-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s1
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  andi t1,t0,$C000       // Test Negative MSB / Overflow MSB-1
  srl t1,8
  andi s5,~(N_FLAG+V_FLAG) // P_REG: N/V Flag Reset
  or s5,t1               // P_REG: N/V Flag = Result MSB/MSB-1
  and t0,s0              // Result AND Accumulator
  beqz t0,BITABSXM0X0    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  BITABSXM0X0:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $3D AND   nnnn,X            AND Accumulator With Memory Absolute Indexed, X
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // A_REG: AND With DB_REG:MEM+X_REG (16-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s1
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  and s0,t0
  andi t0,s0,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,ANDABSXM0X0    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ANDABSXM0X0:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $3E ROL   nnnn,X            Rotate Memory Left Absolute Indexed, X
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // Load DB_REG:MEM+X_REG (16-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s1
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  sll t0,1               // DB_REG:MEM+X_REG: Rotate Left & Store Bits (16-Bit)
  andi t1,s5,C_FLAG
  or t0,t1
  sb t0,0(a2)
  srl t1,t0,8
  sb t1,1(a2)
  andi t1,t0,$8000       // Test Negative MSB / Carry
  srl t1,8
  srl t2,t0,16
  or t1,t2
  andi s5,~(N_FLAG+C_FLAG) // P_REG: N/C Flag Reset
  or s5,t1               // P_REG: N/C Flag = Result MSB / Carry
  andi t0,$FFFF
  beqz t0,ROLABSXM0X0    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ROLABSXM0X0:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,9             // Cycles += 9 (Delay Slot)

align(256)
  // $3F ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $40 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $41 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $42 WDM   #nn               Reserved For Future Expansion
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $43 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $44 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $45 EOR   nn                Exclusive-OR Accumulator With Memory Direct Page
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // A_REG: Exclusive-OR With D_REG+MEM (16-Bit)
  addu a2,s6
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  xor s0,t0
  andi t0,s0,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,EORDPM0X0      // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  EORDPM0X0:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $46 LSR   nn                Logical Shift Memory Right Direct Page
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // Load D_REG+MEM (16-Bit)
  addu a2,s6
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  andi t1,t0,1           // Test Negative MSB / Carry
  andi s5,~(N_FLAG+C_FLAG) // P_REG: N/C Flag Reset
  or s5,t1               // P_REG: N/C Flag = Result MSB / Carry
  srl t0,1               // D_REG+MEM: >> 1 & Store Bits (16-Bit)
  sb t0,0(a2)
  srl t1,t0,8
  sb t1,1(a2)
  beqz t0,LSRDPM0X0      // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  LSRDPM0X0:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

align(256)
  // $47 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $48 PHA                     Push Accumulator
  addu a2,a0,s4          // STACK = A_REG (16-Bit)
  sb s0,-1(a2)
  srl t0,s0,8
  sb t0,0(a2)
  subiu s4,2             // S_REG -= 2 (Decrement Stack)
  andi s4,$FFFF
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $49 EOR   #nnnn             Exclusive-OR Accumulator With Memory Immediate
  addu a2,a0,s3          // A_REG: Exclusive-OR With 16-Bit Immediate
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  xor s0,t0
  andi t0,s0,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,EORIMMM0X0     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  EORIMMM0X0:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $4A LSR A                   Logical Shift Accumulator Right
  andi t0,s0,1           // Test Negative MSB / Carry
  andi s5,~(N_FLAG+C_FLAG) // P_REG: N/C Flag Reset
  or s5,t0               // P_REG: N/C Flag = Result MSB / Carry
  srl s0,1               // A_REG: >> 1 (16-Bit)
  beqz s0,LSRAM0X0       // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  LSRAM0X0:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $4B PHK                     Push Program Bank Register
  addu a2,a0,s4          // STACK = PB_REG (8-Bit)
  sb s8,0(a2)
  subiu s4,1             // S_REG-- (Decrement Stack)
  andi s4,$FFFF
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $4C JMP   nnnn              Jump Absolute
  addu a2,a0,s3          // PC_REG: Set To 16-Bit Absolute Address
  lbu t0,1(a2)
  sll t0,8
  lbu s3,0(a2)
  or s3,t0
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $4D EOR   nnnn              Exclusive-OR Accumulator With Memory Absolute
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // A_REG: Exclusive-OR With DB_REG:MEM (16-Bit)
  sll t0,s7,16
  addu a2,t0
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  xor s0,t0
  andi t0,s0,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,EORABSM0X0     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  EORABSM0X0:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $4E LSR   nnnn              Logical Shift Memory Right Absolute
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // Load DB_REG:MEM (16-Bit)
  sll t0,s7,16
  addu a2,t0
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  andi t1,t0,1           // Test Negative MSB / Carry
  andi s5,~(N_FLAG+C_FLAG) // P_REG: N/C Flag Reset
  or s5,t1               // P_REG: N/C Flag = Result MSB / Carry
  srl t0,1               // DB_REG:MEM: >> 1 & Store Bits (16-Bit)
  sb t0,0(a2)
  srl t1,t0,8
  sb t1,1(a2)
  beqz t0,LSRABSM0X0     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  LSRABSM0X0:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

align(256)
  // $4F ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $50 BVC   nn                Branch IF Overflow Clear
  andi t0,s5,V_FLAG      // P_REG: Test V Flag
  bnez t0,BVCM0X0        // IF (V Flag != 0) Overflow Set
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  addu a2,a0,s3          // Load Signed 8-Bit Relative Address
  lb t0,-1(a2)
  add s3,t0              // PC_REG: Set To 8-Bit Relative Address
  addiu v0,1             // Cycles++
  BVCM0X0:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $51 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $52 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $53 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $54 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $55 EOR   nn,X              Exclusive-OR Accumulator With Memory Direct Page Indexed, X
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // A_REG: Exclusive-OR With D_REG+MEM+X_REG (16-Bit)
  addu a2,s6
  addu a2,s1
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  xor s0,t0
  andi t0,s0,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,EORDPXM0X0     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  EORDPXM0X0:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $56 LSR   nn,X              Logical Shift Memory Right Direct Page Indexed, X
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // Load D_REG+MEM+X_REG (16-Bit)
  addu a2,s6
  addu a2,s1
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  andi t1,t0,1           // Test Negative MSB / Carry
  andi s5,~(N_FLAG+C_FLAG) // P_REG: N/C Flag Reset
  or s5,t1               // P_REG: N/C Flag = Result MSB / Carry
  srl t0,1               // D_REG+MEM+X_REG: >> 1 & Store Bits (16-Bit)
  sb t0,0(a2)
  srl t1,t0,8
  sb t1,1(a2)
  beqz t0,LSRDPXM0X0     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  LSRDPXM0X0:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

align(256)
  // $57 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $58 CLI                     Clear Interrupt Disable Flag
  andi s5,~I_FLAG        // P_REG: I Flag Reset
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $59 EOR   nnnn,Y            Exclusive-OR Accumulator With Memory Absolute Indexed, Y
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // A_REG: Exclusive-OR With DB_REG:MEM+Y_REG (16-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s2
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  xor s0,t0
  andi t0,s0,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,EORABSYM0X0    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  EORABSYM0X0:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $5A PHY                     Push Index Register Y
  addu a2,a0,s4          // STACK = Y_REG (16-Bit)
  sb s2,-1(a2)
  srl t0,s2,8
  sb t0,0(a2)
  subiu s4,2             // S_REG -= 2 (Decrement Stack)
  andi s4,$FFFF
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $5B TCD                     Transfer 16-Bit Accumulator To Direct Page Register
  andi s6,s0,$FFFF       // D_REG: Set To 16-Bit Accumulator (16-Bit)
  andi t0,s6,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s6,TCDM0X0        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  TCDM0X0:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $5C JML   nnnnnn            Jump Absolute Long
  addu a2,a0,s3          // PC_REG: Set To 16-Bit Absolute Address
  lbu t0,1(a2)
  sll t0,8
  lbu s3,0(a2)
  or s3,t0
  lbu s8,2(a2)           // PB_REG: Set To Long Bank Address
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $5D EOR   nnnn,X            Exclusive-OR Accumulator With Memory Absolute Indexed, X
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // A_REG: Exclusive-OR With DB_REG:MEM+X_REG (16-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s1
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  xor s0,t0
  andi t0,s0,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,EORABSXM0X0    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  EORABSXM0X0:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $5E LSR   nnnn,X            Logical Shift Memory Right Absolute Indexed, X
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // Load DB_REG:MEM+X_REG (16-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s1
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  andi t1,t0,1           // Test Negative MSB / Carry
  andi s5,~(N_FLAG+C_FLAG) // P_REG: N/C Flag Reset
  or s5,t1               // P_REG: N/C Flag = Result MSB / Carry
  srl t0,1               // DB_REG:MEM+X_REG: >> 1 & Store Bits (16-Bit)
  sb t0,0(a2)
  srl t1,t0,8
  sb t1,1(a2)
  beqz t0,LSRABSXM0X0    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  LSRABSXM0X0:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,9             // Cycles += 9 (Delay Slot)

align(256)
  // $5F ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $60 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $61 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $62 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $63 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $64 STZ   nn                Store Zero To Memory Direct Page
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // D_REG+MEM: Set To Zero (16-Bit)
  addu a2,s6
  sb r0,0(a2)
  sb r0,1(a2)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $65 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $66 ROR   nn                Rotate Memory Right Direct Page
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // Load D_REG+MEM (16-Bit)
  addu a2,s6
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  andi t1,t0,1           // Test Negative MSB / Carry
  andi t2,s5,C_FLAG
  sll t2,7
  or t1,t2
  andi s5,~(N_FLAG+C_FLAG) // P_REG: N/C Flag Reset
  or s5,t1               // P_REG: N/C Flag = Result MSB / Carry
  srl t0,1               // D_REG+MEM: Rotate Right & Store Bits (16-Bit)
  sll t2,8
  or t0,t2
  sb t0,0(a2)
  srl t1,t0,8
  sb t1,1(a2)
  beqz t0,RORDPM0X0      // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  RORDPM0X0:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

align(256)
  // $67 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $68 PLA                     Pull Accumulator
  addiu s4,2             // S_REG += 2 (Increment Stack)
  andi s4,$FFFF
  addu a2,a0,s4          // A_REG = STACK (16-Bit)
  lbu t0,0(a2)
  sll t0,8
  lbu s0,-1(a2)
  or s0,t0
  andi t0,s0,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,PLAM0X0        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  PLAM0X0:
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $69 ADC   #nnnn             ADD With Carry Immediate
  addu a2,a0,s3          // A_REG: ADD With Carry 16-Bit Immediate
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  add s0,t0
  andi t0,s5,C_FLAG
  add s0,t0
  andi t0,s0,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  andi s0,$FFFF
  beqz s0,ADCIMMM0X0     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ADCIMMM0X0:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $6A ROR A                   Rotate Accumulator Right
  andi t0,s0,1           // Test Negative MSB / Carry
  andi t1,s5,C_FLAG
  sll t1,7
  or t0,t1
  andi s5,~(N_FLAG+C_FLAG) // P_REG: N/C Flag Reset
  or s5,t0               // P_REG: N/C Flag = Result MSB / Carry
  srl s0,1               // A_REG: Rotate Right (16-Bit)
  sll t1,8
  or s0,t1
  beqz s0,RORAM0X0       // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  RORAM0X0:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $6B ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $6C ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $6D ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $6E ROR   nnnn              Rotate Memory Right Absolute
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // Load DB_REG:MEM (16-Bit)
  sll t0,s7,16
  addu a2,t0
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  andi t1,t0,1           // Test Negative MSB / Carry
  andi t2,s5,C_FLAG
  sll t2,7
  or t1,t2
  andi s5,~(N_FLAG+C_FLAG) // P_REG: N/C Flag Reset
  or s5,t1               // P_REG: N/C Flag = Result MSB / Carry
  srl t0,1               // DB_REG:MEM: Rotate Right & Store Bits (16-Bit)
  sll t2,8
  or t0,t2
  sb t0,0(a2)
  srl t1,t0,8
  sb t1,1(a2)
  beqz t0,RORABSM0X0     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  RORABSM0X0:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

align(256)
  // $6F ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $70 BVS   nn                Branch IF Overflow Set
  andi t0,s5,V_FLAG      // P_REG: Test V Flag
  beqz t0,BVSM0X0        // IF (V Flag == 0) Overflow Clear
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  addu a2,a0,s3          // Load Signed 8-Bit Relative Address
  lb t0,-1(a2)
  add s3,t0              // PC_REG: Set To 8-Bit Relative Address
  addiu v0,1             // Cycles++
  BVSM0X0:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $71 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $72 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $73 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $74 STZ   nn,X              Store Zero To Memory Direct Page Indexed, X
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu t0,s1
  addu a2,a0,t0          // D_REG+MEM+X_REG: Set To Zero (16-Bit)
  addu a2,s6
  sb r0,0(a2)
  sb r0,1(a2)

  la sp,StoreWord        // Store Word
  jalr sp,sp
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)

  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $75 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $76 ROR   nn,X              Rotate Memory Right Direct Page Indexed, X
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // Load D_REG+MEM+X_REG (16-Bit)
  addu a2,s6
  addu a2,s1
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  andi t1,t0,1           // Test Negative MSB / Carry
  andi t2,s5,C_FLAG
  sll t2,7
  or t1,t2
  andi s5,~(N_FLAG+C_FLAG) // P_REG: N/C Flag Reset
  or s5,t1               // P_REG: N/C Flag = Result MSB / Carry
  srl t0,1               // D_REG+MEM+X_REG: Rotate Right & Store Bits (16-Bit)
  sll t2,8
  or t0,t2
  sb t0,0(a2)
  srl t1,t0,8
  sb t1,1(a2)
  beqz t0,RORDPXM0X0     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  RORDPXM0X0:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

align(256)
  // $77 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $78 SEI                     Set Interrupt Disable Flag
  ori s5,I_FLAG          // P_REG: I Flag Set
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $79 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $7A PLY                     Pull Index Register Y From Stack
  addiu s4,2             // S_REG += 2 (Increment Stack)
  andi s4,$FFFF
  addu a2,a0,s4          // Y_REG = STACK (16-Bit)
  lbu t0,0(a2)
  sll t0,8
  lbu s2,-1(a2)
  or s2,t0
  andi t0,s2,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s2,PLYM0X0        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  PLYM0X0:
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $7B TDC                     Transfer Direct Page Register To 16-Bit Accumulator
  andi s0,s6,$FFFF       // A_REG: Set To Direct Page Register (16-Bit)
  andi t0,s0,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,TDCM0X0        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  TDCM0X0:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $7C ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $7D ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $7E ROR   nnnn,X            Rotate Memory Right Absolute Indexed, X
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // Load DB_REG:MEM+X_REG (16-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s1
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  andi t1,t0,1           // Test Negative MSB / Carry
  andi t2,s5,C_FLAG
  sll t2,7
  or t1,t2
  andi s5,~(N_FLAG+C_FLAG) // P_REG: N/C Flag Reset
  or s5,t1               // P_REG: N/C Flag = Result MSB / Carry
  srl t0,1               // DB_REG:MEM+X_REG: Rotate Right & Store Bits (16-Bit)
  sll t2,8
  or t0,t2
  sb t0,0(a2)
  srl t1,t0,8
  sb t1,1(a2)
  beqz t0,RORABSXM0X0    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  RORABSXM0X0:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,9             // Cycles += 9 (Delay Slot)

align(256)
  // $7F ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $80 BRA   nn                Branch Always
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  addu a2,a0,s3          // Load Signed 8-Bit Relative Address
  lb t0,-1(a2)
  add s3,t0              // PC_REG: Set To 8-Bit Relative Address
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $81 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $82 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $83 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $84 STY   nn                Store Index Register Y To Memory Direct Page
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // D_REG+MEM: Set To Index Register Y (16-Bit)
  addu a2,s6
  sb s2,0(a2)
  srl t0,s2,8
  sb t0,1(a2)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $85 STA   nn                Store Accumulator To Memory Direct Page
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // D_REG+MEM: Set To Accumulator (16-Bit)
  addu a2,s6
  sb s0,0(a2)
  srl t0,s0,8
  sb t0,1(a2)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $86 STX   nn                Store Index Register X To Memory Direct Page
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // D_REG+MEM: Set To Index Register X (16-Bit)
  addu a2,s6
  sb s1,0(a2)
  srl t0,s1,8
  sb t0,1(a2)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $87 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $88 DEY                     Decrement Index Register Y
  subiu s2,1             // Y_REG: Set To Index Register Y-- (16-Bit)
  andi s2,$FFFF
  andi t0,s2,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s2,DEYM0X0        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  DEYM0X0:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $89 BIT   #nnnn             Test Memory Bits Against Accumulator Immediate
  addu a2,a0,s3          // Load 16-Bit Immediate
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  and t0,s0              // Test Result AND Accumulator
  beqz t0,BITIMMM0X0     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  BITIMMM0X0:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $8A TXA                     Transfer Index Register X To Accumulator
  andi s0,s1,$FFFF       // A_REG: Set To Index Register X (16-Bit)
  andi t0,s0,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,TXAM0X0        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  TXAM0X0:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $8B PHB                     Push Data Bank Register
  addu a2,a0,s4          // STACK = DB_REG (8-Bit)
  sb s7,0(a2)
  subiu s4,1             // S_REG-- (Decrement Stack)
  andi s4,$FFFF
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $8C STY   nnnn              Store Index Register Y To Memory Absolute
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // DB_REG:MEM: Set To Index Register Y (16-Bit)
  sll t1,s7,16
  addu a2,t1
  sb s2,0(a2)
  srl t1,s2,8
  sb t1,1(a2)

  la sp,StoreWord        // Store Word
  jalr sp,sp
  addiu s3,2             // PC_REG += 2 (Increment Program Counter) (Delay Slot)

  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $8D STA   nnnn              Store Accumulator To Memory Absolute
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // DB_REG:MEM: Set To Accumulator (16-Bit)
  sll t1,s7,16
  addu a2,t1
  sb s0,0(a2)
  srl t1,s0,8
  sb t1,1(a2)

  la sp,StoreWord        // Store Word
  jalr sp,sp
  addiu s3,2             // PC_REG += 2 (Increment Program Counter) (Delay Slot)

  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $8E STX   nnnn              Store Index Register X To Memory Absolute
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // DB_REG:MEM: Set To Index Register X (16-Bit)
  sll t1,s7,16
  addu a2,t1
  sb s1,0(a2)
  srl t1,s1,8
  sb t1,1(a2)

  la sp,StoreWord        // Store Word
  jalr sp,sp
  addiu s3,2             // PC_REG += 2 (Increment Program Counter) (Delay Slot)

  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $8F ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $90 BCC   nn                Branch IF Carry Clear
  andi t0,s5,C_FLAG      // P_REG: Test C Flag
  bnez t0,BCCM0X0        // IF (C Flag != 0) Carry Set
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  addu a2,a0,s3          // Load Signed 8-Bit Relative Address
  lb t0,-1(a2)
  add s3,t0              // PC_REG: Set To 8-Bit Relative Address
  addiu v0,1             // Cycles++
  BCCM0X0:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $91 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $92 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $93 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $94 STY   nn,X              Store Index Register Y To Memory Direct Page Indexed, X
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu t0,s1
  addu a2,a0,t0          // D_REG+MEM+X_REG: Set To Index Register Y (16-Bit)
  addu a2,s6
  sb s2,0(a2)
  srl t1,s2,8
  sb t1,1(a2)

  la sp,StoreWord        // Store Word
  jalr sp,sp
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)

  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $95 STA   nn,X              Store Accumulator To Memory Direct Page Indexed, X
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu t0,s1
  addu a2,a0,t0          // D_REG+MEM+X_REG: Set To Accumulator (16-Bit)
  addu a2,s6
  sb s0,0(a2)
  srl t1,s0,8
  sb t1,1(a2)

  la sp,StoreWord        // Store Word
  jalr sp,sp
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)

  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $96 STX   nn,Y              Store Index Register X To Memory Direct Page Indexed, Y
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu t0,s2
  addu a2,a0,t0          // D_REG+MEM+Y_REG: Set To Index Register X (16-Bit)
  addu a2,s6
  sb s1,0(a2)
  srl t1,s1,8
  sb t1,1(a2)

  la sp,StoreWord        // Store Word
  jalr sp,sp
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)

  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $97 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $98 TYA                     Transfer Index Register Y To Accumulator
  andi s0,s2,$FFFF       // A_REG: Set To Index Register Y (16-Bit)
  andi t0,s0,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,TYAM0X0        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  TYAM0X0:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $99 STA   nnnn,Y            Store Accumulator To Memory Absolute Indexed, Y
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu t0,s2
  addu a2,a0,t0          // DB_REG:MEM+Y_REG: Set To Accumulator (16-Bit)
  sll t1,s7,16
  addu a2,t1
  sb s0,0(a2)
  srl t1,s0,8
  sb t1,1(a2)

  la sp,StoreWord        // Store Word
  jalr sp,sp
  addiu s3,2             // PC_REG += 2 (Increment Program Counter) (Delay Slot)

  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $9A TXS                     Transfer Index Register X To Stack Pointer
  andi s4,s1,$FFFF       // S_REG: Set To Index Register X (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $9B TXY                     Transfer Index Register X To Y
  andi s2,s1,$FFFF       // Y_REG: Set To Index Register X (16-Bit)
  andi t0,s2,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s2,TXYM0X0        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  TXYM0X0:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $9C STZ   nnnn              Store Zero To Memory Absolute
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // DB_REG:MEM: Set To Zero (16-Bit)
  sll t1,s7,16
  addu a2,t1
  sb r0,0(a2)
  sb r0,1(a2)

  la sp,StoreWord        // Store Word
  jalr sp,sp
  addiu s3,2             // PC_REG += 2 (Increment Program Counter) (Delay Slot)

  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $9D STA   nnnn,X            Store Accumulator To Memory Absolute Indexed, X
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu t0,s1
  addu a2,a0,t0          // DB_REG:MEM+X_REG: Set To Accumulator (16-Bit)
  sll t1,s7,16
  addu a2,t1
  sb s0,0(a2)
  srl t1,s0,8
  sb t1,1(a2)

  la sp,StoreWord        // Store Word
  jalr sp,sp
  addiu s3,2             // PC_REG += 2 (Increment Program Counter) (Delay Slot)

  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $9E STZ   nnnn,X            Store Zero To Memory Absolute Indexed, X
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu t0,s1
  addu a2,a0,t0          // DB_REG:MEM+X_REG: Set To Zero (16-Bit)
  sll t1,s7,16
  addu a2,t1
  sb r0,0(a2)
  sb r0,1(a2)

  la sp,StoreWord        // Store Word
  jalr sp,sp
  addiu s3,2             // PC_REG += 2 (Increment Program Counter) (Delay Slot)

  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $9F ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $A0 LDY   #nnnn             Load Index Register Y From Memory Immediate
  addu a2,a0,s3          // Y_REG: Set To 16-Bit Immediate
  lbu t0,1(a2)
  sll t0,8
  lbu s2,0(a2)
  or s2,t0
  andi t0,s2,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s2,LDYIMMM0X0     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  LDYIMMM0X0:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $A1 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $A2 LDX   #nnnn             Load Index Register X From Memory Immediate
  addu a2,a0,s3          // X_REG: Set To 16-Bit Immediate
  lbu t0,1(a2)
  sll t0,8
  lbu s1,0(a2)
  or s1,t0
  andi t0,s1,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s1,LDXIMMM0X0     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  LDXIMMM0X0:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $A3 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $A4 LDY   nn                Load Index Register Y From Memory Direct Page
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // Y_REG: Set To D_REG+MEM (16-Bit)
  addu a2,s6
  lbu t0,1(a2)
  sll t0,8
  lbu s2,0(a2)
  or s2,t0
  andi t0,s2,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s2,LDYDPM0X0      // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  LDYDPM0X0:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $A5 LDA   nn                Load Accumulator From Memory Direct Page
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // A_REG: Set To D_REG+MEM (16-Bit)
  addu a2,s6
  lbu t0,1(a2)
  sll t0,8
  lbu s0,0(a2)
  or s0,t0
  andi t0,s0,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,LDADPM0X0      // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  LDADPM0X0:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $A6 LDX   nn                Load Index Register X From Memory Direct Page
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // X_REG: Set To D_REG+MEM (16-Bit)
  addu a2,s6
  lbu t0,1(a2)
  sll t0,8
  lbu s1,0(a2)
  or s1,t0
  andi t0,s1,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s1,LDXDPM0X0      // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  LDXDPM0X0:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $A7 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $A8 TAY                     Transfer Accumulator To Index Register Y
  andi s2,s0,$FFFF       // Y_REG: Set To Accumulator (16-Bit)
  andi t0,s2,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s2,TAYM0X0        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  TAYM0X0:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $A9 LDA   #nnnn             Load Accumulator From Memory Immediate
  addu a2,a0,s3          // A_REG: Set To 16-Bit Immediate
  lbu t0,1(a2)
  sll t0,8
  lbu s0,0(a2)
  or s0,t0
  andi t0,s0,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,LDAIMMM0X0     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  LDAIMMM0X0:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $AA TAX                     Transfer Accumulator To Index Register X
  andi s1,s0,$FFFF       // X_REG: Set To Accumulator (16-Bit)
  andi t0,s1,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s1,TAXM0X0        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  TAXM0X0:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $AB PLB                     Pull Data Bank Register
  addiu s4,1             // S_REG++ (Increment Stack)
  andi s4,$FFFF
  addu a2,a0,s4          // DB_REG = STACK (8-Bit)
  lbu s7,0(a2)
  andi t0,s7,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s7,PLBM0X0        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  PLBM0X0:
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $AC LDY   nnnn              Load Index Register Y From Memory Absolute
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // Y_REG: Set To DB_REG:MEM (16-Bit)
  sll t0,s7,16
  addu a2,t0
  lbu t0,1(a2)
  sll t0,8
  lbu s2,0(a2)
  or s2,t0
  andi t0,s2,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s2,LDYABSM0X0     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  LDYABSM0X0:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $AD LDA   nnnn              Load Accumulator From Memory Absolute
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // A_REG: Set To DB_REG:MEM (16-Bit)
  sll t0,s7,16
  addu a2,t0
  lbu t0,1(a2)
  sll t0,8
  lbu s0,0(a2)
  or s0,t0
  andi t0,s0,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,LDAABSM0X0     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  LDAABSM0X0:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $AE LDX   nnnn              Load Index Register X From Memory Absolute
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // X_REG: Set To DB_REG:MEM (16-Bit)
  sll t0,s7,16
  addu a2,t0
  lbu t0,1(a2)
  sll t0,8
  lbu s1,0(a2)
  or s1,t0
  andi t0,s1,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s1,LDXABSM0X0     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  LDXABSM0X0:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $AF ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $B0 BCS   nn                Branch IF Carry Set
  andi t0,s5,C_FLAG      // P_REG: Test C Flag
  beqz t0,BCSM0X0        // IF (C Flag == 0) Carry Clear
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  addu a2,a0,s3          // Load Signed 8-Bit Relative Address
  lb t0,-1(a2)
  add s3,t0              // PC_REG: Set To 8-Bit Relative Address
  addiu v0,1             // Cycles++
  BCSM0X0:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $B1 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $B2 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $B3 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $B4 LDY   nn,X              Load Index Register Y From Memory Direct Page Indexed, X
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // Y_REG: Set To D_REG+MEM+X_REG (16-Bit)
  addu a2,s6
  addu a2,s1
  lbu t0,1(a2)
  sll t0,8
  lbu s2,0(a2)
  or s2,t0
  andi t0,s2,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s2,LDYDPXM0X0     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  LDYDPXM0X0:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $B5 LDA   nn,X              Load Accumulator From Memory Direct Page Indexed, X
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // A_REG: Set To D_REG+MEM+X_REG (16-Bit)
  addu a2,s6
  addu a2,s1
  lbu t0,1(a2)
  sll t0,8
  lbu s0,0(a2)
  or s0,t0
  andi t0,s0,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,LDADPXM0X0     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  LDADPXM0X0:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $B6 LDX   nn,Y              Load Index Register X From Memory Direct Page Indexed, Y
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // X_REG: Set To D_REG+MEM+Y_REG (16-Bit)
  addu a2,s6
  addu a2,s2
  lbu t0,1(a2)
  sll t0,8
  lbu s1,0(a2)
  or s1,t0
  andi t0,s1,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s1,LDXDPYM0X0     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  LDXDPYM0X0:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $B7 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $B8 CLV                     Clear Overflow Flag
  andi s5,~V_FLAG        // P_REG: V Flag Reset
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $B9 LDA   nnnn,Y            Load Accumulator From Memory Absolute Indexed, Y
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // A_REG: Set To DB_REG:MEM+Y_REG (16-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s2
  lbu t0,1(a2)
  sll t0,8
  lbu s0,0(a2)
  or s0,t0
  andi t0,s0,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,LDAABSYM0X0    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  LDAABSYM0X0:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $BA TSX                     Transfer Stack Pointer To Index Register X
  andi s1,s4,$FFFF       // X_REG: Set To Stack Pointer (16-Bit)
  andi t0,s1,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s1,TSXM0X0        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  TSXM0X0:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $BB TYX                     Transfer Index Register Y To X
  andi s1,s2,$FFFF       // X_REG: Set To Index Register Y (16-Bit)
  andi t0,s1,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s1,TYXM0X0        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  TYXM0X0:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $BC LDY   nnnn,X            Load Index Register Y From Memory Absolute Indexed, X
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // Y_REG: Set To DB_REG:MEM+X_REG (16-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s1
  lbu t0,1(a2)
  sll t0,8
  lbu s2,0(a2)
  or s2,t0
  andi t0,s2,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s2,LDYABSXM0X0    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  LDYABSXM0X0:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $BD LDA   nnnn,X            Load Accumulator From Memory Absolute Indexed, X
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // A_REG: Set To DB_REG:MEM+X_REG (16-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s1
  lbu t0,1(a2)
  sll t0,8
  lbu s0,0(a2)
  or s0,t0
  andi t0,s0,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,LDAABSXM0X0    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  LDAABSXM0X0:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $BE LDX   nnnn,Y            Load Index Register X From Memory Absolute Indexed, Y
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // X_REG: Set To DB_REG:MEM+Y_REG (16-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s2
  lbu t0,1(a2)
  sll t0,8
  lbu s1,0(a2)
  or s1,t0
  andi t0,s1,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s1,LDXABSYM0X0    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  LDXABSYM0X0:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $BF ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $C0 CPY   #nnnn             Compare Index Register Y With Memory Immediate
  addu a2,a0,s3          // Y_REG: Compare With 16-Bit Immediate
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  blt s2,t0,CPYIMMM0X0C  // IF (Y_REG < Immediate) C Flag Reset
  andi s5,~C_FLAG        // P_REG: C Flag Reset (Delay Slot)
  ori s5,C_FLAG          // P_REG: C Flag Set
  CPYIMMM0X0C:
  subu t0,s2,t0
  andi t1,t0,$8000       // Test Negative MSB
  srl t1,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t1               // P_REG: N Flag = Result MSB
  beqz t0,CPYIMMM0X0Z    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  CPYIMMM0X0Z:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $C1 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $C2 REP   #nn               Reset Status Bits
  addu a2,a0,s3          // Load 8-Bit Immediate
  lbu t0,0(a2)           // Reset Bits
  xori t0,$FF            // Convert 8-Bit Immediate To Reset Bits
  ori t0,E_FLAG          // Preserve Emulation Flag
  and s5,t0              // P_REG: 8-Bit Immediate Flags Reset
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $C3 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $C4 CPY   nn                Compare Index Register Y With Memory Direct Page
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // Y_REG: Compare With D_REG+MEM (16-Bit)
  addu a2,s6
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  blt s2,t0,CPYDPM0X0C   // IF (Y_REG < Immediate) C Flag Reset
  andi s5,~C_FLAG        // P_REG: C Flag Reset (Delay Slot)
  ori s5,C_FLAG          // P_REG: C Flag Set
  CPYDPM0X0C:
  subu t0,s2,t0
  andi t1,t0,$8000       // Test Negative MSB
  srl t1,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t1               // P_REG: N Flag = Result MSB
  beqz t0,CPYDPM0X0Z     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  CPYDPM0X0Z:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $C5 CMP   nn                Compare Accumulator With Memory Direct Page
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // A_REG: Compare With D_REG+MEM (16-Bit)
  addu a2,s6
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  blt s0,t0,CMPDPM0X0C   // IF (A_REG < Immediate) C Flag Reset
  andi s5,~C_FLAG        // P_REG: C Flag Reset (Delay Slot)
  ori s5,C_FLAG          // P_REG: C Flag Set
  CMPDPM0X0C:
  subu t0,s0,t0
  andi t1,t0,$8000       // Test Negative MSB
  srl t1,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t1               // P_REG: N Flag = Result MSB
  beqz t0,CMPDPM0X0Z     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  CMPDPM0X0Z:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $C6 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $C7 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $C8 INY                     Increment Index Register Y
  addiu s2,1             // Y_REG: Set To Index Register Y++ (16-Bit)
  andi s2,$FFFF
  andi t0,s2,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s2,INYM0X0        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  INYM0X0:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $C9 CMP   #nnnn             Compare Accumulator With Memory Immediate
  addu a2,a0,s3          // A_REG: Compare With 16-Bit Immediate
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  blt s0,t0,CMPIMMM0X0C  // IF (A_REG < Immediate) C Flag Reset
  andi s5,~C_FLAG        // P_REG: C Flag Reset (Delay Slot)
  ori s5,C_FLAG          // P_REG: C Flag Set
  CMPIMMM0X0C:
  subu t0,s0,t0
  andi t1,t0,$8000       // Test Negative MSB
  srl t1,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t1               // P_REG: N Flag = Result MSB
  beqz t0,CMPIMMM0X0Z    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  CMPIMMM0X0Z:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $CA DEX                     Decrement Index Register X
  subiu s1,1             // X_REG: Set To Index Register X-- (16-Bit)
  andi s1,$FFFF
  andi t0,s1,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s1,DEXM0X0        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  DEXM0X0:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $CB ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $CC CPY   nnnn              Compare Index Register Y With Memory Absolute
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // Y_REG: Compare With DB_REG:MEM (16-Bit)
  sll t0,s7,16
  addu a2,t0
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  blt s2,t0,CPYABSM0X0C  // IF (Y_REG < Immediate) C Flag Reset
  andi s5,~C_FLAG        // P_REG: C Flag Reset (Delay Slot)
  ori s5,C_FLAG          // P_REG: C Flag Set
  CPYABSM0X0C:
  subu t0,s2,t0
  andi t1,t0,$8000       // Test Negative MSB
  srl t1,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t1               // P_REG: N Flag = Result MSB
  beqz t0,CPYABSM0X0Z    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  CPYABSM0X0Z:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $CD CMP   nnnn              Compare Accumulator With Memory Absolute
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // A_REG: Compare With DB_REG:MEM (16-Bit)
  sll t0,s7,16
  addu a2,t0
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  blt s0,t0,CMPABSM0X0C  // IF (A_REG < Immediate) C Flag Reset
  andi s5,~C_FLAG        // P_REG: C Flag Reset (Delay Slot)
  ori s5,C_FLAG          // P_REG: C Flag Set
  CMPABSM0X0C:
  subu t0,s0,t0
  andi t1,t0,$8000       // Test Negative MSB
  srl t1,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t1               // P_REG: N Flag = Result MSB
  beqz t0,CMPABSM0X0Z    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  CMPABSM0X0Z:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $CE ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $CF ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $D0 BNE   nn                Branch IF Not Equal
  andi t0,s5,Z_FLAG      // P_REG: Test Z Flag
  bnez t0,BNEM0X0        // IF (Z Flag != 0) Equal
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  addu a2,a0,s3          // Load Signed 8-Bit Relative Address
  lb t0,-1(a2)
  add s3,t0              // PC_REG: Set To 8-Bit Relative Address
  addiu v0,1             // Cycles++
  BNEM0X0:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $D1 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $D2 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $D3 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $D4 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $D5 CMP   nn,X              Compare Accumulator With Memory Direct Page Indexed, X
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // A_REG: Compare With D_REG+MEM+X_REG (16-Bit)
  addu a2,s6
  addu a2,s1
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  blt s0,t0,CMPDPXM0X0C  // IF (A_REG < Immediate) C Flag Reset
  andi s5,~C_FLAG        // P_REG: C Flag Reset (Delay Slot)
  ori s5,C_FLAG          // P_REG: C Flag Set
  CMPDPXM0X0C:
  subu t0,s0,t0
  andi t1,t0,$8000       // Test Negative MSB
  srl t1,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t1               // P_REG: N Flag = Result MSB
  beqz t0,CMPDPXM0X0Z    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  CMPDPXM0X0Z:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $D6 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $D7 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $D8 CLD                     Clear Decimal Mode Flag
  andi s5,~D_FLAG        // P_REG: D Flag Reset
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $D9 CMP   nnnn,Y            Compare Accumulator With Memory Absolute Indexed, Y
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // A_REG: Compare With DB_REG:MEM+Y_REG (16-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s2
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  blt s0,t0,CMPABSYM0X0C // IF (A_REG < Immediate) C Flag Reset
  andi s5,~C_FLAG        // P_REG: C Flag Reset (Delay Slot)
  ori s5,C_FLAG          // P_REG: C Flag Set
  CMPABSYM0X0C:
  subu t0,s0,t0
  andi t1,t0,$8000       // Test Negative MSB
  srl t1,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t1               // P_REG: N Flag = Result MSB
  beqz t0,CMPABSYM0X0Z   // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  CMPABSYM0X0Z:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $DA PHX                     Push Index Register X
  addu a2,a0,s4          // STACK = X_REG (16-Bit)
  sb s1,-1(a2)
  srl t0,s1,8
  sb t0,0(a2)
  subiu s4,2             // S_REG -= 2 (Decrement Stack)
  andi s4,$FFFF
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $DB ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $DC ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $DD CMP   nnnn,X            Compare Accumulator With Memory Absolute Indexed, X
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // A_REG: Compare With DB_REG:MEM+X_REG (16-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s1
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  blt s0,t0,CMPABSXM0X0C // IF (A_REG < Immediate) C Flag Reset
  andi s5,~C_FLAG        // P_REG: C Flag Reset (Delay Slot)
  ori s5,C_FLAG          // P_REG: C Flag Set
  CMPABSXM0X0C:
  subu t0,s0,t0
  andi t1,t0,$8000       // Test Negative MSB
  srl t1,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t1               // P_REG: N Flag = Result MSB
  beqz t0,CMPABSXM0X0Z   // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  CMPABSXM0X0Z:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $DE ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $DF ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $E0 CPX   #nnnn             Compare Index Register X With Memory Immediate
  addu a2,a0,s3          // X_REG: Compare With 16-Bit Immediate
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  blt s1,t0,CPXIMMM0X0C  // IF (X_REG < Immediate) C Flag Reset
  andi s5,~C_FLAG        // P_REG: C Flag Reset (Delay Slot)
  ori s5,C_FLAG          // P_REG: C Flag Set
  CPXIMMM0X0C:
  subu t0,s1,t0
  andi t1,t0,$8000       // Test Negative MSB
  srl t1,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t1               // P_REG: N Flag = Result MSB
  beqz t0,CPXIMMM0X0Z    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  CPXIMMM0X0Z:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $E1 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $E2 SEP   #nn               Set Status Bits
  addu a2,a0,s3          // Load 8-Bit Immediate
  lbu t0,0(a2)           // Set Bits
  or s5,t0               // P_REG: 8-Bit Immediate Flags Set
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $E3 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $E4 CPX   nn                Compare Index Register X With Memory Direct Page
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // X_REG: Compare With D_REG+MEM (16-Bit)
  addu a2,s6
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  blt s1,t0,CPXDPM0X0C   // IF (X_REG < Immediate) C Flag Reset
  andi s5,~C_FLAG        // P_REG: C Flag Reset (Delay Slot)
  ori s5,C_FLAG          // P_REG: C Flag Set
  CPXDPM0X0C:
  subu t0,s1,t0
  andi t1,t0,$8000       // Test Negative MSB
  srl t1,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t1               // P_REG: N Flag = Result MSB
  beqz t0,CPXDPM0X0Z     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  CPXDPM0X0Z:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $E5 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $E6 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $E7 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $E8 INX                     Increment Index Register X
  addiu s1,1             // X_REG: Set To Index Register X++ (16-Bit)
  andi s1,$FFFF
  andi t0,s1,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s1,INXM0X0        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  INXM0X0:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $E9 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $EA NOP                     No Operation
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $EB XBA                     Exchange The B & A Accumulators
  andi t0,s0,$FF         // A_REG: Set To B (8-Bit)
  sll t0,8               // B_REG: Set To A (8-Bit)
  srl s0,8
  or s0,t0
  andi t0,s0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  andi t0,s0,$FF
  beqz t0,XBAM0X0        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  XBAM0X0:
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $EC CPX   nnnn              Compare Index Register X With Memory Absolute
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // X_REG: Compare With DB_REG:MEM (16-Bit)
  sll t0,s7,16
  addu a2,t0
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  blt s1,t0,CPXABSM0X0C  // IF (X_REG < Immediate) C Flag Reset
  andi s5,~C_FLAG        // P_REG: C Flag Reset (Delay Slot)
  ori s5,C_FLAG          // P_REG: C Flag Set
  CPXABSM0X0C:
  subu t0,s1,t0
  andi t1,t0,$8000       // Test Negative MSB
  srl t1,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t1               // P_REG: N Flag = Result MSB
  beqz t0,CPXABSM0X0Z    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  CPXABSM0X0Z:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $ED ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $EE ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $EF ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $F0 BEQ   nn                Branch IF Equal
  andi t0,s5,Z_FLAG      // P_REG: Test Z Flag
  beqz t0,BEQM0X0        // IF (Z Flag == 0) Not Equal
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  addu a2,a0,s3          // Load Signed 8-Bit Relative Address
  lb t0,-1(a2)
  add s3,t0              // PC_REG: Set To 8-Bit Relative Address
  addiu v0,1             // Cycles++
  BEQM0X0:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $F1 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $F2 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $F3 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $F4 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $F5 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $F6 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $F7 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $F8 SED                     Set Decimal Mode Flag
  ori s5,D_FLAG          // P_REG: D Flag Set
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $F9 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $FA PLX                     Pull Index Register X From Stack
  addiu s4,2             // S_REG += 2 (Increment Stack)
  andi s4,$FFFF
  addu a2,a0,s4          // X_REG = STACK (16-Bit)
  lbu t0,0(a2)
  sll t0,8
  lbu s1,-1(a2)
  or s1,t0
  andi t0,s1,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s1,PLXM0X0        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  PLXM0X0:
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $FB XCE                     Exchange Carry & Emulation Bits
  andi t0,s5,C_FLAG      // P_REG: C Flag
  andi t1,s5,E_FLAG      // P_REG: E Flag
  sll t0,8               // C Flag -> E Flag
  srl t1,8               // E Flag -> C Flag
  or t2,t0,t1            // C + E Flag
  andi s5,~(C_FLAG+E_FLAG) // P_REG: C + E Flag Reset
  or s5,t1               // P_REG: Exchange Carry & Emulation Bits
  beqz t0,XCEM0X0        // IF (E Flag == 0) Native Mode
  ori s5,M_FLAG+X_FLAG   // P_REG: M + X Flag Set (Delay Slot)
  andi s5,~(M_FLAG+X_FLAG) // P_REG: M + X Flag Reset
  andi s1,$FF            // X_REG = X_REG Low Byte
  andi s2,$FF            // Y_REG = Y_REG Low Byte
  andi s4,$FF            // S_REG = S_REG Low Byte
  XCEM0X0:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $FC ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $FD ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $FE ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $FF ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)