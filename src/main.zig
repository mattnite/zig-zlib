const c = @cImport({
    @cInclude("zlib.h");
});

test "compress gzip" {
    var input = [_]u8{ 'b', 'l', 'a', 'r', 'g' };
    var output_buf: [4096]u8 = undefined;

    var zs: c.z_stream = undefined;
    zs.zalloc = null;
    zs.zfree = null;
    zs.@"opaque" = null;
    zs.avail_in = input.len;
    zs.next_in = &input;
    zs.avail_out = output_buf.len;
    zs.next_out = &output_buf;

    _ = c.deflateInit2(&zs, c.Z_DEFAULT_COMPRESSION, c.Z_DEFLATED, 15 | 16, 8, c.Z_DEFAULT_STRATEGY);
    _ = c.deflate(&zs, c.Z_FINISH);
    _ = c.deflateEnd(&zs);
}
