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
pub const include_dir = pathJoinRoot(&.{"c"});
pub const Options = struct {
    import_str: ?[]const u8 = null,
};

pub const Library = struct {
    step: *std.build.LibExeObjStep,
    opts: Options,

    pub fn link(self: Library, other: *std.build.LibExeObjStep) void {
        other.addIncludeDir(include_dir);
        other.linkLibrary(self.step);

        if (self.opts.import_str) |import_str|
            other.addPackagePath(import_str, package_path);
    }
};

/// if opts.import_str is set, the zlib bindings are added to targets that this Library is link()'ed to
pub fn create(b: *std.build.Builder, target: std.zig.CrossTarget, mode: std.builtin.Mode, opts: Options) Library {
    var ret = Library{
        .step = b.addStaticLibrary("z", null),
        .opts = opts,
    };

    ret.step.setTarget(target);
    ret.step.setBuildMode(mode);
    ret.step.linkLibC();

    ret.step.addCSourceFiles(srcs, &.{});

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
