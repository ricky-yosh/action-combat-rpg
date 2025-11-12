extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
# Stores the x/y direction the player is trying to look in
var _look = Vector2.ZERO

@export var mouse_sensitivity: float = 0.00075
@export var min_boundary: float = -60
@export var max_boundary: float = 10


@onready var horizontal_pivot: Node3D = $HorizontalPivot
@onready var vertical_pivot: Node3D = $HorizontalPivot/VerticalPivot

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	# Needs to be in physics_process because we interact with the SpringArm which is a physics body
	frame_camera_motion()
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			# if running at higher framerates rewriting _look will cause problems
			# We need to accumilate the mouse movement in those extra frames using +=
			_look += -event.relative * mouse_sensitivity

func frame_camera_motion() -> void:
	horizontal_pivot.rotate_y(_look.x)
	vertical_pivot.rotate_x(_look.y)
	
	vertical_pivot.rotation.x = clampf(vertical_pivot.rotation.x, deg_to_rad(min_boundary), deg_to_rad(max_boundary))
	
	$SpringArm3D.global_transform = vertical_pivot.global_transform
	_look = Vector2.ZERO
