# baseMEOW

baseMEOW is an encoder/decoder that can store binary as a string of characters that spell out "meow" in some way, similar to [`base64`](https://linux.die.net/man/1/base64).

## Installation

```bash
# requires Python 3.6+
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

test case|base64 runtime (ms)|baseMEOW runtime (ms)|base64 size (bytes)|baseMEOW size (bytes)
---|---|---|---|---
10 characters|10.65|17|155.07|42
1000 characters|11.53|1337|139.65|4002
10000 characters|10.72|13337|162.66|40002
1000000 characters|37.09|1333337|2278.86|4000002