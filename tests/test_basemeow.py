import unittest
import baseMEOW


class TestStringMethods(unittest.TestCase):
    def check_string(self, string):
        encoded = baseMEOW.encode(string.encode("utf-8"))
        decoded = baseMEOW.decode(encoded).decode("utf-8")
        self.assertEqual(decoded, string)

    def check_hex_data(self, hex):
        encoded = baseMEOW.encode(bytes.fromhex(hex))
        decoded = baseMEOW.decode(encoded)
        self.assertEqual(decoded.hex(), hex)

    def test_encode_decode(self):
        # check strings
        self.check_string("hello")
        self.check_string("bye")
        self.check_string("wow\n\tmeow\nok")
        self.check_string("a" * 1000 + "b" * 200)

        # check binary
        self.check_hex_data("190231bcdecc")
        self.check_hex_data("beef")
        self.check_hex_data("cafe")


if __name__ == "__main__":
    unittest.main()