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


$ echo 'MeEeOwWMeeEEEoOOwwWWWmMmeOoOwMEooWMeeOWwMMMmM' | baseMEOW --decode


$ echo 'MMmeEOOowMEOWMMmEOowMEeEeEOWwwmeOOOooWmMmMMMeeeowwWmMMeEEOOWWWmmEOoOowwmmeoOWMmMmeEooWMEEeoWwmeOoOoOWWwWWmeEEoOOwWmmeoOwW' | baseMEOW --decode
30+0 records in
30+0 records out
30 bytes transferred in 0.000061 secs (491520 bytes/sec)

```