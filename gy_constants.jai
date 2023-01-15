
//Actual Value of Pi: 3.1415926535897932384626433832795...
Pi64  : float64 :     3.141592653589793; //accurate to 15 digits (0h400921fb54442d18)
Pi32  : float32 :     3.1415926;         //accurate to 6 digits  (0h40490fdb)

QuarterPi64    :: (Pi64 / 4);
ThirdPi64      :: (Pi64 / 3);
HalfPi64       :: (Pi64 / 2);
ThreeHalfsPi64 :: (Pi64 * (3.0/2.0));
TwoPi64        :: (2 * Pi64);

QuarterPi32    :: (Pi32 / 4);
ThirdPi32      :: (Pi32 / 3);
HalfPi32       :: (Pi32 / 2);
ThreeHalfsPi32 :: (Pi32 * (3.0/2.0));
TwoPi32        :: (2 * Pi32);

//Actual Value of e: 2.7182818284590452353602874713526...
e64  :: cast(float64)2.71828182845904509079559829843;    //accurate to 15 digits
e32  :: cast(float32)2.71828174591064453125;             //accurate to 6 digits
eVal :: 2.7182818284590452353602874713526;

Kilo ::                 (1024); //             1,024 bytes
Mega ::            (1024*1024); //         1,048,576 bytes
Giga ::       (1024*1024*1024); //     1,073,741,824 bytes
Tera ::  (1024*1024*1024*1024); // 1,099,511,627,776 bytes

Kilobytes :: inline (numKilobytes: u64) -> u64 { return numKilobytes * Kilo; }
Megabytes :: inline (numMegabytes: u64) -> u64 { return numMegabytes * Mega; }
Gigabytes :: inline (numGigabytes: u64) -> u64 { return numGigabytes * Giga; }
Terabytes :: inline (numTerabytes: u64) -> u64 { return numTerabytes * Tera; }

DEFAULT_EPSILON :: 0.0001; //Copied from Sloppy_Math.jai, used for BasicallyEqual functions

UNKNOWN_ENUM_STR :: "Unknown";
