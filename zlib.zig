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

const package_path = pathJoinRoot(&.{ "src", "main.zig" });
pub const include_dir = pathJoinRoot(&.{"zlib"});
pub const Options = struct {
    import_name: ?[]const u8 = null,
};

pub const Library = struct {
    step: *std.build.LibExeObjStep,

    pub fn link(self: Library, other: *std.build.LibExeObjStep, opts: Options) void {
        other.addIncludeDir(include_dir);
        other.linkLibrary(self.step);

        if (opts.import_name) |import_name|
            other.addPackagePath(import_name, package_path);
    }
};

pub fn create(b: *std.build.Builder, target: std.zig.CrossTarget, mode: std.builtin.Mode) Library {
    var ret = b.addStaticLibrary("z", null);
    ret.setTarget(target);
    ret.setBuildMode(mode);
    ret.linkLibC();
    ret.addCSourceFiles(srcs, &.{});

    return Library{ .step = ret };
}

const srcs = &.{
    pathJoinRoot(&.{ "zlib", "adler32.c" }),
    pathJoinRoot(&.{ "zlib", "compress.c" }),
    pathJoinRoot(&.{ "zlib", "crc32.c" }),
    pathJoinRoot(&.{ "zlib", "deflate.c" }),
    pathJoinRoot(&.{ "zlib", "gzclose.c" }),
    pathJoinRoot(&.{ "zlib", "gzlib.c" }),
    pathJoinRoot(&.{ "zlib", "gzread.c" }),
    pathJoinRoot(&.{ "zlib", "gzwrite.c" }),
    pathJoinRoot(&.{ "zlib", "inflate.c" }),
    pathJoinRoot(&.{ "zlib", "infback.c" }),
    pathJoinRoot(&.{ "zlib", "inftrees.c" }),
    pathJoinRoot(&.{ "zlib", "inffast.c" }),
    pathJoinRoot(&.{ "zlib", "trees.c" }),
    pathJoinRoot(&.{ "zlib", "uncompr.c" }),
    pathJoinRoot(&.{ "zlib", "zutil.c" }),
};
