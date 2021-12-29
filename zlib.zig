const std = @import("std");
const Self = @This();

fn root() []const u8 {
    return std.fs.path.dirname(@src().file) orelse ".";
}

fn pathJoinRoot(comptime components: []const []const u8) []const u8 {
    var ret = root();
    inline for (components) |component|
        ret = ret ++ std.fs.path.sep_str ++ component;

    return ret;
}

pub const include_dir = pathJoinRoot(&.{"c"});

pub fn create(b: *std.build.Builder, target: std.zig.CrossTarget, mode: std.builtin.Mode) *std.build.LibExeObjStep {
    const ret = b.addStaticLibrary("z", null);
    ret.setTarget(target);
    ret.setBuildMode(mode);
    ret.linkLibC();

    ret.addCSourceFiles(srcs, &.{"-fno-sanitize=all"});

    return ret;
}

const srcs = &.{
    pathJoinRoot(&.{ "c", "adler32.c" }),
    pathJoinRoot(&.{ "c", "compress.c" }),
    pathJoinRoot(&.{ "c", "crc32.c" }),
    pathJoinRoot(&.{ "c", "deflate.c" }),
    pathJoinRoot(&.{ "c", "gzclose.c" }),
    pathJoinRoot(&.{ "c", "gzlib.c" }),
    pathJoinRoot(&.{ "c", "gzread.c" }),
    pathJoinRoot(&.{ "c", "gzwrite.c" }),
    pathJoinRoot(&.{ "c", "inflate.c" }),
    pathJoinRoot(&.{ "c", "infback.c" }),
    pathJoinRoot(&.{ "c", "inftrees.c" }),
    pathJoinRoot(&.{ "c", "inffast.c" }),
    pathJoinRoot(&.{ "c", "trees.c" }),
    pathJoinRoot(&.{ "c", "uncompr.c" }),
    pathJoinRoot(&.{ "c", "zutil.c" }),
};
