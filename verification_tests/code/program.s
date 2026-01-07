
build/program.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
       0:	00002297          	auipc	t0,0x2
       4:	b0028293          	addi	t0,t0,-1280 # 1b00 <isr_stack_end>
       8:	34029073          	csrw	mscratch,t0
       c:	00000297          	auipc	t0,0x0
      10:	1b028293          	addi	t0,t0,432 # 1bc <interruption_handling>
      14:	30529073          	csrw	mtvec,t0
      18:	000012b7          	lui	t0,0x1
      1c:	80028293          	addi	t0,t0,-2048 # 800 <itoa+0xc0>
      20:	3042a073          	csrs	mie,t0
      24:	30046073          	csrsi	mstatus,8

00000028 <clean_registers>:
      28:	00000093          	li	ra,0
      2c:	00000113          	li	sp,0
      30:	00000193          	li	gp,0
      34:	00000213          	li	tp,0
      38:	00000293          	li	t0,0
      3c:	00000313          	li	t1,0
      40:	00000393          	li	t2,0
      44:	00000413          	li	s0,0
      48:	00000493          	li	s1,0
      4c:	00000513          	li	a0,0
      50:	00000593          	li	a1,0
      54:	00000613          	li	a2,0
      58:	00000693          	li	a3,0
      5c:	00000713          	li	a4,0
      60:	00000793          	li	a5,0
      64:	00000813          	li	a6,0
      68:	00000893          	li	a7,0
      6c:	00000913          	li	s2,0
      70:	00000993          	li	s3,0
      74:	00000a13          	li	s4,0
      78:	00000a93          	li	s5,0
      7c:	00000b13          	li	s6,0
      80:	00000b93          	li	s7,0
      84:	00000c13          	li	s8,0
      88:	00000c93          	li	s9,0
      8c:	00000d13          	li	s10,0
      90:	00000d93          	li	s11,0
      94:	00000e13          	li	t3,0
      98:	00000e93          	li	t4,0
      9c:	00000f13          	li	t5,0
      a0:	00000f93          	li	t6,0

000000a4 <init_registers>:
      a4:	00010137          	lui	sp,0x10
      a8:	ffc10113          	addi	sp,sp,-4 # fffc <STACK_INIT>
      ac:	00010437          	lui	s0,0x10
      b0:	ffc40413          	addi	s0,s0,-4 # fffc <STACK_INIT>
      b4:	3c4010ef          	jal	1478 <main>
      b8:	004000ef          	jal	bc <exit>

000000bc <exit>:
      bc:	00000013          	nop
      c0:	ffdff06f          	j	bc <exit>

000000c4 <get_cpu_freq>:
      c4:	fc102573          	csrr	a0,0xfc1
      c8:	00008067          	ret

000000cc <get_cycle_value>:
      cc:	c0002573          	rdcycle	a0
      d0:	c80025f3          	rdcycleh	a1
      d4:	00008067          	ret

000000d8 <uart_rx_empty>:
      d8:	90000337          	lui	t1,0x90000
      dc:	00432503          	lw	a0,4(t1) # 90000004 <UART_BASE_ADDR+0x4>
      e0:	00008067          	ret

000000e4 <uart_tx_empty>:
      e4:	90000337          	lui	t1,0x90000
      e8:	00c32503          	lw	a0,12(t1) # 9000000c <UART_BASE_ADDR+0xc>
      ec:	00008067          	ret

000000f0 <uart_rx_full>:
      f0:	90000337          	lui	t1,0x90000
      f4:	00832503          	lw	a0,8(t1) # 90000008 <UART_BASE_ADDR+0x8>
      f8:	00008067          	ret

000000fc <uart_tx_full>:
      fc:	90000337          	lui	t1,0x90000
     100:	01032503          	lw	a0,16(t1) # 90000010 <UART_BASE_ADDR+0x10>
     104:	00008067          	ret

00000108 <uart_read>:
     108:	90000337          	lui	t1,0x90000
     10c:	00032503          	lw	a0,0(t1) # 90000000 <UART_BASE_ADDR>
     110:	00008067          	ret

00000114 <uart_write>:
     114:	90000337          	lui	t1,0x90000
     118:	00a32023          	sw	a0,0(t1) # 90000000 <UART_BASE_ADDR>
     11c:	00008067          	ret

00000120 <enable_uart_rx>:
     120:	90000337          	lui	t1,0x90000
     124:	00100513          	li	a0,1
     128:	00a32223          	sw	a0,4(t1) # 90000004 <UART_BASE_ADDR+0x4>
     12c:	00008067          	ret

00000130 <disable_uart_rx>:
     130:	90000337          	lui	t1,0x90000
     134:	00000513          	li	a0,0
     138:	00a32223          	sw	a0,4(t1) # 90000004 <UART_BASE_ADDR+0x4>
     13c:	00008067          	ret

00000140 <set_uart_bit_period>:
     140:	90000337          	lui	t1,0x90000
     144:	00a32423          	sw	a0,8(t1) # 90000008 <UART_BASE_ADDR+0x8>
     148:	00008067          	ret

0000014c <set_uart_parity_type>:
     14c:	90000337          	lui	t1,0x90000
     150:	00a32623          	sw	a0,12(t1) # 9000000c <UART_BASE_ADDR+0xc>
     154:	00008067          	ret

00000158 <config_gpio_direction>:
     158:	a0000337          	lui	t1,0xa0000
     15c:	00a32023          	sw	a0,0(t1) # a0000000 <GPIO_BASE_ADDR>
     160:	00008067          	ret

00000164 <gpio_write_data>:
     164:	a0000337          	lui	t1,0xa0000
     168:	00a32223          	sw	a0,4(t1) # a0000004 <GPIO_BASE_ADDR+0x4>
     16c:	00008067          	ret

00000170 <gpio_read_data>:
     170:	a0000337          	lui	t1,0xa0000
     174:	00032503          	lw	a0,0(t1) # a0000000 <GPIO_BASE_ADDR>
     178:	00008067          	ret

0000017c <set_led_value>:
     17c:	80000337          	lui	t1,0x80000
     180:	00a32023          	sw	a0,0(t1) # 80000000 <LED_BASE_ADDR>
     184:	00008067          	ret

00000188 <set_pwm_period>:
     188:	a0000337          	lui	t1,0xa0000
     18c:	01059593          	slli	a1,a1,0x10
     190:	00b56533          	or	a0,a0,a1
     194:	00a32623          	sw	a0,12(t1) # a000000c <GPIO_BASE_ADDR+0xc>
     198:	00008067          	ret

0000019c <set_pwm_duty_cycle>:
     19c:	a0000337          	lui	t1,0xa0000
     1a0:	01059593          	slli	a1,a1,0x10
     1a4:	00b56533          	or	a0,a0,a1
     1a8:	00a32823          	sw	a0,16(t1) # a0000010 <GPIO_BASE_ADDR+0x10>
     1ac:	00008067          	ret

000001b0 <config_gpio_as_pwm>:
     1b0:	a0000337          	lui	t1,0xa0000
     1b4:	00a32423          	sw	a0,8(t1) # a0000008 <GPIO_BASE_ADDR+0x8>
     1b8:	00008067          	ret

000001bc <interruption_handling>:
     1bc:	34011173          	csrrw	sp,mscratch,sp
     1c0:	34011173          	csrrw	sp,mscratch,sp
     1c4:	30200073          	mret

000001c8 <led_shift>:
     1c8:	ff010113          	addi	sp,sp,-16
     1cc:	00812423          	sw	s0,8(sp)
     1d0:	00112623          	sw	ra,12(sp)
     1d4:	01f00413          	li	s0,31
     1d8:	00040513          	mv	a0,s0
     1dc:	fa1ff0ef          	jal	17c <set_led_value>
     1e0:	00141793          	slli	a5,s0,0x1
     1e4:	01079793          	slli	a5,a5,0x10
     1e8:	0107d793          	srli	a5,a5,0x10
     1ec:	40f45413          	srai	s0,s0,0xf
     1f0:	06400513          	li	a0,100
     1f4:	0087e433          	or	s0,a5,s0
     1f8:	248000ef          	jal	440 <delay_ms>
     1fc:	fddff06f          	j	1d8 <led_shift+0x10>

00000200 <get_pwm_period>:
     200:	05f5e7b7          	lui	a5,0x5f5e
     204:	10078793          	addi	a5,a5,256 # 5f5e100 <MEMORY_SIZE+0x5f4e100>
     208:	02a7c533          	div	a0,a5,a0
     20c:	00008067          	ret

00000210 <get_pwm_duty_cycle>:
     210:	02b505b3          	mul	a1,a0,a1
     214:	41f5d513          	srai	a0,a1,0x1f
     218:	01051513          	slli	a0,a0,0x10
     21c:	01055513          	srli	a0,a0,0x10
     220:	00b50533          	add	a0,a0,a1
     224:	41055513          	srai	a0,a0,0x10
     228:	00008067          	ret

0000022c <memset>:
     22c:	ff010113          	addi	sp,sp,-16
     230:	00812423          	sw	s0,8(sp)
     234:	00112623          	sw	ra,12(sp)
     238:	00050413          	mv	s0,a0
     23c:	00060663          	beqz	a2,248 <memset+0x1c>
     240:	0ff5f593          	zext.b	a1,a1
     244:	fe9ff0ef          	jal	22c <memset>
     248:	00c12083          	lw	ra,12(sp)
     24c:	00040513          	mv	a0,s0
     250:	00812403          	lw	s0,8(sp)
     254:	01010113          	addi	sp,sp,16
     258:	00008067          	ret

0000025c <memcpy>:
     25c:	02060063          	beqz	a2,27c <memcpy+0x20>
     260:	00c58633          	add	a2,a1,a2
     264:	00050793          	mv	a5,a0
     268:	0005c703          	lbu	a4,0(a1)
     26c:	00158593          	addi	a1,a1,1
     270:	00178793          	addi	a5,a5,1
     274:	fee78fa3          	sb	a4,-1(a5)
     278:	fec598e3          	bne	a1,a2,268 <memcpy+0xc>
     27c:	00008067          	ret

