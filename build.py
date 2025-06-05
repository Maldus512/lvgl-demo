import ninja_syntax
import os
import pathlib

BUILD_PATH = "build"
PROJECT_PATH = os.getcwd()

sources = list(pathlib.Path("src").rglob("*.c"))
sources += list(pathlib.Path(os.path.join("lib", "lvgl", "src")).rglob("*.c"))

with open("build.ninja", "w") as f:
    writer = ninja_syntax.Writer(f)
    writer.variable("cc", os.getenv("CC", "gcc"))
    writer.rule("compile", "$cc -MD -MF $out.d $cflags -Ilib/lvgl -c -o $out $in",
                depfile="$out.d", deps="gcc")
    writer.rule("link", "$cc -o $out $in $ldflags")
    writer.rule("compdb", "ninja -t compdb > $out")

    compile_commands = os.path.join(BUILD_PATH, "compile_commands.json")
    writer.build(compile_commands, "compdb")

    objects = []

    for source in sources:
        object_file = pathlib.Path(BUILD_PATH) / source.with_suffix(".o")

        writer.build(object_file.as_posix(), "compile", source.as_posix())
        objects.append(object_file.as_posix())

    writer.build(os.path.join(BUILD_PATH, "main"), "link", objects, implicit=compile_commands,
                 variables={"ldflags": "-lSDL2"})
