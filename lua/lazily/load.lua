local lazily = require("lazily")

local function load(package)
	if not lazily.pending[package] then return end

	local spec = lazily.pending[package].spec
	lazily.cancel(package)

	if spec.requires then
		for _, dependency in ipairs(spec.requires) do
			load(dependency)
		end
	end

    if spec.config ~= nil then
        if type(spec.config) == "string" then
            require(spec.config)
        elseif type(spec.config) == "function" then
            spec.config()
        end
    end

	lazily.opts.load(package)
end

return load