00000280 <strlen>:
     280:	00054783          	lbu	a5,0(a0)
     284:	02078263          	beqz	a5,2a8 <strlen+0x28>
     288:	ff010113          	addi	sp,sp,-16
     28c:	00150513          	addi	a0,a0,1
     290:	00112623          	sw	ra,12(sp)
     294:	fedff0ef          	jal	280 <strlen>
     298:	00c12083          	lw	ra,12(sp)
     29c:	00150513          	addi	a0,a0,1
     2a0:	01010113          	addi	sp,sp,16
     2a4:	00008067          	ret
     2a8:	00000513          	li	a0,0
     2ac:	00008067          	ret

000002b0 <strcpy>:
     2b0:	0005c783          	lbu	a5,0(a1)
     2b4:	00050713          	mv	a4,a0
     2b8:	00078c63          	beqz	a5,2d0 <strcpy+0x20>
     2bc:	00158593          	addi	a1,a1,1
     2c0:	00f70023          	sb	a5,0(a4)
     2c4:	0005c783          	lbu	a5,0(a1)
     2c8:	00170713          	addi	a4,a4,1
     2cc:	fe0798e3          	bnez	a5,2bc <strcpy+0xc>
     2d0:	00070023          	sb	zero,0(a4)
     2d4:	00008067          	ret

000002d8 <strcmp>:
     2d8:	00054783          	lbu	a5,0(a0)
     2dc:	00079a63          	bnez	a5,2f0 <strcmp+0x18>
     2e0:	0300006f          	j	310 <strcmp+0x38>
     2e4:	00054783          	lbu	a5,0(a0)
     2e8:	00078e63          	beqz	a5,304 <strcmp+0x2c>
     2ec:	00158593          	addi	a1,a1,1
     2f0:	0005c703          	lbu	a4,0(a1)
     2f4:	00150513          	addi	a0,a0,1
     2f8:	fef706e3          	beq	a4,a5,2e4 <strcmp+0xc>
     2fc:	40e78533          	sub	a0,a5,a4
     300:	00008067          	ret
     304:	0015c703          	lbu	a4,1(a1)
     308:	40e78533          	sub	a0,a5,a4
     30c:	00008067          	ret
     310:	0005c703          	lbu	a4,0(a1)
     314:	fe9ff06f          	j	2fc <strcmp+0x24>

00000318 <strcat>:
     318:	00054783          	lbu	a5,0(a0)
     31c:	02078c63          	beqz	a5,354 <strcat+0x3c>
     320:	00050793          	mv	a5,a0
     324:	0017c703          	lbu	a4,1(a5)
     328:	00178793          	addi	a5,a5,1
     32c:	fe071ce3          	bnez	a4,324 <strcat+0xc>
     330:	0005c703          	lbu	a4,0(a1)
     334:	00070c63          	beqz	a4,34c <strcat+0x34>
     338:	00178793          	addi	a5,a5,1
     33c:	00158593          	addi	a1,a1,1
     340:	fee78fa3          	sb	a4,-1(a5)
     344:	0005c703          	lbu	a4,0(a1)
     348:	fe0718e3          	bnez	a4,338 <strcat+0x20>
     34c:	00078023          	sb	zero,0(a5)
     350:	00008067          	ret
     354:	00050793          	mv	a5,a0
     358:	fedff06f          	j	344 <strcat+0x2c>

0000035c <strncpy>:
     35c:	00050693          	mv	a3,a0
     360:	00000513          	li	a0,0
     364:	00061a63          	bnez	a2,378 <strncpy+0x1c>
     368:	0540006f          	j	3bc <strncpy+0x60>
     36c:	00f70023          	sb	a5,0(a4)
     370:	00150513          	addi	a0,a0,1
     374:	04a60463          	beq	a2,a0,3bc <strncpy+0x60>
     378:	00a587b3          	add	a5,a1,a0
     37c:	0007c783          	lbu	a5,0(a5)
     380:	00a68733          	add	a4,a3,a0
     384:	fe0794e3          	bnez	a5,36c <strncpy+0x10>
     388:	02c57a63          	bgeu	a0,a2,3bc <strncpy+0x60>
     38c:	fe010113          	addi	sp,sp,-32
     390:	40a60633          	sub	a2,a2,a0
     394:	00000593          	li	a1,0
     398:	00070513          	mv	a0,a4
     39c:	00112e23          	sw	ra,28(sp)
     3a0:	00d12623          	sw	a3,12(sp)
     3a4:	e89ff0ef          	jal	22c <memset>
     3a8:	00c12683          	lw	a3,12(sp)
     3ac:	01c12083          	lw	ra,28(sp)
     3b0:	00068513          	mv	a0,a3
     3b4:	02010113          	addi	sp,sp,32
     3b8:	00008067          	ret
     3bc:	00068513          	mv	a0,a3
     3c0:	00008067          	ret

000003c4 <get_cpu_freq_mhz>:
     3c4:	ff010113          	addi	sp,sp,-16
     3c8:	00112623          	sw	ra,12(sp)
     3cc:	cf9ff0ef          	jal	c4 <get_cpu_freq>
     3d0:	431be7b7          	lui	a5,0x431be
     3d4:	e8378793          	addi	a5,a5,-381 # 431bde83 <MEMORY_SIZE+0x431ade83>
     3d8:	02f53533          	mulhu	a0,a0,a5
     3dc:	00c12083          	lw	ra,12(sp)
     3e0:	01010113          	addi	sp,sp,16
     3e4:	01255513          	srli	a0,a0,0x12
     3e8:	00008067          	ret

000003ec <delay_s>:
     3ec:	ff010113          	addi	sp,sp,-16
     3f0:	00812423          	sw	s0,8(sp)
     3f4:	00912223          	sw	s1,4(sp)
     3f8:	00050413          	mv	s0,a0
     3fc:	00112623          	sw	ra,12(sp)
     400:	ccdff0ef          	jal	cc <get_cycle_value>
     404:	05f5e7b7          	lui	a5,0x5f5e
     408:	10078793          	addi	a5,a5,256 # 5f5e100 <MEMORY_SIZE+0x5f4e100>
     40c:	02f40433          	mul	s0,s0,a5
     410:	00a404b3          	add	s1,s0,a0
     414:	0084b433          	sltu	s0,s1,s0
     418:	00b40433          	add	s0,s0,a1
     41c:	cb1ff0ef          	jal	cc <get_cycle_value>
     420:	fe85eee3          	bltu	a1,s0,41c <delay_s+0x30>
     424:	00b41463          	bne	s0,a1,42c <delay_s+0x40>
     428:	fe956ae3          	bltu	a0,s1,41c <delay_s+0x30>
     42c:	00c12083          	lw	ra,12(sp)
     430:	00812403          	lw	s0,8(sp)
     434:	00412483          	lw	s1,4(sp)
     438:	01010113          	addi	sp,sp,16
     43c:	00008067          	ret

00000440 <delay_ms>:
     440:	ff010113          	addi	sp,sp,-16
     444:	00812423          	sw	s0,8(sp)
     448:	00912223          	sw	s1,4(sp)
     44c:	00050413          	mv	s0,a0
     450:	00112623          	sw	ra,12(sp)
     454:	c79ff0ef          	jal	cc <get_cycle_value>
     458:	000187b7          	lui	a5,0x18
     45c:	6a078793          	addi	a5,a5,1696 # 186a0 <MEMORY_SIZE+0x86a0>
     460:	02f40433          	mul	s0,s0,a5
     464:	00a404b3          	add	s1,s0,a0
     468:	0084b433          	sltu	s0,s1,s0
     46c:	00b40433          	add	s0,s0,a1
     470:	c5dff0ef          	jal	cc <get_cycle_value>
     474:	fe85eee3          	bltu	a1,s0,470 <delay_ms+0x30>
     478:	00b41463          	bne	s0,a1,480 <delay_ms+0x40>
     47c:	fe956ae3          	bltu	a0,s1,470 <delay_ms+0x30>
     480:	00c12083          	lw	ra,12(sp)
     484:	00812403          	lw	s0,8(sp)
     488:	00412483          	lw	s1,4(sp)
     48c:	01010113          	addi	sp,sp,16
     490:	00008067          	ret

00000494 <delay_us>:
     494:	ff010113          	addi	sp,sp,-16
     498:	00812423          	sw	s0,8(sp)
     49c:	00912223          	sw	s1,4(sp)
     4a0:	00050413          	mv	s0,a0
     4a4:	00112623          	sw	ra,12(sp)
     4a8:	c25ff0ef          	jal	cc <get_cycle_value>
     4ac:	06400793          	li	a5,100
     4b0:	02f40433          	mul	s0,s0,a5
     4b4:	00a404b3          	add	s1,s0,a0
     4b8:	0084b433          	sltu	s0,s1,s0
     4bc:	00b40433          	add	s0,s0,a1
     4c0:	c0dff0ef          	jal	cc <get_cycle_value>
     4c4:	fe85eee3          	bltu	a1,s0,4c0 <delay_us+0x2c>
     4c8:	00b41463          	bne	s0,a1,4d0 <delay_us+0x3c>
     4cc:	fe956ae3          	bltu	a0,s1,4c0 <delay_us+0x2c>
     4d0:	00c12083          	lw	ra,12(sp)
     4d4:	00812403          	lw	s0,8(sp)
     4d8:	00412483          	lw	s1,4(sp)
     4dc:	01010113          	addi	sp,sp,16
     4e0:	00008067          	ret

