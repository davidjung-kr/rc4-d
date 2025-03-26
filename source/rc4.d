module rc4;

import std.stdio:writeln, writef;

/** 
 * RC4-d; Simple RC4 Encryption/Decryption Library
 * 
 * Authors: David Jung, github.com/davidjung-kr
 * License: LGPL-2.1
 * Refer: [RC4(wikipedia)](https://en.wikipedia.org/wiki/RC4)
 * Examples:
 * --------------------
 * string love = "jesus";
 * string key = "this is my key";
 * RC4 d = RC4(key);
 * int[] encrypted = d.encrypFromText(love);
 * assert(d.decryption(encrypted)==love);
 * --------------------
 */
public struct RC4 {
    private int verbose;
    private immutable ushort S256 = 256;
    private string key;
    int[S256] vecS;
    int[S256] vecT;

    this(string key, int verbose=-1) {
        this.key = key;
        this.verbose = verbose;
        if (key.length>S256) {
            throw new Exception("Wrong Key size");
        }
        if(this.verbose==0) {
            writeln("### RC4.this ###");
            writef("(key)%s:", key);
            for(int i=0; i<key.length; i++) {
                writef("%x ", key[i]);
            }
            writeln();
        }
    }

    public int[] encrypFromText(string text) {
        int[] chars = new int[text.length];
        for (int i=0; i<text.length; i++) {
            chars[i] = cast(int)text[i];
        }
        return encryption(chars);
    }

    public char[] decryptToText(int[] encrypted) {
        int[] result = decryption(encrypted);
        char[] chars = new char[result.length];
        foreach (i, val; result) {
            chars[i] = cast(char)val;
        }
        return chars;
    }

    public int[] encryption(int[] original){
        initS();
        initKey();
        performKSA();
        int[] stream = performPRGA(original);
        int[] result = performXOR(original, stream);
        if(this.verbose==0) {
            writeln("### encryption result ###");
            writeln(result);
            writeln();
        }
        return result;
    }
    
    public int[] decryption(int[] encrypted) {
        initS();
        initKey();
        performKSA();
        int[] stream = performPRGA(encrypted);
        return performXOR(encrypted, stream);
    }

    private void initS() {
        for (int i=0; i<S256; i++) {
            vecS[i] = i;
        }
        if(this.verbose==0) {
            writeln("### init vector S ###");
            writeln(vecS);
            writeln();
        }
    }

    private void initKey() {
        int pnt = 0;
        for(int i=0; i<S256; i++) {
            if (pnt>=this.key.length) {
                pnt = 0;
            }
            vecT[i] = this.key[pnt];
            pnt +=1;
        }
        if(this.verbose==0) {
            writeln("### init vector T(Key) ###");
            writeln(vecT);
            writeln();
        }
    }

    private void performKSA() {
        int j=0;
        for(int i=0; i<S256; i++) {
            j = (j+vecS[i]+vecT[i]) % S256;
            int bf = vecS[i];
            vecS[i] = vecS[j];
            vecS[j] = bf;
        }
        if(this.verbose==0) {
            writeln("### performKSA ###");
            writeln();
        }
    }

    private int[] performPRGA(int[] o) {
        int i = 0;
        int j = 0;
        int[] key_stream = new int[o.length];

        for(int k=0; k<key_stream.length; k++) {
            i = (i + 1) % S256;
            j = (j + vecS[i]) % S256;
            int si = vecS[i];
            vecS[i] = vecS[j];
            vecS[j] = si;
            key_stream[k] = vecS[(vecS[i] + vecS[j]) % S256];
        }

        if(this.verbose==0) {
            writeln("### performPRGA ###");
            writeln();
        }
        return key_stream;
    }

    private int[] performXOR(int[] text, int[] key_stream) {
        int[] result = new int[text.length];
        for (int i=0; i<text.length; i++) {
            result[i] = key_stream[i] ^ text[i];
        }

        if(this.verbose==0) {
            writeln("### perform XOR ###");
            writeln();
        }
        return result;
    }
}

unittest {
    string love = "jesus";
    string key = "this is my key";

    RC4 d = RC4(key);
    int[] encrypted = d.encrypFromText(love);
    assert(d.decryption(encrypted)==love);
}