# rc4-d
Simple RC4 Encryption/Decryption Library.

# ⚠️ Warning ⚠️
## ENG
 * The RC4 algorithm has security vulnerabilities, so it should not be used in production environments unless absolutely necessary.
 * See more [here(RC4#Security; Wikipedia)](https://en.wikipedia.org/wiki/RC4#Security).
## KOR
 * RC4 알고리즘에 보안 취약점이 존재하므로 특별한 경우가 아니라면 실제 프로덕션 환경에서 사용하지 마세요.
 * [여기(RC4#Security; Wikipedia)](https://en.wikipedia.org/wiki/RC4#Security) 읽어보셈.

# Tested
  * ldc2 - 1.40.1 (DMD v2.110.0, LLVM 19.1.7)
  * DUB
## How to
```.d
git clone https://github.com/davidjung-kr/rc4-d
cd rc4-d
dub test
```
