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

signal enemy_died

@export var speed = 75.0
@export var health = 100.0
@export var damage_dealt_to_player = 40.0

@onready
var player = get_tree().get_first_node_in_group("player")
@onready
var anim = %enemy_lvl_3_sprite
@onready
var healthbar = %enemy_lvl_3_health_bar

func _ready():
	healthbar.value = health

func _physics_process(delta: float) -> void:
	velocity = global_position.direction_to(player.global_position).normalized() * speed
	move_and_collide(velocity * delta)
	
func deal_damage():
	return damage_dealt_to_player

func take_damage(damage: int) -> void:
	health -= damage
	health = max(0, health)
	healthbar.value = health
	if health == 0:
		# anim.play("death")
		emit_signal("enemy_died")
		queue_free()
