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

extends Area2D

@export var speed: float = 600.0
@export var lifetime: float = 2.0
@export var explosion_scene: PackedScene
@export var damage : int = 10

var direction: Vector2 = Vector2.RIGHT

func _ready():
	body_entered.connect(_on_body_entered)
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func set_direction(dir: Vector2):
	direction = dir.normalized()

func _physics_process(delta):
	global_position += direction * speed * delta

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		explode()
	queue_free()	

func explode():
	var explosion = explosion_scene.instantiate()
	explosion.global_position = global_position

	get_tree().current_scene.add_child(explosion)
