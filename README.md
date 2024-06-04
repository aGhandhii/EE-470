# GameBoy APU MIDI Synthesizer

A GameBoy Audio Processing Unit modified to play MIDI sequences 

<img src="https://img.shields.io/badge/License-The_Unlicense-red" />

## How to Use

Use the *midibench.py* Python script to translate MIDI sequences to a sequence understandable by the APU.

> Note: The script requires the [MIDO](https://mido.readthedocs.io/en/stable/) Python library to work properly

Given a Monophonic, 4-channel MIDI sequence (as a .mid file), make sure to set line 4 of `midibench.py` to the sequence:

```python
mid = MidiFile("name_of_sequence.mid")
```

Run the script to generate 4 `.mif` files for the APU

``` shell
# From the '/audio' folder
python midibench.py
```

Place the `.mif` files into their corresponding channels in `./src/top.sv` (line 66):

```verilog
initial begin : loadChannelROM
    $readmemb("./audio/pulse_1.mif", ch1_ROM);
    $readmemb("./audio/pulse_2.mif", ch2_ROM);
    $readmemb("./audio/custom.mif", ch3_ROM);
    $readmemb("./audio/noise.mif", ch4_ROM);
end
```

Synthesize the design with `top_top.sv` as the top-level module, the sequence will be played in the authentic soundfont of the GameBoy!

This design uses a PWM converter to turn APU outputs to PWM, to get audio out, either route the PWM signal through an audio port, or use GPIO pins connected directly to an AUX cable.

## Future Work
- Add support for Polyphonic MIDI sequences
- Tie MIDI 'instrument' metadata to custom wave channel instances

## Credit  
[NightShade's GameBoy Sound Article](https://nightshade256.github.io/2021/03/27/gb-sound-emulation.html)  
[Pan Docs](https://gbdev.io/pandocs/)    
[Verilog Boy](https://github.com/zephray/VerilogBoy)
