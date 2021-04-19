# baseMEOW

baseMEOW is an encoder/decoder that can store binary as a string of characters that spell out "meow" in some way, similar to [`base64`](https://linux.die.net/man/1/base64).

## Installation

```bash
# requires Python 3.7+
pip install baseMEOW
```

## Usage

### Encoding

```bash
$ echo 'hello' | baseMEOW
MeEeeOoWmEeooWwmmEeowwwWw

$ echo 'im a kitty' | baseMEOW
MeEeOwWMeeEEEoOOwwWWWmMmeOoOwMEooWMeeOWwMMMmM

$ dd if=/dev/urandom bs=1 count=30 | baseMEOW
30+0 records in
30+0 records out
30 bytes transferred in 0.000061 secs (491520 bytes/sec)
MMmeEOOowMEOWMMmEOowMEeEeEOWwwmeOOOooWmMmMMMeeeowwWmMMeEEOOWWWmmEOoOowwmmeoOWMmMmeEooWMEEeoWwmeOoOoOWWwWWmeEEoOOwWmmeoOwW
```

### Decoding

```bash
$ echo 'MeEeeOoWmEeooWwmmEeowwwWw' | baseMEOW --decode
hello
$ echo 'MeEeOwWMeeEEEoOOwwWWWmMmeOoOwMEooWMeeOWwMMMmM' | baseMEOW --decode
im a kitty
$
# non UTF-8 data is printed as hex
$ echo 'MMmeEOOowMEOWMMmEOowMEeEeEOWwwmeOOOooWmMmMMMeeeowwWmMMeEEOOWWWmmEOoOowwmmeoOWMmMmeEooWMEEeoWwmeOoOoOWWwWWmeEEoOOwWmmeoOwW' | baseMEOW --decode
2ecb7fc9edeabe3d085a810f2618cc11eaccfbeae47cb6f6ab28786193e6
```

## Benchmarks

See [`benchmark.py`](benchmark.py)

| test case          | base64 runtime (ms) | baseMEOW runtime (ms) | base64 size (bytes) | baseMEOW size (bytes) |
| ------------------ | ------------------- | --------------------- | ------------------- | --------------------- |
| 10 characters      | 11.06               | 202.69                | 17                  | 42                    |
| 1000 characters    | 12.05               | 168.23                | 1337                | 4002                  |
| 10000 characters   | 11.57               | 159.92                | 13337               | 40002                 |
| 1000000 characters | 34.74               | 2500.45               | 1333337             | 4000002               |

### NASM Benchmarks

Using the [assembly encoder](meow.nasm) the runtimes are much better.

```bash
# build meow.nasm
make run
```

| test case          | base64 runtime (ms) | baseMEOW runtime (ms) | base64 size (bytes) | baseMEOW size (bytes) |
| ------------------ | ------------------- | --------------------- | ------------------- | --------------------- |
| 10 characters      | 3.8                 | 2.84                  | 17                  | 41                    |
| 1000 characters    | 4.24                | 3.02                  | 1354                | 4001                  |
| 10000 characters   | 4.26                | 3.76                  | 13512               | 40001                 |
| 1000000 characters | 9.83                | 34.5                  | 1350880             | 4000001               |
