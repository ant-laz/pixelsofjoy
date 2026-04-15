#  Copyright 2026 Google LLC
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

extends CharacterBody2D

@export var speed := 200.0
@onready var joystick = $"../CanvasLayer/Virtual Joystick"  # adjust path if needed
@onready var anim = $AnimatedSprite2D

var health = 100

func _physics_process(delta: float) -> void:
	var direction: Vector2 = joystick.output
	direction = direction.normalized()

	# Optional: deadzone (prevents tiny unwanted movement)
	if direction.length() < 0.1:
		direction = Vector2.ZERO

	velocity = direction * speed
	move_and_slide()

	# Animation handling
	if direction != Vector2.ZERO:
		anim.play("walk")
		anim.flip_h = direction.x < 0
	else:
		anim.play("idle")
		
func take_damage(amount: int):
	health -= amount
	health = max(health, 0)
	
	if health == 0:
		emit_signal("died")
		
