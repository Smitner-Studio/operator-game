extends AudioStreamPlayer

class_name BeepPlayer

# Parameters for the sine wave
@export var pulse_hz := 227.18	# Frequency of the sine wave
@export var sample_hz := 11025	# Sample rate (higher for better quality)

# Instance of AudioStreamGeneratorPlayback
var playback

func _ready():
	# Configure the stream generator
	var stream = AudioStreamGenerator.new()
	stream.mix_rate = sample_hz	# Set the mix rate
	stream.buffer_length = 0.2 # Set the buffer length (lower for less latency)
	self.stream = stream	# Assign to the player

	
func beep(len: float = 0.1):
	play()
	playback = get_stream_playback()
	await get_tree().create_timer(len).timeout
	stop()

func _process(delta):
	# Ensure playback is valid and player is active
	if playback and is_playing():
		fill_buffer()

func fill_buffer():
	var phase = 0.0
	var increment = pulse_hz / sample_hz
	var frames_available = playback.get_frames_available()

	for i in range(frames_available):
		# Calculate the sine wave value
		var value = sin(phase * TAU)
		# Push the frame to both left and right channels for stereo sound
		playback.push_frame(Vector2(value, value))
		# Increment the phase, wrapping around at 1.0
		phase = fmod(phase + increment, 1.0)
