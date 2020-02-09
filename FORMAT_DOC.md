# informal document for the 80x60 bitmap video format

the TetrisVideo format uses 80x60 1-bit frames at 24fps

these frames are stored as chunks of 600 bytes

there are no headers or footers

each group of 8 pixels is stored as one byte, with the lowest bit being the leftmost pixel.

(this is in reverse of the order used in numbering)
