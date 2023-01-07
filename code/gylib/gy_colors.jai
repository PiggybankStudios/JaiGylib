
// +--------------------------------------------------------------+
// |                            Types                             |
// +--------------------------------------------------------------+
Color :: struct
{
	r, g, b, a: u8;
	
	#place r;
	value: u32;
	#place r;
	channel: [4]u8;
}

Colorf :: struct
{
	r, g, b, a: float32;
	
	#place r;
	channel: [4]float32;
	#place r;
	vector: v4;
}