000004e4 <uart_read_string>:
     4e4:	ff010113          	addi	sp,sp,-16
     4e8:	00112623          	sw	ra,12(sp)
     4ec:	01212023          	sw	s2,0(sp)
     4f0:	04b05663          	blez	a1,53c <uart_read_string+0x58>
     4f4:	00812423          	sw	s0,8(sp)
     4f8:	00912223          	sw	s1,4(sp)
     4fc:	00058913          	mv	s2,a1
     500:	00050413          	mv	s0,a0
     504:	00b504b3          	add	s1,a0,a1
     508:	bd1ff0ef          	jal	d8 <uart_rx_empty>
     50c:	fe051ee3          	bnez	a0,508 <uart_read_string+0x24>
     510:	bf9ff0ef          	jal	108 <uart_read>
     514:	00a40023          	sb	a0,0(s0)
     518:	00140413          	addi	s0,s0,1
     51c:	fe9416e3          	bne	s0,s1,508 <uart_read_string+0x24>
     520:	00812403          	lw	s0,8(sp)
     524:	00c12083          	lw	ra,12(sp)
     528:	00412483          	lw	s1,4(sp)
     52c:	00090513          	mv	a0,s2
     530:	00012903          	lw	s2,0(sp)
     534:	01010113          	addi	sp,sp,16
     538:	00008067          	ret
     53c:	00c12083          	lw	ra,12(sp)
     540:	00000913          	li	s2,0
     544:	00090513          	mv	a0,s2
     548:	00012903          	lw	s2,0(sp)
     54c:	01010113          	addi	sp,sp,16
     550:	00008067          	ret

00000554 <uart_write_string>:
     554:	04b05463          	blez	a1,59c <uart_write_string+0x48>
     558:	ff010113          	addi	sp,sp,-16
     55c:	00812423          	sw	s0,8(sp)
     560:	00912223          	sw	s1,4(sp)
     564:	00112623          	sw	ra,12(sp)
     568:	00050413          	mv	s0,a0
     56c:	00b504b3          	add	s1,a0,a1
     570:	b8dff0ef          	jal	fc <uart_tx_full>
     574:	fe051ee3          	bnez	a0,570 <uart_write_string+0x1c>
     578:	00044503          	lbu	a0,0(s0)
     57c:	00140413          	addi	s0,s0,1
     580:	b95ff0ef          	jal	114 <uart_write>
     584:	fe9416e3          	bne	s0,s1,570 <uart_write_string+0x1c>
     588:	00c12083          	lw	ra,12(sp)
     58c:	00812403          	lw	s0,8(sp)
     590:	00412483          	lw	s1,4(sp)
     594:	01010113          	addi	sp,sp,16
     598:	00008067          	ret
     59c:	00008067          	ret

000005a0 <uart_write_int>:
     5a0:	fe010113          	addi	sp,sp,-32
     5a4:	00058613          	mv	a2,a1
     5a8:	00010593          	mv	a1,sp
     5ac:	00112e23          	sw	ra,28(sp)
     5b0:	190000ef          	jal	740 <itoa>
     5b4:	00010513          	mv	a0,sp
     5b8:	cc9ff0ef          	jal	280 <strlen>
     5bc:	02a05a63          	blez	a0,5f0 <uart_write_int+0x50>
     5c0:	00812c23          	sw	s0,24(sp)
     5c4:	00912a23          	sw	s1,20(sp)
     5c8:	00010413          	mv	s0,sp
     5cc:	00a104b3          	add	s1,sp,a0
     5d0:	b2dff0ef          	jal	fc <uart_tx_full>
     5d4:	fe051ee3          	bnez	a0,5d0 <uart_write_int+0x30>
     5d8:	00044503          	lbu	a0,0(s0)
     5dc:	00140413          	addi	s0,s0,1
     5e0:	b35ff0ef          	jal	114 <uart_write>
     5e4:	fe9416e3          	bne	s0,s1,5d0 <uart_write_int+0x30>
     5e8:	01812403          	lw	s0,24(sp)
     5ec:	01412483          	lw	s1,20(sp)
     5f0:	01c12083          	lw	ra,28(sp)
     5f4:	02010113          	addi	sp,sp,32
     5f8:	00008067          	ret

000005fc <uart_set_baud_rate>:
     5fc:	05f5e7b7          	lui	a5,0x5f5e
     600:	10078793          	addi	a5,a5,256 # 5f5e100 <MEMORY_SIZE+0x5f4e100>
     604:	02a7c533          	div	a0,a5,a0
     608:	b39ff06f          	j	140 <set_uart_bit_period>

0000060c <uart_init>:
     60c:	ff010113          	addi	sp,sp,-16
     610:	36400513          	li	a0,868
     614:	00112623          	sw	ra,12(sp)
     618:	b29ff0ef          	jal	140 <set_uart_bit_period>
     61c:	b05ff0ef          	jal	120 <enable_uart_rx>
     620:	00c12083          	lw	ra,12(sp)
     624:	00100513          	li	a0,1
     628:	01010113          	addi	sp,sp,16
     62c:	b21ff06f          	j	14c <set_uart_parity_type>

00000630 <is_space>:
     630:	ff750793          	addi	a5,a0,-9
     634:	fe050513          	addi	a0,a0,-32
     638:	0057b793          	sltiu	a5,a5,5
     63c:	00153513          	seqz	a0,a0
     640:	00a7e533          	or	a0,a5,a0
     644:	00008067          	ret

00000648 <is_digit>:
     648:	fd050513          	addi	a0,a0,-48
     64c:	00a53513          	sltiu	a0,a0,10
     650:	00008067          	ret

00000654 <atoi>:
     654:	00054703          	lbu	a4,0(a0)
     658:	ff770793          	addi	a5,a4,-9
     65c:	0057b793          	sltiu	a5,a5,5
     660:	06079863          	bnez	a5,6d0 <atoi+0x7c>
     664:	fe070793          	addi	a5,a4,-32
     668:	06078463          	beqz	a5,6d0 <atoi+0x7c>
     66c:	02d00793          	li	a5,45
     670:	0cf70463          	beq	a4,a5,738 <atoi+0xe4>
     674:	02b00793          	li	a5,43
     678:	0af71a63          	bne	a4,a5,72c <atoi+0xd8>
     67c:	00154703          	lbu	a4,1(a0)
     680:	00100613          	li	a2,1
     684:	00060813          	mv	a6,a2
     688:	00150693          	addi	a3,a0,1
     68c:	fd070593          	addi	a1,a4,-48
     690:	00c686b3          	add	a3,a3,a2
     694:	0ff5f793          	zext.b	a5,a1
     698:	00900613          	li	a2,9
     69c:	00000513          	li	a0,0
     6a0:	08f66463          	bltu	a2,a5,728 <atoi+0xd4>
     6a4:	0006c703          	lbu	a4,0(a3)
     6a8:	00251793          	slli	a5,a0,0x2
     6ac:	00a787b3          	add	a5,a5,a0
     6b0:	00179793          	slli	a5,a5,0x1
     6b4:	00f58533          	add	a0,a1,a5
     6b8:	fd070593          	addi	a1,a4,-48
     6bc:	0ff5f793          	zext.b	a5,a1
     6c0:	00168693          	addi	a3,a3,1
     6c4:	fef670e3          	bgeu	a2,a5,6a4 <atoi+0x50>
     6c8:	03050533          	mul	a0,a0,a6
     6cc:	00008067          	ret
     6d0:	00000613          	li	a2,0
     6d4:	00160613          	addi	a2,a2,1
     6d8:	00c507b3          	add	a5,a0,a2
     6dc:	0007c703          	lbu	a4,0(a5)
     6e0:	ff770793          	addi	a5,a4,-9
     6e4:	0057b793          	sltiu	a5,a5,5
     6e8:	fe070693          	addi	a3,a4,-32
     6ec:	fe0794e3          	bnez	a5,6d4 <atoi+0x80>
     6f0:	fe0682e3          	beqz	a3,6d4 <atoi+0x80>
     6f4:	02d00793          	li	a5,45
     6f8:	02f71c63          	bne	a4,a5,730 <atoi+0xdc>
     6fc:	00160613          	addi	a2,a2,1
     700:	00c507b3          	add	a5,a0,a2
     704:	0007c703          	lbu	a4,0(a5)
     708:	00150693          	addi	a3,a0,1
     70c:	00c686b3          	add	a3,a3,a2
     710:	fd070593          	addi	a1,a4,-48
     714:	0ff5f793          	zext.b	a5,a1
     718:	00900613          	li	a2,9
     71c:	fff00813          	li	a6,-1
     720:	00000513          	li	a0,0
     724:	f8f670e3          	bgeu	a2,a5,6a4 <atoi+0x50>
     728:	00008067          	ret
     72c:	00000613          	li	a2,0
     730:	00100813          	li	a6,1
     734:	f55ff06f          	j	688 <atoi+0x34>
     738:	00000613          	li	a2,0
     73c:	fc1ff06f          	j	6fc <atoi+0xa8>

