extends AudioStreamPlayer

class_name BeepPlayer

# Parameters for the sine wave
@export var pulse_hz := 227.18	# Frequency of the sine wave
@export var sample_hz := 11025	# Sample rate (higher for better quality)

# Instance of AudioStreamGeneratorPlayback
var playback

@export var current_buffer_index = 2
var fill_buffer_methods = [
	sine,
	harmonics,
	tremolo,
	noise_burst,
	fm_synthesis,
	bit_crush,
	flanger
]

func _ready():
	# Configure the stream generator
	var stream = AudioStreamGenerator.new()
	stream.mix_rate = sample_hz	# Set the mix rate
	stream.buffer_length = 0.2 # Set the buffer length (lower for less latency)
	self.stream = stream	# Assign to the player

func adjust_pulse_hz(hz: float):
	pulse_hz += hz
	print(pulse_hz)
	
func cycle_buffer(jump: int):
	var next = ((current_buffer_index + jump) % fill_buffer_methods.size())
	current_buffer_index = next
	print(fill_buffer_methods[current_buffer_index].get_method())
	
func beep(len: float = 0.1):
	if is_playing():
		stop()
	play()
	playback = get_stream_playback()
	await get_tree().create_timer(len).timeout
	stop()

func _process(delta):
	# Ensure playback is valid and player is active
	if playback and is_playing():
		fill_buffer_methods[current_buffer_index].call()

func sine():
	var phase = 0.0
	var increment = pulse_hz / sample_hz
	var frames_available = playback.get_frames_available()
	var frame_count = 0 # Keep track of the number of frames generated

	# Envelope parameters
	var attack_time = 0.01 # Time in seconds for the volume to ramp up
	var release_time = 0.01 # Time in seconds for the volume to ramp down

	for i in range(frames_available):
		# Envelope calculation
		var envelope = 1.0
		if frame_count < sample_hz * attack_time:
			# Attack phase
			envelope = frame_count / (sample_hz * attack_time)
		elif frame_count > frames_available - sample_hz * release_time:
			# Release phase
			envelope = (frames_available - frame_count) / (sample_hz * release_time)

		var value = sin(phase * TAU) * envelope
		playback.push_frame(Vector2(value, value))
		phase = fmod(phase + increment, 1.0)
		frame_count += 1


func harmonics():
	var phase = 0.0
	var harmonic_phase = 0.0
	var increment = pulse_hz / sample_hz
	var harmonic_increment = (pulse_hz * 2) / sample_hz  # Second harmonic
	var frames_available = playback.get_frames_available()

	for i in range(frames_available):
		var fundamental = sin(phase * TAU)  # Original tone
		var harmonic = sin(harmonic_phase * TAU) * 0.5  # Harmonic at double frequency, lower volume
		var value = (fundamental + harmonic) / 2  # Mix the two signals
		playback.push_frame(Vector2(value, value))
		phase = fmod(phase + increment, 1.0)
		harmonic_phase = fmod(harmonic_phase + harmonic_increment, 1.0)

func tremolo():
	var phase = 0.0
	var tremolo_phase = 0.0
	var increment = pulse_hz / sample_hz
	var tremolo_increment = 5.0 / sample_hz  # Tremolo speed
	var frames_available = playback.get_frames_available()

	for i in range(frames_available):
		var tremolo = sin(tremolo_phase * TAU) * 0.5 + 0.5  # Tremolo effect oscillates between 0 and 1
		var value = sin(phase * TAU) * tremolo  # Apply tremolo to the sine wave
		playback.push_frame(Vector2(value, value))
		phase = fmod(phase + increment, 1.0)
		tremolo_phase = fmod(tremolo_phase + tremolo_increment, 1.0)

func noise_burst():
	var phase = 0.0
	var increment = pulse_hz / sample_hz
	var frames_available = playback.get_frames_available()
	var noise_burst_every = int(sample_hz / 2)  # Noise burst every half second

	for i in range(frames_available):
		var value
		if i % noise_burst_every < 100:  # Add a burst of noise for 100 frames
			value = randf() * 2.0 - 1.0  # Random noise between -1 and 1
		else:
			value = sin(phase * TAU)  # Regular beep
		playback.push_frame(Vector2(value, value))
		phase = fmod(phase + increment, 1.0)

func fm_synthesis():
	var phase = 0.0
	var modulator_phase = 0.0
	var increment = pulse_hz / sample_hz
	var modulator_increment = (pulse_hz * 2) / sample_hz  # Modulator frequency
	var modulation_index = 3  # Modulation depth
	var frames_available = playback.get_frames_available()

	for i in range(frames_available):
		var modulator = sin(modulator_phase * TAU) * modulation_index
		var value = sin((phase + modulator) * TAU)
		playback.push_frame(Vector2(value, value))
		phase = fmod(phase + increment, 1.0)
		modulator_phase = fmod(modulator_phase + modulator_increment, 1.0)

func bit_crush():
	var phase = 0.0
	var increment = pulse_hz / sample_hz
	var frames_available = playback.get_frames_available()
	var crush_factor = 8  # Lower for more crushing

	for i in range(frames_available):
		var value = sin(phase * TAU)
		# Reduce the signal's resolution by the crush factor
		value = floor(value * crush_factor) / crush_factor
		playback.push_frame(Vector2(value, value))
		phase = fmod(phase + increment, 1.0)


func flanger():
	var phase = 0.0
	var flanger_phase = 0.0
	var increment = pulse_hz / sample_hz
	var flanger_increment = 0.25 / sample_hz  # Speed of flanger effect
	var frames_available = playback.get_frames_available()
	var max_delay = 500  # Max delay in frames


	var buffer = PackedVector2Array()  # Buffer to hold delayed frames

	for i in range(frames_available):
		var flanger_delay = int(max_delay / 2 * (sin(flanger_phase * TAU) + 1))  # Calculate variable delay
		var delayed_value = Vector2()
		if buffer.size() > flanger_delay:
			delayed_value = buffer[buffer.size() - flanger_delay]
			buffer.remove_at(0)  # Remove the oldest element

		var original_value = Vector2(sin(phase * TAU), sin(phase * TAU))
		buffer.append(original_value)  # Add the new frame to the buffer

		# Mix the original and delayed sounds
		var value = (original_value + delayed_value) / 2
		playback.push_frame(value)

		phase = fmod(phase + increment, 1.0)
		flanger_phase += flanger_increment
