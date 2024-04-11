from mido import Message, MidiFile, MidiTrack, MetaMessage, tick2second
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

tick_T = ticks_to_cycles(1, ticks_per_beat, tempo, clock_T) # 1 tick in cycles

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

# print(midi_data)