00000740 <itoa>:
     740:	ffe60693          	addi	a3,a2,-2
     744:	02200713          	li	a4,34
     748:	00050793          	mv	a5,a0
     74c:	0ad76063          	bltu	a4,a3,7ec <itoa+0xac>
     750:	08055863          	bgez	a0,7e0 <itoa+0xa0>
     754:	ff660713          	addi	a4,a2,-10
     758:	08071463          	bnez	a4,7e0 <itoa+0xa0>
     75c:	40a007b3          	neg	a5,a0
     760:	00100e13          	li	t3,1
     764:	00000713          	li	a4,0
     768:	00900513          	li	a0,9
     76c:	0080006f          	j	774 <itoa+0x34>
     770:	00088713          	mv	a4,a7
     774:	02c7e6b3          	rem	a3,a5,a2
     778:	00e58333          	add	t1,a1,a4
     77c:	00170893          	addi	a7,a4,1
     780:	02c7c7b3          	div	a5,a5,a2
     784:	03768813          	addi	a6,a3,55
     788:	00d54463          	blt	a0,a3,790 <itoa+0x50>
     78c:	03068813          	addi	a6,a3,48
     790:	01030023          	sb	a6,0(t1)
     794:	fc079ee3          	bnez	a5,770 <itoa+0x30>
     798:	011587b3          	add	a5,a1,a7
     79c:	040e1e63          	bnez	t3,7f8 <itoa+0xb8>
     7a0:	00078023          	sb	zero,0(a5)
     7a4:	4018d713          	srai	a4,a7,0x1
     7a8:	02070863          	beqz	a4,7d8 <itoa+0x98>
     7ac:	fff58693          	addi	a3,a1,-1
     7b0:	00e58733          	add	a4,a1,a4
     7b4:	011686b3          	add	a3,a3,a7
     7b8:	00058793          	mv	a5,a1
     7bc:	0006c803          	lbu	a6,0(a3)
     7c0:	0007c603          	lbu	a2,0(a5)
     7c4:	00178793          	addi	a5,a5,1
     7c8:	ff078fa3          	sb	a6,-1(a5)
     7cc:	00c68023          	sb	a2,0(a3)
     7d0:	fff68693          	addi	a3,a3,-1
     7d4:	fef714e3          	bne	a4,a5,7bc <itoa+0x7c>
     7d8:	00058513          	mv	a0,a1
     7dc:	00008067          	ret
     7e0:	00078663          	beqz	a5,7ec <itoa+0xac>
     7e4:	00000e13          	li	t3,0
     7e8:	f7dff06f          	j	764 <itoa+0x24>
     7ec:	00058023          	sb	zero,0(a1)
     7f0:	00058513          	mv	a0,a1
     7f4:	00008067          	ret
     7f8:	00270893          	addi	a7,a4,2
     7fc:	02d00693          	li	a3,45
     800:	00d78023          	sb	a3,0(a5)
     804:	40175713          	srai	a4,a4,0x1
     808:	011587b3          	add	a5,a1,a7
     80c:	00170713          	addi	a4,a4,1
     810:	00078023          	sb	zero,0(a5)
     814:	f99ff06f          	j	7ac <itoa+0x6c>

00000818 <number>:
     818:	f8010113          	addi	sp,sp,-128
     81c:	06112e23          	sw	ra,124(sp)
     820:	06812c23          	sw	s0,120(sp)
     824:	06912a23          	sw	s1,116(sp)
     828:	07212823          	sw	s2,112(sp)
     82c:	0407fe13          	andi	t3,a5,64
     830:	00050893          	mv	a7,a0
     834:	00060313          	mv	t1,a2
     838:	180e1663          	bnez	t3,9c4 <number+0x1ac>
     83c:	00001637          	lui	a2,0x1
     840:	0107ff93          	andi	t6,a5,16
     844:	4a460613          	addi	a2,a2,1188 # 14a4 <main+0x2c>
     848:	180f9663          	bnez	t6,9d4 <number+0x1bc>
     84c:	0017f293          	andi	t0,a5,1
     850:	fff28e93          	addi	t4,t0,-1
     854:	ff0efe93          	andi	t4,t4,-16
     858:	0027f513          	andi	a0,a5,2
     85c:	030e8e93          	addi	t4,t4,48
     860:	0207ff13          	andi	t5,a5,32
     864:	18050463          	beqz	a0,9ec <number+0x1d4>
     868:	2605c663          	bltz	a1,ad4 <number+0x2bc>
     86c:	0047f513          	andi	a0,a5,4
     870:	22051e63          	bnez	a0,aac <number+0x294>
     874:	0087f793          	andi	a5,a5,8
     878:	00000393          	li	t2,0
     87c:	00078663          	beqz	a5,888 <number+0x70>
     880:	fff68693          	addi	a3,a3,-1
     884:	02000393          	li	t2,32
     888:	000f0e63          	beqz	t5,8a4 <number+0x8c>
     88c:	01000793          	li	a5,16
     890:	26f30663          	beq	t1,a5,afc <number+0x2e4>
     894:	ff830793          	addi	a5,t1,-8
     898:	0017b793          	seqz	a5,a5
     89c:	40f686b3          	sub	a3,a3,a5
     8a0:	02000f13          	li	t5,32
     8a4:	1a059c63          	bnez	a1,a5c <number+0x244>
     8a8:	03000793          	li	a5,48
     8ac:	02f10623          	sb	a5,44(sp)
     8b0:	00000913          	li	s2,0
     8b4:	00100793          	li	a5,1
     8b8:	02c10413          	addi	s0,sp,44
     8bc:	00078e13          	mv	t3,a5
     8c0:	00e7d463          	bge	a5,a4,8c8 <number+0xb0>
     8c4:	00070e13          	mv	t3,a4
     8c8:	41c684b3          	sub	s1,a3,t3
     8cc:	12029663          	bnez	t0,9f8 <number+0x1e0>
     8d0:	12905263          	blez	s1,9f4 <number+0x1dc>
     8d4:	00088513          	mv	a0,a7
     8d8:	00048613          	mv	a2,s1
     8dc:	02000593          	li	a1,32
     8e0:	00e12e23          	sw	a4,28(sp)
     8e4:	00612c23          	sw	t1,24(sp)
     8e8:	00712a23          	sw	t2,20(sp)
     8ec:	01e12823          	sw	t5,16(sp)
     8f0:	01c12623          	sw	t3,12(sp)
     8f4:	00f12423          	sw	a5,8(sp)
     8f8:	01d12223          	sw	t4,4(sp)
     8fc:	01f12023          	sw	t6,0(sp)
     900:	92dff0ef          	jal	22c <memset>
     904:	01412383          	lw	t2,20(sp)
     908:	00012f83          	lw	t6,0(sp)
     90c:	00412e83          	lw	t4,4(sp)
     910:	00812783          	lw	a5,8(sp)
     914:	00c12e03          	lw	t3,12(sp)
     918:	01012f03          	lw	t5,16(sp)
     91c:	01812303          	lw	t1,24(sp)
     920:	01c12703          	lw	a4,28(sp)
     924:	009508b3          	add	a7,a0,s1
     928:	16039463          	bnez	t2,a90 <number+0x278>
     92c:	000f0a63          	beqz	t5,940 <number+0x128>
     930:	00800693          	li	a3,8
     934:	1ed30e63          	beq	t1,a3,b30 <number+0x318>
     938:	01000693          	li	a3,16
     93c:	16d30e63          	beq	t1,a3,ab8 <number+0x2a0>
     940:	01f034b3          	snez	s1,t6
     944:	ffe48493          	addi	s1,s1,-2
     948:	02e7d063          	bge	a5,a4,968 <number+0x150>
     94c:	40fe0633          	sub	a2,t3,a5
     950:	00088513          	mv	a0,a7
     954:	03000593          	li	a1,48
     958:	00c12023          	sw	a2,0(sp)
     95c:	8d1ff0ef          	jal	22c <memset>
     960:	00012603          	lw	a2,0(sp)
     964:	00c508b3          	add	a7,a0,a2
     968:	012407b3          	add	a5,s0,s2
     96c:	fff40593          	addi	a1,s0,-1
     970:	00088713          	mv	a4,a7
     974:	0007c603          	lbu	a2,0(a5)
     978:	fff78793          	addi	a5,a5,-1
     97c:	00170713          	addi	a4,a4,1
     980:	fec70fa3          	sb	a2,-1(a4)
     984:	fef598e3          	bne	a1,a5,974 <number+0x15c>
     988:	00190793          	addi	a5,s2,1
     98c:	00f88833          	add	a6,a7,a5
     990:	00905c63          	blez	s1,9a8 <number+0x190>
     994:	00080513          	mv	a0,a6
     998:	00048613          	mv	a2,s1
     99c:	02000593          	li	a1,32
     9a0:	88dff0ef          	jal	22c <memset>
     9a4:	00950833          	add	a6,a0,s1
     9a8:	07c12083          	lw	ra,124(sp)
     9ac:	07812403          	lw	s0,120(sp)
     9b0:	07412483          	lw	s1,116(sp)
     9b4:	07012903          	lw	s2,112(sp)
     9b8:	00080513          	mv	a0,a6
     9bc:	08010113          	addi	sp,sp,128
     9c0:	00008067          	ret
     9c4:	00001637          	lui	a2,0x1
     9c8:	0107ff93          	andi	t6,a5,16
     9cc:	4cc60613          	addi	a2,a2,1228 # 14cc <main+0x54>
     9d0:	e60f8ee3          	beqz	t6,84c <number+0x34>
     9d4:	ffe7f793          	andi	a5,a5,-2
     9d8:	0027f513          	andi	a0,a5,2
     9dc:	01000293          	li	t0,16
     9e0:	02000e93          	li	t4,32
     9e4:	0207ff13          	andi	t5,a5,32
     9e8:	e80510e3          	bnez	a0,868 <number+0x50>
     9ec:	00000393          	li	t2,0
     9f0:	e99ff06f          	j	888 <number+0x70>
     9f4:	fff48493          	addi	s1,s1,-1
     9f8:	00038663          	beqz	t2,a04 <number+0x1ec>
     9fc:	00788023          	sb	t2,0(a7)
     a00:	00188893          	addi	a7,a7,1
     a04:	000f0a63          	beqz	t5,a18 <number+0x200>
     a08:	00800693          	li	a3,8
     a0c:	0ed30e63          	beq	t1,a3,b08 <number+0x2f0>
     a10:	01000693          	li	a3,16
     a14:	0ad30463          	beq	t1,a3,abc <number+0x2a4>
     a18:	f20f98e3          	bnez	t6,948 <number+0x130>
     a1c:	12905a63          	blez	s1,b50 <number+0x338>
     a20:	00048613          	mv	a2,s1
     a24:	00088513          	mv	a0,a7
     a28:	000e8593          	mv	a1,t4
     a2c:	00e12423          	sw	a4,8(sp)
     a30:	01c12223          	sw	t3,4(sp)
     a34:	00f12023          	sw	a5,0(sp)
     a38:	ff4ff0ef          	jal	22c <memset>
     a3c:	009508b3          	add	a7,a0,s1
     a40:	00012783          	lw	a5,0(sp)
     a44:	00412e03          	lw	t3,4(sp)
     a48:	00812703          	lw	a4,8(sp)
     a4c:	fff00493          	li	s1,-1
     a50:	ef9ff06f          	j	948 <number+0x130>
     a54:	fff68693          	addi	a3,a3,-1
     a58:	02d00393          	li	t2,45
     a5c:	00000793          	li	a5,0
     a60:	02c10413          	addi	s0,sp,44
     a64:	0265f833          	remu	a6,a1,t1
     a68:	00078913          	mv	s2,a5
     a6c:	00178793          	addi	a5,a5,1
     a70:	00f40e33          	add	t3,s0,a5
     a74:	00058513          	mv	a0,a1
     a78:	01060833          	add	a6,a2,a6
     a7c:	00084803          	lbu	a6,0(a6)
     a80:	0265d5b3          	divu	a1,a1,t1
     a84:	ff0e0fa3          	sb	a6,-1(t3)
     a88:	fc657ee3          	bgeu	a0,t1,a64 <number+0x24c>
     a8c:	e31ff06f          	j	8bc <number+0xa4>
     a90:	00788023          	sb	t2,0(a7)
     a94:	00188893          	addi	a7,a7,1
     a98:	080f1063          	bnez	t5,b18 <number+0x300>
     a9c:	ffe00493          	li	s1,-2
     aa0:	ea0f84e3          	beqz	t6,948 <number+0x130>
     aa4:	fff00493          	li	s1,-1
     aa8:	ea1ff06f          	j	948 <number+0x130>
     aac:	fff68693          	addi	a3,a3,-1
     ab0:	02b00393          	li	t2,43
     ab4:	dd5ff06f          	j	888 <number+0x70>
     ab8:	fff00493          	li	s1,-1
     abc:	03000613          	li	a2,48
     ac0:	07800693          	li	a3,120
     ac4:	00c88023          	sb	a2,0(a7)
     ac8:	00d880a3          	sb	a3,1(a7)
     acc:	00288893          	addi	a7,a7,2
     ad0:	f49ff06f          	j	a18 <number+0x200>
     ad4:	40b005b3          	neg	a1,a1
     ad8:	f60f0ee3          	beqz	t5,a54 <number+0x23c>
     adc:	01000793          	li	a5,16
     ae0:	06f30063          	beq	t1,a5,b40 <number+0x328>
     ae4:	00800793          	li	a5,8
     ae8:	02f30c63          	beq	t1,a5,b20 <number+0x308>
     aec:	fff68693          	addi	a3,a3,-1
     af0:	02d00393          	li	t2,45
     af4:	02000f13          	li	t5,32
     af8:	f65ff06f          	j	a5c <number+0x244>
     afc:	ffe68693          	addi	a3,a3,-2
     b00:	02000f13          	li	t5,32
     b04:	da1ff06f          	j	8a4 <number+0x8c>
     b08:	03000693          	li	a3,48
     b0c:	00d88023          	sb	a3,0(a7)
     b10:	00188893          	addi	a7,a7,1
     b14:	f05ff06f          	j	a18 <number+0x200>
     b18:	fff00493          	li	s1,-1
     b1c:	eedff06f          	j	a08 <number+0x1f0>
     b20:	ffe68693          	addi	a3,a3,-2
     b24:	02d00393          	li	t2,45
     b28:	02000f13          	li	t5,32
     b2c:	f31ff06f          	j	a5c <number+0x244>
     b30:	03000693          	li	a3,48
     b34:	00d88023          	sb	a3,0(a7)
     b38:	00188893          	addi	a7,a7,1
     b3c:	f61ff06f          	j	a9c <number+0x284>
     b40:	ffd68693          	addi	a3,a3,-3
     b44:	02d00393          	li	t2,45
     b48:	02000f13          	li	t5,32
     b4c:	f11ff06f          	j	a5c <number+0x244>
     b50:	fff48493          	addi	s1,s1,-1
     b54:	df5ff06f          	j	948 <number+0x130>

