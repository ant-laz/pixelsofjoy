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

@export var projectile_scene: PackedScene
@export var base_fire_rate := 1.0
@export var base_damage := 10.0

@onready var muzzle: Marker2D = $ShootingPoint
@onready var fire_timer: Timer = $FireTimer

var fire_rate_multiplier := 1.0
var damage_multiplier := 1.0 
var target: Node2D = null


func _ready():
	fire_timer.timeout.connect(_shoot)
	apply_fire_rate()
	fire_timer.start()


func _physics_process(delta):
	find_target()
	aim_at_target()


func find_target():
	var enemies = get_overlapping_bodies()
	if enemies.size() == 0:
		target = null
		return

	target = enemies[0] # (you can improve to "closest" later)


func aim_at_target():
	if target:
		look_at(target.global_position)


func _shoot():
	if target == null:
		return

	var bullet = projectile_scene.instantiate()
	get_tree().current_scene.add_child(bullet)

	bullet.global_position = muzzle.global_position
	bullet.set_direction(Vector2.RIGHT.rotated(rotation))
	bullet.damage = base_damage * damage_multiplier
	


func apply_fire_rate():
	var final_rate = base_fire_rate * fire_rate_multiplier
	fire_timer.wait_time = max(0.05, final_rate)
	fire_timer.start()


func upgrade_fire_rate(amount: float):
	fire_rate_multiplier += amount
	apply_fire_rate()
	
func upgrade_damage(amount: float):
	damage_multiplier += amount
