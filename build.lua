local svadilfari = require("svadilfari")


local configure = function(config)
    config.variables.cc = "gcc"

    local compile = config.rule {
        command = "$cc -MD -MF $out.d $cflags -Ilib/lvgl -c -o $out $in",
        depfile = "$out.d",
        deps = "gcc",
    }
    local link = config.rule("$cc -o $out $in $ldflags")

    config.generateCompilationDatabase("build/compile_commands.json")

    local objects = {}
    for _, source in ipairs(svadilfari.find { path = "src", extension = "c" }) do
        local output = compile { inputs = { source }, target = svadilfari.toExtension("o") }
        table.insert(objects, output)
    end
    for _, source in ipairs(svadilfari.find { path = "lib/lvgl/src", extension = "c", recursive = true }) do
        local output = compile { inputs = { source }, target = svadilfari.toExtension("o") }
        table.insert(objects, output)
    end

    config.aliases.all = link { inputs = objects, implicit = "build/compile_commands.json", variables = { ldflags = "-lSDL2" }, target = "build/main" }

    return config
end

return {
    configure = configure,
    buildFolder = "build",
}
