extends Camera

# Mouse sensitivity
export (float, 0.0, 1.0) var mouse_sensitivity = 0.01

# Speed of camera
export (float) var speed = 10
export (float) var run_speed = 20

# Acceleration of camera
export (float) var acceleration = 30

# Deceleration of camera
export (float) var deceleration = -10

# Rotation
var rotation_x = 0.0
var rotation_y = 0.0

# Velocity & direction of camera
var current_speed = self.speed
var velocity = Vector3(0.0, 0.0, 0.0)
var direction = Vector3(0.0, 0.0, 0.0)

# Check for mouse input
func _input(event: InputEvent):
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		if event is InputEventMouseMotion:
			self.update_rotation(event)
	
	if Input.is_key_pressed(KEY_SHIFT):
		self.current_speed = self.run_speed
	else:
		self.current_speed = self.speed

# Update direction and movement
func _physics_process(delta: float) -> void:
	self.update_direction()
	self.update_movement(delta)

# Update rotation
func update_rotation(event : InputEventMouseMotion) -> void:
	self.rotation_x -= event.relative.x * self.mouse_sensitivity
	self.rotation_y -= event.relative.y * self.mouse_sensitivity
	self.rotation_y = clamp(self.rotation_y, deg2rad(-90), deg2rad(90))

	self.transform.basis = Basis() # reset rotation
	self.rotate_object_local(Vector3(0, 1, 0), self.rotation_x) # set rotation (first y than x)
	self.rotate_object_local(Vector3(1, 0, 0), self.rotation_y)

# Update direction
func update_direction() -> void:
	self.direction.x = float(Input.is_key_pressed(KEY_D)) - float(Input.is_key_pressed(KEY_A))
	self.direction.y = float(Input.is_key_pressed(KEY_E)) - float(Input.is_key_pressed(KEY_Q))
	self.direction.z = float(Input.is_key_pressed(KEY_S)) - float(Input.is_key_pressed(KEY_W))

# Updates camera movement
func update_movement(delta: float) -> void:
	
	var offset = self.direction.normalized() * self.acceleration * self.current_speed * delta \
		+ self.velocity.normalized() * self.deceleration * self.current_speed * delta
	
	# Checks if we should bother translating the camera
	if self.direction == Vector3.ZERO and offset.length_squared() > self.velocity.length_squared():
		# Sets the velocity to 0 to prevent jittering due to imperfect deceleration
		self.velocity = Vector3.ZERO
	else:
		# Clamp velocity to the camera speed
		self.velocity.x = clamp(self.velocity.x + offset.x, -self.current_speed, self.current_speed)
		self.velocity.y = clamp(self.velocity.y + offset.y, -self.current_speed, self.current_speed)
		self.velocity.z = clamp(self.velocity.z + offset.z, -self.current_speed, self.current_speed)

		# Translate camera
		self.translate(self.velocity * delta)
