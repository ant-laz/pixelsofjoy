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

# credit to these resources for enemy logic: 
# https://kidscancode.org/godot_recipes/4.x/ai/chasing/index.html
# https://dev.to/christinec_dev/lets-learn-godot-4-by-making-an-rpg-part-9-enemy-ai-setup-3nfl
# https://www.youtube.com/watch?v=GwCiGixlqiU&t=5808s
# https://www.youtube.com/watch?v=BAUn-lGBXMw&list=PLtosjGHWDab682nfZ1f6JSQ1cjap7Ieeb&index=3

@export var speed = 25
@export var health = 10
@export var damage_received_from_bullet = 1
@export var damage_dealt_to_player = 1

@onready
var player = get_tree().get_first_node_in_group("player")
@onready
var anim = %enemy_lvl_1_sprite

func _ready():
	anim.play("run")

func _physics_process(delta: float) -> void:
	velocity = global_position.direction_to(player.global_position) * speed
	move_and_slide()
	
func deal_damage():
	return damage_dealt_to_player

func take_damage() -> void:
	health -= damage_received_from_bullet
	health = max(0, health)
	if health == 0:
		queue_free()
		anim.play("death")
	
