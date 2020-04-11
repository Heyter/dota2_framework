if not ents then
	ents = {}
end

function ents.FindByClass(str_class)
	return Entities:FindAllByClassname(str_class)
end

function ents.FindByName(str_name)
	return Entities:FindAllByName(str_name)
end

function ents.FindByModel(str_model)
	return Entities:FindAllByModel(str_model)
end