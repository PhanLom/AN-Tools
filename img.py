# -*- coding: utf-8 -*-
import re
import sys
import os
# img.py
import re

def decode_from_string(input_file, output_file):
    with open(input_file, "r", encoding="utf-8") as f:
        data = f.read()
    bytes_data = bytes(int(b, 16) for b in re.findall(r'\\x([0-9A-Fa-f]{2})', data))
    with open(output_file, "wb") as f:
        f.write(bytes_data)
    print(f"Done! File {output_file} created.")

def encode_to_string(image_file, output_txt):
    with open(image_file, "rb") as f:
        img_bytes = f.read()
    lua_string = ''.join(f'\\x{b:02X}' for b in img_bytes)
    with open(output_txt, "w", encoding="utf-8") as f:
        f.write(lua_string)
    print(f"Done! Bytes saved to {output_txt}")

def main():
    if len(sys.argv) < 2:
        print("Usage:")
        print("  python img.py encode input.png output.txt")
        print("  python img.py decode input.txt output.png")
        sys.exit(1)
    mode = sys.argv[1]
    if mode == "encode" and len(sys.argv) == 4:
        encode_to_string(sys.argv[2], sys.argv[3])
    elif mode == "decode" and len(sys.argv) == 4:
        decode_from_string(sys.argv[2], sys.argv[3])
    else:
        print("Invalid arguments.")
        print("  python img.py encode input.png output.txt")
        print("  python img.py decode input.txt output.png")

if __name__ == "__main__":
    main()