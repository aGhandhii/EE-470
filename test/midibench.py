from mido import Message, MidiFile, MidiTrack, MetaMessage, tick2second
import pandas as pd
import math

mid = MidiFile("Smboverworld.mid")

clock_T = 1/math.pow(2,22)
ticks_per_beat = mid.ticks_per_beat
tempo = None

for i, track in enumerate(mid.tracks): # find tempo
    for msg in track:
        if msg.type == 'set_tempo':
            tempo = msg.tempo
            break
    if tempo is not None:
        break

def midi_to_freq(midi_note):
    return 2**((midi_note-69)/12) * 440 # A4 is 69th note, 440Hz

def ticks_to_cycles(ticks, ticks_per_beat, tempo, clock_T):
    seconds = tick2second(ticks, ticks_per_beat, tempo)
    cycles = seconds / clock_T
    return int(cycles)

def pulse_freq_to_period(freq):
    return int(2048 - (131072 / freq))

def custom_freq_to_period(freq):
    return  int(2048 - (65536 / freq))

def velocity_to_volume(velocity):
    return int((velocity / 127) * 15)

tick_T = ticks_to_cycles(1, ticks_per_beat, tempo, clock_T) # 1 tick in cycles

pulse_1 = pd.DataFrame(columns=['length', 'volume', 'period'])
pulse_2 = pd.DataFrame(columns=['length', 'volume', 'period'])
custom = pd.DataFrame(columns=['length', 'volume', 'period'])
noise = pd.DataFrame(columns=['length', 'volume'])

midi_data = []

for i, track in enumerate(mid.tracks): # parse midi data to dict
    for msg in track:
        if msg.type == 'note_on':
            midi_data.append({
                'track': i,
                'freq': midi_to_freq(msg.note),
                'velocity': msg.velocity,
                'cycles': (tick_T * msg.time)
            })

for data in midi_data:
    if 'track' in data:
        new_row = pd.DataFrame({
            'length': [data['cycles']],
            'volume': [velocity_to_volume(data['velocity'])],
            'period': [pulse_freq_to_period(data['freq'])] if data['track'] in [1, 2, 3] else None
        })
        if data['track'] == 1:
            pulse_1 = pd.concat([pulse_1, new_row], ignore_index=True)
        elif data['track'] == 2:
            pulse_2 = pd.concat([pulse_2, new_row], ignore_index=True)
        elif data['track'] == 3:
            custom = pd.concat([custom, new_row], ignore_index=True)
        elif data['track'] == 4:
            noise = pd.concat([noise, new_row.drop(columns='period')], ignore_index=True)

# append 00 to length in custom channel

def export_to_mem_file(df, filename, length_bits):
    with open(filename, 'w') as f:
        for _, row in df.iterrows():
            length = format(int(row['length']), f'0{length_bits}b')
            volume = format(int(row['volume']), '04b')
            line = f"{length} {volume}"
            if 'period' in row and not pd.isna(row['period']):
                period = format(int(row['period']), '011b')
                line += f" {period}"
            f.write(f"{line}\n")

export_to_mem_file(pulse_1, 'pulse_1.mem', 6)
export_to_mem_file(pulse_2, 'pulse_2.mem', 6)
export_to_mem_file(custom, 'custom.mem', 8)
export_to_mem_file(noise, 'noise.mem', 6)