00000b58 <ee_printf>:
     b58:	b8010113          	addi	sp,sp,-1152
     b5c:	45412423          	sw	s4,1096(sp)
     b60:	44112e23          	sw	ra,1116(sp)
     b64:	44812c23          	sw	s0,1112(sp)
     b68:	44912a23          	sw	s1,1108(sp)
     b6c:	45212823          	sw	s2,1104(sp)
     b70:	46b12223          	sw	a1,1124(sp)
     b74:	46c12423          	sw	a2,1128(sp)
     b78:	46d12623          	sw	a3,1132(sp)
     b7c:	46e12823          	sw	a4,1136(sp)
     b80:	46f12a23          	sw	a5,1140(sp)
     b84:	47012c23          	sw	a6,1144(sp)
     b88:	47112e23          	sw	a7,1148(sp)
     b8c:	00054783          	lbu	a5,0(a0)
     b90:	46410a13          	addi	s4,sp,1124
     b94:	01412a23          	sw	s4,20(sp)
     b98:	00078ae3          	beqz	a5,13ac <mhzfreq+0x3eb>
     b9c:	45512223          	sw	s5,1092(sp)
     ba0:	03010413          	addi	s0,sp,48
     ba4:	00001ab7          	lui	s5,0x1
     ba8:	45312623          	sw	s3,1100(sp)
     bac:	45612023          	sw	s6,1088(sp)
     bb0:	43712e23          	sw	s7,1084(sp)
     bb4:	00050313          	mv	t1,a0
     bb8:	00040893          	mv	a7,s0
     bbc:	4fca8a93          	addi	s5,s5,1276 # 14fc <main+0x84>
     bc0:	02500b13          	li	s6,37
     bc4:	01000993          	li	s3,16
     bc8:	00900913          	li	s2,9
     bcc:	02e00493          	li	s1,46
     bd0:	05678c63          	beq	a5,s6,c28 <ee_printf+0xd0>
     bd4:	00f88023          	sb	a5,0(a7)
     bd8:	00134783          	lbu	a5,1(t1)
     bdc:	00188893          	addi	a7,a7,1
     be0:	00130313          	addi	t1,t1,1
     be4:	fe0796e3          	bnez	a5,bd0 <ee_printf+0x78>
     be8:	44c12983          	lw	s3,1100(sp)
     bec:	44412a83          	lw	s5,1092(sp)
     bf0:	44012b03          	lw	s6,1088(sp)
     bf4:	43c12b83          	lw	s7,1084(sp)
     bf8:	00088023          	sb	zero,0(a7)
     bfc:	03014903          	lbu	s2,48(sp)
     c00:	7c090063          	beqz	s2,13c0 <mhzfreq+0x3ff>
     c04:	00040493          	mv	s1,s0
     c08:	cf4ff0ef          	jal	fc <uart_tx_full>
     c0c:	fe051ee3          	bnez	a0,c08 <ee_printf+0xb0>
     c10:	00090513          	mv	a0,s2
     c14:	d00ff0ef          	jal	114 <uart_write>
     c18:	0014c903          	lbu	s2,1(s1)
     c1c:	10090c63          	beqz	s2,d34 <ee_printf+0x1dc>
     c20:	00148493          	addi	s1,s1,1
     c24:	fe5ff06f          	j	c08 <ee_printf+0xb0>
     c28:	00000793          	li	a5,0
     c2c:	00134603          	lbu	a2,1(t1)
     c30:	00130813          	addi	a6,t1,1
     c34:	fe060713          	addi	a4,a2,-32
     c38:	0ff77713          	zext.b	a4,a4
     c3c:	00e9ea63          	bltu	s3,a4,c50 <ee_printf+0xf8>
     c40:	00271713          	slli	a4,a4,0x2
     c44:	01570733          	add	a4,a4,s5
     c48:	00072703          	lw	a4,0(a4)
     c4c:	00070067          	jr	a4
     c50:	fd060713          	addi	a4,a2,-48
     c54:	0ff77713          	zext.b	a4,a4
     c58:	12e97663          	bgeu	s2,a4,d84 <ee_printf+0x22c>
     c5c:	02a00713          	li	a4,42
     c60:	fff00693          	li	a3,-1
     c64:	14e60a63          	beq	a2,a4,db8 <ee_printf+0x260>
     c68:	fff00713          	li	a4,-1
     c6c:	0e960663          	beq	a2,s1,d58 <ee_printf+0x200>
     c70:	0df67593          	andi	a1,a2,223
     c74:	04c00513          	li	a0,76
     c78:	08a59a63          	bne	a1,a0,d0c <ee_printf+0x1b4>
     c7c:	00060313          	mv	t1,a2
     c80:	00184603          	lbu	a2,1(a6)
     c84:	03700513          	li	a0,55
     c88:	00180b93          	addi	s7,a6,1
     c8c:	fbf60593          	addi	a1,a2,-65
     c90:	0ff5f593          	zext.b	a1,a1
     c94:	04b56c63          	bltu	a0,a1,cec <ee_printf+0x194>
     c98:	00001537          	lui	a0,0x1
     c9c:	00259593          	slli	a1,a1,0x2
     ca0:	54050513          	addi	a0,a0,1344 # 1540 <main+0xc8>
     ca4:	00a585b3          	add	a1,a1,a0
     ca8:	0005a583          	lw	a1,0(a1)
     cac:	00058067          	jr	a1
     cb0:	0017e793          	ori	a5,a5,1
     cb4:	00080313          	mv	t1,a6
     cb8:	f75ff06f          	j	c2c <ee_printf+0xd4>
     cbc:	0107e793          	ori	a5,a5,16
     cc0:	00080313          	mv	t1,a6
     cc4:	f69ff06f          	j	c2c <ee_printf+0xd4>
     cc8:	0047e793          	ori	a5,a5,4
     ccc:	00080313          	mv	t1,a6
     cd0:	f5dff06f          	j	c2c <ee_printf+0xd4>
     cd4:	0207e793          	ori	a5,a5,32
     cd8:	00080313          	mv	t1,a6
     cdc:	f51ff06f          	j	c2c <ee_printf+0xd4>
     ce0:	0087e793          	ori	a5,a5,8
     ce4:	00080313          	mv	t1,a6
     ce8:	f45ff06f          	j	c2c <ee_printf+0xd4>
     cec:	000b8813          	mv	a6,s7
     cf0:	02500793          	li	a5,37
     cf4:	2cf60263          	beq	a2,a5,fb8 <ee_printf+0x460>
     cf8:	00f88023          	sb	a5,0(a7)
     cfc:	00084783          	lbu	a5,0(a6)
     d00:	00188893          	addi	a7,a7,1
     d04:	ee0782e3          	beqz	a5,be8 <ee_printf+0x90>
     d08:	2b40006f          	j	fbc <ee_printf+0x464>
     d0c:	fbf60593          	addi	a1,a2,-65
     d10:	0ff5f593          	zext.b	a1,a1
     d14:	03700513          	li	a0,55
     d18:	fcb56ce3          	bltu	a0,a1,cf0 <ee_printf+0x198>
     d1c:	00001537          	lui	a0,0x1
     d20:	00259593          	slli	a1,a1,0x2
     d24:	62050513          	addi	a0,a0,1568 # 1620 <main+0x1a8>
     d28:	00a585b3          	add	a1,a1,a0
     d2c:	0005a583          	lw	a1,0(a1)
     d30:	00058067          	jr	a1
     d34:	40848533          	sub	a0,s1,s0
     d38:	45c12083          	lw	ra,1116(sp)
     d3c:	45812403          	lw	s0,1112(sp)
     d40:	45412483          	lw	s1,1108(sp)
     d44:	45012903          	lw	s2,1104(sp)
     d48:	44812a03          	lw	s4,1096(sp)
     d4c:	00150513          	addi	a0,a0,1
     d50:	48010113          	addi	sp,sp,1152
     d54:	00008067          	ret
     d58:	00184603          	lbu	a2,1(a6)
     d5c:	00900313          	li	t1,9
     d60:	00180593          	addi	a1,a6,1
     d64:	fd060713          	addi	a4,a2,-48
     d68:	0ff77713          	zext.b	a4,a4
     d6c:	1ee37663          	bgeu	t1,a4,f58 <ee_printf+0x400>
     d70:	02a00713          	li	a4,42
     d74:	22e60263          	beq	a2,a4,f98 <ee_printf+0x440>
     d78:	00058813          	mv	a6,a1
     d7c:	00000713          	li	a4,0
     d80:	ef1ff06f          	j	c70 <ee_printf+0x118>
     d84:	00000693          	li	a3,0
     d88:	00900593          	li	a1,9
     d8c:	00269713          	slli	a4,a3,0x2
     d90:	00d70733          	add	a4,a4,a3
     d94:	00180813          	addi	a6,a6,1
     d98:	00171713          	slli	a4,a4,0x1
     d9c:	00c70733          	add	a4,a4,a2
     da0:	00084603          	lbu	a2,0(a6)
     da4:	fd070693          	addi	a3,a4,-48
     da8:	fd060713          	addi	a4,a2,-48
     dac:	0ff77713          	zext.b	a4,a4
     db0:	fce5fee3          	bgeu	a1,a4,d8c <ee_printf+0x234>
     db4:	eb5ff06f          	j	c68 <ee_printf+0x110>
     db8:	000a2683          	lw	a3,0(s4)
     dbc:	00234603          	lbu	a2,2(t1)
     dc0:	00230813          	addi	a6,t1,2
     dc4:	0006c663          	bltz	a3,dd0 <ee_printf+0x278>
     dc8:	004a0a13          	addi	s4,s4,4
     dcc:	e9dff06f          	j	c68 <ee_printf+0x110>
     dd0:	40d006b3          	neg	a3,a3
     dd4:	0107e793          	ori	a5,a5,16
     dd8:	004a0a13          	addi	s4,s4,4
     ddc:	e8dff06f          	j	c68 <ee_printf+0x110>
     de0:	0407e793          	ori	a5,a5,64
     de4:	01000613          	li	a2,16
     de8:	000a2583          	lw	a1,0(s4)
     dec:	004a0a13          	addi	s4,s4,4
     df0:	00088513          	mv	a0,a7
     df4:	a25ff0ef          	jal	818 <number>
     df8:	001bc783          	lbu	a5,1(s7)
     dfc:	00050893          	mv	a7,a0
     e00:	001b8313          	addi	t1,s7,1
     e04:	dc0796e3          	bnez	a5,bd0 <ee_printf+0x78>
     e08:	de1ff06f          	j	be8 <ee_printf+0x90>
     e0c:	00080b93          	mv	s7,a6
     e10:	00a00613          	li	a2,10
     e14:	fd5ff06f          	j	de8 <ee_printf+0x290>
     e18:	000b8813          	mv	a6,s7
     e1c:	0107f793          	andi	a5,a5,16
     e20:	004a0b93          	addi	s7,s4,4
     e24:	00180313          	addi	t1,a6,1
     e28:	1c078463          	beqz	a5,ff0 <mhzfreq+0x2f>
     e2c:	000a2603          	lw	a2,0(s4)
     e30:	00100713          	li	a4,1
     e34:	00c88023          	sb	a2,0(a7)
     e38:	62d75c63          	bge	a4,a3,1470 <mhzfreq+0x4af>
     e3c:	fff68a13          	addi	s4,a3,-1
     e40:	000a0613          	mv	a2,s4
     e44:	00e88533          	add	a0,a7,a4
     e48:	02000593          	li	a1,32
     e4c:	00612423          	sw	t1,8(sp)
     e50:	01012223          	sw	a6,4(sp)
     e54:	bd8ff0ef          	jal	22c <memset>
     e58:	00412803          	lw	a6,4(sp)
     e5c:	014508b3          	add	a7,a0,s4
     e60:	00812303          	lw	t1,8(sp)
     e64:	00184783          	lbu	a5,1(a6)
     e68:	000b8a13          	mv	s4,s7
     e6c:	d60792e3          	bnez	a5,bd0 <ee_printf+0x78>
     e70:	d79ff06f          	j	be8 <ee_printf+0x90>
     e74:	000b8813          	mv	a6,s7
     e78:	000a2303          	lw	t1,0(s4)
     e7c:	004a0a13          	addi	s4,s4,4
     e80:	16030063          	beqz	t1,fe0 <mhzfreq+0x1f>
     e84:	00034603          	lbu	a2,0(t1)
     e88:	0107f793          	andi	a5,a5,16
     e8c:	5a060c63          	beqz	a2,1444 <mhzfreq+0x483>
     e90:	00e30533          	add	a0,t1,a4
     e94:	00030713          	mv	a4,t1
     e98:	00e50a63          	beq	a0,a4,eac <ee_printf+0x354>
     e9c:	00174603          	lbu	a2,1(a4)
     ea0:	00170713          	addi	a4,a4,1
     ea4:	fe061ae3          	bnez	a2,e98 <ee_printf+0x340>
     ea8:	00070513          	mv	a0,a4
     eac:	40650bb3          	sub	s7,a0,t1
     eb0:	18078a63          	beqz	a5,1044 <mhzfreq+0x83>
     eb4:	03705263          	blez	s7,ed8 <ee_printf+0x380>
     eb8:	01730633          	add	a2,t1,s7
     ebc:	00088793          	mv	a5,a7
     ec0:	00034703          	lbu	a4,0(t1)
     ec4:	00130313          	addi	t1,t1,1
     ec8:	00178793          	addi	a5,a5,1
     ecc:	fee78fa3          	sb	a4,-1(a5)
     ed0:	fec318e3          	bne	t1,a2,ec0 <ee_printf+0x368>
     ed4:	017888b3          	add	a7,a7,s7
     ed8:	00180313          	addi	t1,a6,1
     edc:	56dbdc63          	bge	s7,a3,1454 <mhzfreq+0x493>
     ee0:	41768633          	sub	a2,a3,s7
     ee4:	00088513          	mv	a0,a7
     ee8:	02000593          	li	a1,32
     eec:	00612623          	sw	t1,12(sp)
     ef0:	01012423          	sw	a6,8(sp)
     ef4:	00d12223          	sw	a3,4(sp)
     ef8:	b34ff0ef          	jal	22c <memset>
     efc:	00812803          	lw	a6,8(sp)
     f00:	00412683          	lw	a3,4(sp)
     f04:	00c12303          	lw	t1,12(sp)
     f08:	00184783          	lbu	a5,1(a6)
     f0c:	00d506b3          	add	a3,a0,a3
     f10:	417688b3          	sub	a7,a3,s7
     f14:	ca079ee3          	bnez	a5,bd0 <ee_printf+0x78>
     f18:	cd1ff06f          	j	be8 <ee_printf+0x90>
     f1c:	000b8813          	mv	a6,s7
     f20:	fff00613          	li	a2,-1
     f24:	0ac68863          	beq	a3,a2,fd4 <mhzfreq+0x13>
     f28:	000a2583          	lw	a1,0(s4)
     f2c:	00088513          	mv	a0,a7
     f30:	01000613          	li	a2,16
     f34:	01012223          	sw	a6,4(sp)
     f38:	8e1ff0ef          	jal	818 <number>
     f3c:	00412803          	lw	a6,4(sp)
     f40:	004a0a13          	addi	s4,s4,4
     f44:	00050893          	mv	a7,a0
     f48:	00184783          	lbu	a5,1(a6)
     f4c:	00180313          	addi	t1,a6,1
     f50:	c80790e3          	bnez	a5,bd0 <ee_printf+0x78>
     f54:	c95ff06f          	j	be8 <ee_printf+0x90>
     f58:	00000513          	li	a0,0
     f5c:	00251713          	slli	a4,a0,0x2
     f60:	00a70733          	add	a4,a4,a0
     f64:	00158593          	addi	a1,a1,1
     f68:	00171713          	slli	a4,a4,0x1
     f6c:	00c70733          	add	a4,a4,a2
     f70:	0005c603          	lbu	a2,0(a1)
     f74:	fd070513          	addi	a0,a4,-48
     f78:	fd060713          	addi	a4,a2,-48
     f7c:	0ff77713          	zext.b	a4,a4
     f80:	fce37ee3          	bgeu	t1,a4,f5c <ee_printf+0x404>
     f84:	fff54713          	not	a4,a0
     f88:	41f75713          	srai	a4,a4,0x1f
     f8c:	00058813          	mv	a6,a1
     f90:	00e57733          	and	a4,a0,a4
     f94:	cddff06f          	j	c70 <ee_printf+0x118>
     f98:	000a2703          	lw	a4,0(s4)
     f9c:	00284603          	lbu	a2,2(a6)
     fa0:	004a0a13          	addi	s4,s4,4
     fa4:	fff74593          	not	a1,a4
     fa8:	41f5d593          	srai	a1,a1,0x1f
     fac:	00b77733          	and	a4,a4,a1
     fb0:	00280813          	addi	a6,a6,2
     fb4:	cbdff06f          	j	c70 <ee_printf+0x118>
     fb8:	00084783          	lbu	a5,0(a6)
     fbc:	00f88023          	sb	a5,0(a7)
     fc0:	00184783          	lbu	a5,1(a6)
     fc4:	00188893          	addi	a7,a7,1
     fc8:	00180313          	addi	t1,a6,1
     fcc:	c00792e3          	bnez	a5,bd0 <ee_printf+0x78>
     fd0:	c19ff06f          	j	be8 <ee_printf+0x90>
     fd4:	0017e793          	ori	a5,a5,1
     fd8:	00800693          	li	a3,8
     fdc:	f4dff06f          	j	f28 <ee_printf+0x3d0>
     fe0:	00001337          	lui	t1,0x1
     fe4:	0107f793          	andi	a5,a5,16
     fe8:	4f430313          	addi	t1,t1,1268 # 14f4 <main+0x7c>
     fec:	ea5ff06f          	j	e90 <ee_printf+0x338>
     ff0:	00100793          	li	a5,1
     ff4:	42d7d663          	bge	a5,a3,1420 <mhzfreq+0x45f>
     ff8:	fff68613          	addi	a2,a3,-1
     ffc:	00088513          	mv	a0,a7
    1000:	02000593          	li	a1,32
    1004:	00612623          	sw	t1,12(sp)
    1008:	01012423          	sw	a6,8(sp)
    100c:	00d12223          	sw	a3,4(sp)
    1010:	a1cff0ef          	jal	22c <memset>
    1014:	00412683          	lw	a3,4(sp)
    1018:	000a2783          	lw	a5,0(s4)
    101c:	fff50893          	addi	a7,a0,-1
    1020:	00812803          	lw	a6,8(sp)
    1024:	00c12303          	lw	t1,12(sp)
    1028:	00d888b3          	add	a7,a7,a3
    102c:	00f88023          	sb	a5,0(a7)
    1030:	00188893          	addi	a7,a7,1
    1034:	00184783          	lbu	a5,1(a6)
    1038:	000b8a13          	mv	s4,s7
    103c:	b8079ae3          	bnez	a5,bd0 <ee_printf+0x78>
    1040:	ba9ff06f          	j	be8 <ee_printf+0x90>
    1044:	3edbdc63          	bge	s7,a3,143c <mhzfreq+0x47b>
    1048:	41768633          	sub	a2,a3,s7
    104c:	00088513          	mv	a0,a7
    1050:	02000593          	li	a1,32
    1054:	01012623          	sw	a6,12(sp)
    1058:	00612423          	sw	t1,8(sp)
    105c:	00d12223          	sw	a3,4(sp)
    1060:	9ccff0ef          	jal	22c <memset>
    1064:	00412683          	lw	a3,4(sp)
    1068:	00c12803          	lw	a6,12(sp)
    106c:	00812303          	lw	t1,8(sp)
    1070:	00d506b3          	add	a3,a0,a3
    1074:	417688b3          	sub	a7,a3,s7
    1078:	fffb8693          	addi	a3,s7,-1
    107c:	e39ff06f          	j	eb4 <ee_printf+0x35c>
    1080:	06c00613          	li	a2,108
    1084:	0027e793          	ori	a5,a5,2
    1088:	d8c304e3          	beq	t1,a2,e10 <ee_printf+0x2b8>
    108c:	000a2583          	lw	a1,0(s4)
    1090:	00a00613          	li	a2,10
    1094:	004a0a13          	addi	s4,s4,4
    1098:	d59ff06f          	j	df0 <ee_printf+0x298>
    109c:	06c00713          	li	a4,108
    10a0:	16e30863          	beq	t1,a4,1210 <mhzfreq+0x24f>
    10a4:	43812c23          	sw	s8,1080(sp)
    10a8:	000a2303          	lw	t1,0(s4)
    10ac:	004a0c13          	addi	s8,s4,4
    10b0:	00034703          	lbu	a4,0(t1)
    10b4:	2a070263          	beqz	a4,1358 <mhzfreq+0x397>
    10b8:	00000593          	li	a1,0
    10bc:	00000513          	li	a0,0
    10c0:	00100a13          	li	s4,1
    10c4:	06300613          	li	a2,99
    10c8:	26e65e63          	bge	a2,a4,1344 <mhzfreq+0x383>
    10cc:	51eb8837          	lui	a6,0x51eb8
    10d0:	51f80813          	addi	a6,a6,1311 # 51eb851f <MEMORY_SIZE+0x51ea851f>
    10d4:	03073833          	mulhu	a6,a4,a6
    10d8:	06400e93          	li	t4,100
    10dc:	00001637          	lui	a2,0x1
    10e0:	4a460613          	addi	a2,a2,1188 # 14a4 <main+0x2c>
    10e4:	ccccde37          	lui	t3,0xccccd
    10e8:	ccde0e13          	addi	t3,t3,-819 # cccccccd <GPIO_BASE_ADDR+0x2ccccccd>
    10ec:	002a0a33          	add	s4,s4,sp
    10f0:	00585813          	srli	a6,a6,0x5
    10f4:	03d80eb3          	mul	t4,a6,t4
    10f8:	01060833          	add	a6,a2,a6
    10fc:	00084f03          	lbu	t5,0(a6)
    1100:	00250833          	add	a6,a0,sp
    1104:	00250513          	addi	a0,a0,2
    1108:	01e80c23          	sb	t5,24(a6)
    110c:	41d70833          	sub	a6,a4,t4
    1110:	03c83733          	mulhu	a4,a6,t3
    1114:	00375713          	srli	a4,a4,0x3
    1118:	00e60e33          	add	t3,a2,a4
    111c:	000e4e83          	lbu	t4,0(t3)
    1120:	00271e13          	slli	t3,a4,0x2
    1124:	00ee0733          	add	a4,t3,a4
    1128:	00171713          	slli	a4,a4,0x1
    112c:	01da0c23          	sb	t4,24(s4)
    1130:	40e80733          	sub	a4,a6,a4
    1134:	00e60633          	add	a2,a2,a4
    1138:	00064603          	lbu	a2,0(a2)
    113c:	00250733          	add	a4,a0,sp
    1140:	00158593          	addi	a1,a1,1
    1144:	00c70c23          	sb	a2,24(a4)
    1148:	00400713          	li	a4,4
    114c:	00150a13          	addi	s4,a0,1
    1150:	02e58e63          	beq	a1,a4,118c <mhzfreq+0x1cb>
    1154:	00b30733          	add	a4,t1,a1
    1158:	00074703          	lbu	a4,0(a4)
    115c:	002a0633          	add	a2,s4,sp
    1160:	02e00513          	li	a0,46
    1164:	00a60c23          	sb	a0,24(a2)
    1168:	001a0513          	addi	a0,s4,1
    116c:	002a0a13          	addi	s4,s4,2
    1170:	f4071ae3          	bnez	a4,10c4 <mhzfreq+0x103>
    1174:	03000713          	li	a4,48
    1178:	00250533          	add	a0,a0,sp
    117c:	00e50c23          	sb	a4,24(a0)
    1180:	00158593          	addi	a1,a1,1
    1184:	00400713          	li	a4,4
    1188:	fce596e3          	bne	a1,a4,1154 <mhzfreq+0x193>
    118c:	0107f793          	andi	a5,a5,16
    1190:	02079663          	bnez	a5,11bc <mhzfreq+0x1fb>
    1194:	2cda5663          	bge	s4,a3,1460 <mhzfreq+0x49f>
    1198:	41468633          	sub	a2,a3,s4
    119c:	00088513          	mv	a0,a7
    11a0:	02000593          	li	a1,32
    11a4:	00d12223          	sw	a3,4(sp)
    11a8:	884ff0ef          	jal	22c <memset>
    11ac:	00412683          	lw	a3,4(sp)
    11b0:	00d506b3          	add	a3,a0,a3
    11b4:	414688b3          	sub	a7,a3,s4
    11b8:	fffa0693          	addi	a3,s4,-1
    11bc:	03405063          	blez	s4,11dc <mhzfreq+0x21b>
    11c0:	00088513          	mv	a0,a7
    11c4:	000a0613          	mv	a2,s4
    11c8:	01810593          	addi	a1,sp,24
    11cc:	00d12223          	sw	a3,4(sp)
    11d0:	88cff0ef          	jal	25c <memcpy>
    11d4:	00412683          	lw	a3,4(sp)
    11d8:	014508b3          	add	a7,a0,s4
    11dc:	00da5e63          	bge	s4,a3,11f8 <mhzfreq+0x237>
    11e0:	41468a33          	sub	s4,a3,s4
    11e4:	00088513          	mv	a0,a7
    11e8:	000a0613          	mv	a2,s4
    11ec:	02000593          	li	a1,32
    11f0:	83cff0ef          	jal	22c <memset>
    11f4:	014508b3          	add	a7,a0,s4
    11f8:	001bc783          	lbu	a5,1(s7)
    11fc:	000c0a13          	mv	s4,s8
    1200:	001b8313          	addi	t1,s7,1
    1204:	43812c03          	lw	s8,1080(sp)
    1208:	9c0794e3          	bnez	a5,bd0 <ee_printf+0x78>
    120c:	9ddff06f          	j	be8 <ee_printf+0x90>
    1210:	00001637          	lui	a2,0x1
    1214:	000a2e03          	lw	t3,0(s4)
    1218:	4a460613          	addi	a2,a2,1188 # 14a4 <main+0x2c>
    121c:	004a0a13          	addi	s4,s4,4
    1220:	00000313          	li	t1,0
    1224:	00000513          	li	a0,0
    1228:	00600e93          	li	t4,6
    122c:	03a00f13          	li	t5,58
    1230:	0100006f          	j	1240 <mhzfreq+0x27f>
    1234:	005b8bb3          	add	s7,s7,t0
    1238:	01eb8423          	sb	t5,8(s7)
    123c:	00350513          	addi	a0,a0,3
    1240:	006e0733          	add	a4,t3,t1
    1244:	00074703          	lbu	a4,0(a4)
    1248:	01010293          	addi	t0,sp,16
    124c:	00130313          	addi	t1,t1,1
    1250:	00475593          	srli	a1,a4,0x4
    1254:	00b605b3          	add	a1,a2,a1
    1258:	0005c583          	lbu	a1,0(a1)
    125c:	00f77713          	andi	a4,a4,15
    1260:	00e60733          	add	a4,a2,a4
    1264:	00074f83          	lbu	t6,0(a4)
    1268:	00550733          	add	a4,a0,t0
    126c:	00b70423          	sb	a1,8(a4)
    1270:	00150713          	addi	a4,a0,1
    1274:	005705b3          	add	a1,a4,t0
    1278:	01f58423          	sb	t6,8(a1)
    127c:	00250b93          	addi	s7,a0,2
    1280:	fbd31ae3          	bne	t1,t4,1234 <mhzfreq+0x273>
    1284:	0107f793          	andi	a5,a5,16
    1288:	02079c63          	bnez	a5,12c0 <mhzfreq+0x2ff>
    128c:	1cdbde63          	bge	s7,a3,1468 <mhzfreq+0x4a7>
    1290:	41768633          	sub	a2,a3,s7
    1294:	00088513          	mv	a0,a7
    1298:	02000593          	li	a1,32
    129c:	01012623          	sw	a6,12(sp)
    12a0:	00d12223          	sw	a3,4(sp)
    12a4:	00e12423          	sw	a4,8(sp)
    12a8:	f85fe0ef          	jal	22c <memset>
    12ac:	00412683          	lw	a3,4(sp)
    12b0:	00c12803          	lw	a6,12(sp)
    12b4:	00d506b3          	add	a3,a0,a3
    12b8:	417688b3          	sub	a7,a3,s7
    12bc:	00812683          	lw	a3,8(sp)
    12c0:	00088513          	mv	a0,a7
    12c4:	000b8613          	mv	a2,s7
    12c8:	01810593          	addi	a1,sp,24
    12cc:	01012423          	sw	a6,8(sp)
    12d0:	00d12223          	sw	a3,4(sp)
    12d4:	f89fe0ef          	jal	25c <memcpy>
    12d8:	00412683          	lw	a3,4(sp)
    12dc:	00812803          	lw	a6,8(sp)
    12e0:	017508b3          	add	a7,a0,s7
    12e4:	02dbd263          	bge	s7,a3,1308 <mhzfreq+0x347>
    12e8:	41768bb3          	sub	s7,a3,s7
    12ec:	00088513          	mv	a0,a7
    12f0:	000b8613          	mv	a2,s7
    12f4:	02000593          	li	a1,32
    12f8:	01012223          	sw	a6,4(sp)
    12fc:	f31fe0ef          	jal	22c <memset>
    1300:	00412803          	lw	a6,4(sp)
    1304:	017508b3          	add	a7,a0,s7
    1308:	00284783          	lbu	a5,2(a6)
    130c:	00280313          	addi	t1,a6,2
    1310:	8c0790e3          	bnez	a5,bd0 <ee_printf+0x78>
    1314:	8d5ff06f          	j	be8 <ee_printf+0x90>
    1318:	06c00713          	li	a4,108
    131c:	0407e793          	ori	a5,a5,64
    1320:	d8e312e3          	bne	t1,a4,10a4 <mhzfreq+0xe3>
    1324:	00001637          	lui	a2,0x1
    1328:	000a2e03          	lw	t3,0(s4)
    132c:	4cc60613          	addi	a2,a2,1228 # 14cc <main+0x54>
    1330:	004a0a13          	addi	s4,s4,4
    1334:	eedff06f          	j	1220 <mhzfreq+0x25f>
    1338:	00080b93          	mv	s7,a6
    133c:	00800613          	li	a2,8
    1340:	aa9ff06f          	j	de8 <ee_printf+0x290>
    1344:	00900613          	li	a2,9
    1348:	02e64263          	blt	a2,a4,136c <mhzfreq+0x3ab>
    134c:	00001637          	lui	a2,0x1
    1350:	4a460613          	addi	a2,a2,1188 # 14a4 <main+0x2c>
    1354:	de1ff06f          	j	1134 <mhzfreq+0x173>
    1358:	03000713          	li	a4,48
    135c:	00100a13          	li	s4,1
    1360:	00e10c23          	sb	a4,24(sp)
    1364:	000a0593          	mv	a1,s4
    1368:	dedff06f          	j	1154 <mhzfreq+0x193>
    136c:	ccccd837          	lui	a6,0xccccd
    1370:	ccd80813          	addi	a6,a6,-819 # cccccccd <GPIO_BASE_ADDR+0x2ccccccd>
    1374:	03073833          	mulhu	a6,a4,a6
    1378:	00001637          	lui	a2,0x1
    137c:	4a460613          	addi	a2,a2,1188 # 14a4 <main+0x2c>
    1380:	00250eb3          	add	t4,a0,sp
    1384:	000a0513          	mv	a0,s4
    1388:	00385813          	srli	a6,a6,0x3
    138c:	01060e33          	add	t3,a2,a6
    1390:	000e4f03          	lbu	t5,0(t3)
    1394:	00281e13          	slli	t3,a6,0x2
    1398:	010e0833          	add	a6,t3,a6
    139c:	00181813          	slli	a6,a6,0x1
    13a0:	01ee8c23          	sb	t5,24(t4)
    13a4:	41070733          	sub	a4,a4,a6
    13a8:	d8dff06f          	j	1134 <mhzfreq+0x173>
    13ac:	03010413          	addi	s0,sp,48
    13b0:	00040893          	mv	a7,s0
    13b4:	00088023          	sb	zero,0(a7)
    13b8:	03014903          	lbu	s2,48(sp)
    13bc:	840914e3          	bnez	s2,c04 <ee_printf+0xac>
    13c0:	45c12083          	lw	ra,1116(sp)
    13c4:	45812403          	lw	s0,1112(sp)
    13c8:	45412483          	lw	s1,1108(sp)
    13cc:	45012903          	lw	s2,1104(sp)
    13d0:	44812a03          	lw	s4,1096(sp)
    13d4:	00000513          	li	a0,0
    13d8:	48010113          	addi	sp,sp,1152
    13dc:	00008067          	ret
    13e0:	0027e793          	ori	a5,a5,2
    13e4:	00080b93          	mv	s7,a6
    13e8:	ca5ff06f          	j	108c <mhzfreq+0xcb>
    13ec:	43812c23          	sw	s8,1080(sp)
    13f0:	00080b93          	mv	s7,a6
    13f4:	cb5ff06f          	j	10a8 <mhzfreq+0xe7>
    13f8:	00080b93          	mv	s7,a6
    13fc:	9e9ff06f          	j	de4 <ee_printf+0x28c>
    1400:	43812c23          	sw	s8,1080(sp)
    1404:	0407e793          	ori	a5,a5,64
    1408:	00080b93          	mv	s7,a6
    140c:	c9dff06f          	j	10a8 <mhzfreq+0xe7>
    1410:	0407e793          	ori	a5,a5,64
    1414:	00080b93          	mv	s7,a6
    1418:	01000613          	li	a2,16
    141c:	9cdff06f          	j	de8 <ee_printf+0x290>
    1420:	000a2783          	lw	a5,0(s4)
    1424:	00188893          	addi	a7,a7,1
    1428:	000b8a13          	mv	s4,s7
    142c:	fef88fa3          	sb	a5,-1(a7)
    1430:	00184783          	lbu	a5,1(a6)
    1434:	f8079e63          	bnez	a5,bd0 <ee_printf+0x78>
    1438:	fb0ff06f          	j	be8 <ee_printf+0x90>
    143c:	fff68693          	addi	a3,a3,-1
    1440:	a75ff06f          	j	eb4 <ee_printf+0x35c>
    1444:	00000b93          	li	s7,0
    1448:	a80798e3          	bnez	a5,ed8 <ee_printf+0x380>
    144c:	bed04ee3          	bgtz	a3,1048 <mhzfreq+0x87>
    1450:	00180313          	addi	t1,a6,1
    1454:	00184783          	lbu	a5,1(a6)
    1458:	f6079c63          	bnez	a5,bd0 <ee_printf+0x78>
    145c:	f8cff06f          	j	be8 <ee_printf+0x90>
    1460:	fff68693          	addi	a3,a3,-1
    1464:	d59ff06f          	j	11bc <mhzfreq+0x1fb>
    1468:	fff68693          	addi	a3,a3,-1
    146c:	e55ff06f          	j	12c0 <mhzfreq+0x2ff>
    1470:	00e888b3          	add	a7,a7,a4
    1474:	bc1ff06f          	j	1034 <mhzfreq+0x73>

Disassembly of section .text.startup:

00001478 <main>:
    1478:	ff010113          	addi	sp,sp,-16
    147c:	00112623          	sw	ra,12(sp)
    1480:	98cff0ef          	jal	60c <uart_init>
    1484:	4c617537          	lui	a0,0x4c617
    1488:	97350513          	addi	a0,a0,-1677 # 4c616973 <MEMORY_SIZE+0x4c606973>
    148c:	01000593          	li	a1,16
    1490:	910ff0ef          	jal	5a0 <uart_write_int>
    1494:	00c12083          	lw	ra,12(sp)
    1498:	00000513          	li	a0,0
    149c:	01010113          	addi	sp,sp,16
    14a0:	00008067          	ret
