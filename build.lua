local configure = function(config)
    local compile = config.compileObject {
        compiler = "gcc",
        deps = "gcc",
        includes = "lib/lvgl",
        cflags = { "-Og", "-pedantic", "-Wall", "-Wextra" },
    }
    local link    = config.linkElf { linker = "gcc", libs = "SDL2" }

    local objects = config.buildSources(
        compile,
        {
            "src/main.c",
            { path = "lib/lvgl/src", recursive = true },
        }
    )

    local compDb  = config.generateCompilationDatabase()
    local elf     = link { inputs = objects, implicit = compDb, target = "build/main" }
    config.command {
        name = "run",
        command = elf,
        dependencies = elf,
    }

    config.aliases.all = elf
    config.default(elf)

    return config
end

return {
    configure = configure,
    buildFolder = "build",
}
