-- https://github.com/kalidrios

local table1 = {
	Promise = require(script.Parent.Promise),
	animation_helper = require(script.Parent.animation_helper),
	cframe_helper = require(script.Parent.cframe_helper),
	event_map = require(script.Parent.event_map),
	future_latch = require(script.Parent.future_latch),
	humanoid_helper = require(script.Parent.humanoid_helper),
	instance_map = require(script.Parent.instance_map),
	instances = require(script.Parent.instances),
	lambda = require(script.Parent.lambda),
	list_helper = require(script.Parent.list_helper),
	math_helper = require(script.Parent.math_helper),
	number_formatting = require(script.Parent.number_formatting),
	objects = require(script.Parent.objects),
	part_shaders = require(script.Parent.part_shaders),
	player_helper = require(script.Parent.player_helper),
	predicates = require(script.Parent.predicates),
	random = require(script.Parent.random),
	remote_events = require(script.Parent.remote_events),
	string_helper = require(script.Parent.string_helper),
	tex_helper = require(script.Parent.tex_helper),
	types = require(script.Parent.types),
	vector_helper = require(script.Parent.vector_helper),
	virtual_humanoid = require(script.Parent.virtual_humanoid)
};
return table1;
