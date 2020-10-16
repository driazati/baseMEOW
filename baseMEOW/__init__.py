import sys
import argparse

STRING = "meow"
padding = "~"


string_wrapped = STRING + STRING[0]
next_char_map = {
    c: string_wrapped[index + 1] for index, c in enumerate(string_wrapped[:-1])
}


def next_char(c):
    next_c = next_char_map[c.lower()]
    return next_c.upper() if c.isupper() else next_c.lower()


def encode(the_bytes):
    bits = "".join(["{:08b}".format(byte) for byte in the_bytes])
    encoded = "M"
    for i in range(0, len(bits), 2):
        two_bits = bits[i : i + 2]
        needs_padding = False
        if len(two_bits) != 2:
            # add some padding at the end
            needs_padding = True
            # left pad with zeros
            two_bits = two_bits.zfill(2)

        if two_bits == "00":
            # same
            encoded += encoded[-1]
        elif two_bits == "10":
            # swap case
            encoded += encoded[-1].swapcase()
        elif two_bits == "01":
            # swap case, next letter
            encoded += next_char(encoded[-1]).swapcase()
        elif two_bits == "11":
            # next letter
            encoded += next_char(encoded[-1])
        else:
            raise RuntimeError("Bad bits!", two_bits)

        if needs_padding:
            encoded += padding

    return encoded


def decode(encoded_text):
    bit_string = ""
    last_c = encoded_text[0]
    for c in encoded_text[1:]:
        if c == "\n":
            continue

        if c == padding:
            # it's the last thing
            pass
        if c == last_c:
            # same char, same case
            bit_string += "00"
        elif c.lower() == last_c.lower():
            # same char, different case
            bit_string += "10"
        elif (
            c.lower() == next_char(last_c).lower()
            and c.isupper() == next_char(last_c).isupper()
        ):
            # next char, same case
            bit_string += "11"
        elif c.lower() == next_char(last_c).lower():
            # next char, different case
            bit_string += "01"
        else:
            raise RuntimeError("Bad chars!", last_c, c, next_char(last_c))
        last_c = c

    the_bytes = [bit_string[i : i + 8] for i in range(0, len(bit_string), 8)]
    the_bytes = bytes([int(b, 2) for b in the_bytes])
    return the_bytes


def main():
    parser = argparse.ArgumentParser(
        description="Encode and decode information as meows"
    )
    parser.add_argument(
        "--decode", action="store_true", help="decode instead of encoding"
    )
    args = parser.parse_args()

    text = sys.stdin.buffer.read()
    if args.decode:
        result = decode(text.decode("ascii"))
        try:
            print(result.decode("utf-8"), end="")
        except UnicodeError:
            print(result.hex())
    else:
        result = encode(text)
        print(result)


if __name__ == "__main__":
    main()


assert decode(encode("doggies".encode("utf-8"))).decode("utf-8") == "doggies"
