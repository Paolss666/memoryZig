const std = @import("std");



const Pixel = struct {
    r: u8,
    g: u8,
    b: u8,
};

const Image = struct{
    w: usize,
    h: usize,
    pixels: []u8,

    fn init(alloc: std.mem.Allocator, width: usize, height: usize) !Image {
        const pixs = try alloc.alloc(u8, width * height * 3);

        @memset(pixs, 0);

        return .{.w = width, .h  = height, .pixels = pixs};
    }

    fn deinit(self: Image, alloc: std.mem.Allocator) void {
        alloc.free(self.pixels);
    }

    // Index first byte of the pixel

    fn index(self: Image, x: usize, y:usize) usize{
        return (y * self.w + x) * 3;
    }



    fn setPixels(self: Image, x: usize, y: usize, p: Pixel) void {
        const i = self.index(x, y);

        self.pixels[i]  = p.r;
        self.pixels[i+1] = p.g;
        self.pixels[i+2] = p.b;
    }


    fn getPixels(self: Image, x: usize, y: usize) Pixel {

        const i = self.index(x, y);

        return . {.r = self.pixels[i], .g = self.pixels[i + 1], .b = self.pixels[i + 2]};
    }

    fn print(self: Image) void {
        var y: usize = 0;

        while ( y < self.h) : ( y += 1) {
            var x : usize = 0;
            while ( x < self.w) : (x += 1) {
                const p = self.getPixels(x, y);
                std.debug.print("({d}, {d}, {d})", .{p.r, p.g, p.b});
            }
            std.debug.print("\n", .{});
        }
    }
};




pub fn main() !void{
    
    const number = [_]u8{10, 20 , 30 , 40};
    const slice = number[1..4];

    std.debug.print("slice.len = {d}, slice[2] = {d} \n", .{slice.len, slice[2]});


    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();

    const img = try Image.init(alloc, 4, 2);

    defer img.deinit(alloc);

    img.setPixels(2, 1, .{.r = 255, .g = 0, .b = 0 });
    img.print();

    std.debug.print("{any}\n", .{img.pixels});
}
