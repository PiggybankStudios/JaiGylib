
//TODO: Add color by index and index of color functions

// +--------------------------------------------------------------+
// |                         Pure Colors                          |
// +--------------------------------------------------------------+
	TransparentColors :: enum u32 #specified
	{
		NoColor          :: 0x00000000;
		TransparentBlack :: 0x00000000;
		Transparent      :: 0x00FFFFFF;
		TransparentWhite :: 0x00FFFFFF;
	}
	TransparentColors_NumColors :: cast(u8)( #run enum_values_as_s64(TransparentColors).count );
	
	GreyscaleColors :: enum u32 #specified
	{
		Black  :: 0xFF000000;
		Grey1  :: 0xFF111111;
		Grey2  :: 0xFF222222;
		Grey3  :: 0xFF333333;
		Grey4  :: 0xFF444444;
		Grey5  :: 0xFF555555;
		Grey6  :: 0xFF666666;
		Grey7  :: 0xFF777777;
		Grey8  :: 0xFF888888;
		Grey9  :: 0xFF999999;
		Grey10 :: 0xFFAAAAAA;
		Grey11 :: 0xFFBBBBBB;
		Grey12 :: 0xFFCCCCCC;
		Grey13 :: 0xFFDDDDDD;
		Grey14 :: 0xFFEEEEEE;
		White  :: 0xFFFFFFFF;
	}
	GreyscaleColors_NumColors :: cast(u8)( #run enum_values_as_s64(GreyscaleColors).count );
	
	PureColors :: enum u32 #specified
	{
		Red    :: 0xFFFF0000;
		Orange :: 0xFFFFA500;
		Yellow :: 0xFFFFFF00;
		Green  :: 0xFF008000;
		Blue   :: 0xFF0000FF;
		Purple :: 0xFF800080;
	}
	PureColors_NumColors :: cast(u8)( #run enum_values_as_s64(PureColors).count );
	
	NoColor                 :: Color.{value=cast(u32)TransparentColors.NoColor};
	TransparentBlack        :: Color.{value=cast(u32)TransparentColors.TransparentBlack};
	Transparent             :: Color.{value=cast(u32)TransparentColors.Transparent};
	TransparentWhite        :: Color.{value=cast(u32)TransparentColors.TransparentWhite};
	Black                   :: Color.{value=cast(u32)GreyscaleColors.Black};
	Grey1                   :: Color.{value=cast(u32)GreyscaleColors.Grey1};
	Grey2                   :: Color.{value=cast(u32)GreyscaleColors.Grey2};
	Grey3                   :: Color.{value=cast(u32)GreyscaleColors.Grey3};
	Grey4                   :: Color.{value=cast(u32)GreyscaleColors.Grey4};
	Grey5                   :: Color.{value=cast(u32)GreyscaleColors.Grey5};
	Grey6                   :: Color.{value=cast(u32)GreyscaleColors.Grey6};
	Grey7                   :: Color.{value=cast(u32)GreyscaleColors.Grey7};
	Grey8                   :: Color.{value=cast(u32)GreyscaleColors.Grey8};
	Grey9                   :: Color.{value=cast(u32)GreyscaleColors.Grey9};
	Grey10                  :: Color.{value=cast(u32)GreyscaleColors.Grey10};
	Grey11                  :: Color.{value=cast(u32)GreyscaleColors.Grey11};
	Grey12                  :: Color.{value=cast(u32)GreyscaleColors.Grey12};
	Grey13                  :: Color.{value=cast(u32)GreyscaleColors.Grey13};
	Grey14                  :: Color.{value=cast(u32)GreyscaleColors.Grey14};
	White                   :: Color.{value=cast(u32)GreyscaleColors.White};
	PureRed                 :: Color.{value=cast(u32)PureColors.Red};
	PureOrange              :: Color.{value=cast(u32)PureColors.Orange};
	PureYellow              :: Color.{value=cast(u32)PureColors.Yellow};
	PureGreen               :: Color.{value=cast(u32)PureColors.Green};
	PureBlue                :: Color.{value=cast(u32)PureColors.Blue};
	PurePurple              :: Color.{value=cast(u32)PureColors.Purple};
// +--------------------------------------------------------------+

// +--------------------------------------------------------------+
// |                        Palette Colors                        |
// +--------------------------------------------------------------+
	PredefPal :: enum u32 #specified
	{
		RedDarker            :: 0xFFB91668;
		RedDark              :: 0xFFE1126B;
		Red                  :: 0xFFF92672;
		RedLight             :: 0xFFFB6C7F;
		RedLighter           :: 0xFFFDB5A8;
		PinkDarker           :: 0xFFBF2A83;
		PinkDark             :: 0xFFD9368B;
		Pink                 :: 0xFFED4E95;
		PinkLight            :: 0xFFF088B8;
		PinkLighter          :: 0xFFF6ACCD;
		OrangeDarker         :: 0xFFBD7628;
		OrangeDark           :: 0xFFE4861C;
		Orange               :: 0xFFFD971F;
		OrangeLight          :: 0xFFFEB64B;
		OrangeLighter        :: 0xFFFED88F;
		HoneyDarker          :: 0xFFD5A43E;
		HoneyDark            :: 0xFFE9B34A;
		Honey                :: 0xFFFDC459;
		HoneyLight           :: 0xFFFED47A;
		HoneyLighter         :: 0xFFFEE8AC;
		YellowDarker         :: 0xFFB3B947;
		YellowDark           :: 0xFFD5CE62;
		Yellow               :: 0xFFE6DB74;
		YellowLight          :: 0xFFEFE48C;
		YellowLighter        :: 0xFFF3ECAC;
		BananaDarker         :: 0xFFB7BD2F;
		BananaDark           :: 0xFFDAD942;
		Banana               :: 0xFFEEE64F;
		BananaLight          :: 0xFFF4EA6F;
		BananaLighter        :: 0xFFF9F1A4;
		GreenDarker          :: 0xFF76B434;
		GreenDark            :: 0xFF8DCE2E;
		Green                :: 0xFFA6E22E;
		GreenLight           :: 0xFFC3E753;
		GreenLighter         :: 0xFFE1EE92;
		GrassDarker          :: 0xFF608B4D;
		GrassDark            :: 0xFF7DA641;
		Grass                :: 0xFF92BB41;
		GrassLight           :: 0xFFB3D05B;
		GrassLighter         :: 0xFFD7E295;
		BlueDarker           :: 0xFF2471EC;
		BlueDark             :: 0xFF4585EE;
		Blue                 :: 0xFF669BEF;
		BlueLight            :: 0xFF99B7DE;
		BlueLighter          :: 0xFFCDD9DB;
		SkyDarker            :: 0xFF24B1EC;
		SkyDark              :: 0xFF45C9EE;
		Sky                  :: 0xFF66D9EF;
		SkyLight             :: 0xFF99E1DE;
		SkyLighter           :: 0xFFCDEDDB;
		PurpleDarker         :: 0xFF7445FF;
		PurpleDark           :: 0xFF9161FF;
		Purple               :: 0xFFAE81FF;
		PurpleLight          :: 0xFFCBAAEA;
		PurpleLighter        :: 0xFFD6BBEE;
		VioletDarker         :: 0xFFC038FF;
		VioletDark           :: 0xFFC95BFF;
		Violet               :: 0xFFDD7BFF;
		VioletLight          :: 0xFFE595FF;
		VioletLighter        :: 0xFFEBAAFF;
		NeutralDarker        :: 0xFF5E5E4A;
		NeutralDark          :: 0xFF75715E;
		Neutral              :: 0xFF908861;
		NeutralLight         :: 0xFFA79C65;
		NeutralLighter       :: 0xFFB9B084;
		
		BackgroundDarker     :: 0xFF131410;
		BackgroundDark       :: 0xFF1F221A;
		Background           :: 0xFF272822;
		BackgroundLight      :: 0xFF424431;
		BackgroundLighter    :: 0xFF545934;
		GreyDarker           :: 0xFF64635B;
		GreyDark             :: 0xFF707067;
		Grey                 :: 0xFF7D7C72;
		GreyLight            :: 0xFF98978E;
		GreyLighter          :: 0xFFB1B1AA;
		BlackDarker          :: 0xFF121211;
		BlackDark            :: 0xFF1E1E1D;
		Black                :: 0xFF262624;
		BlackLight           :: 0xFF3C3C39;
		BlackLighter         :: 0xFF53534E;
	}
	PredefPal_NumColors :: cast(u8)( #run enum_values_as_s64(PredefPal).count );
	
	PalRedDarker                  :: Color.{value=cast(u32)PredefPal.RedDarker};
	PalRedDark                    :: Color.{value=cast(u32)PredefPal.RedDark};
	PalRed                        :: Color.{value=cast(u32)PredefPal.Red};
	PalRedLight                   :: Color.{value=cast(u32)PredefPal.RedLight};
	PalRedLighter                 :: Color.{value=cast(u32)PredefPal.RedLighter};
	PalPinkDarker                 :: Color.{value=cast(u32)PredefPal.PinkDarker};
	PalPinkDark                   :: Color.{value=cast(u32)PredefPal.PinkDark};
	PalPink                       :: Color.{value=cast(u32)PredefPal.Pink};
	PalPinkLight                  :: Color.{value=cast(u32)PredefPal.PinkLight};
	PalPinkLighter                :: Color.{value=cast(u32)PredefPal.PinkLighter};
	PalOrangeDarker               :: Color.{value=cast(u32)PredefPal.OrangeDarker};
	PalOrangeDark                 :: Color.{value=cast(u32)PredefPal.OrangeDark};
	PalOrange                     :: Color.{value=cast(u32)PredefPal.Orange};
	PalOrangeLight                :: Color.{value=cast(u32)PredefPal.OrangeLight};
	PalOrangeLighter              :: Color.{value=cast(u32)PredefPal.OrangeLighter};
	PalHoneyDarker                :: Color.{value=cast(u32)PredefPal.HoneyDarker};
	PalHoneyDark                  :: Color.{value=cast(u32)PredefPal.HoneyDark};
	PalHoney                      :: Color.{value=cast(u32)PredefPal.Honey};
	PalHoneyLight                 :: Color.{value=cast(u32)PredefPal.HoneyLight};
	PalHoneyLighter               :: Color.{value=cast(u32)PredefPal.HoneyLighter};
	PalYellowDarker               :: Color.{value=cast(u32)PredefPal.YellowDarker};
	PalYellowDark                 :: Color.{value=cast(u32)PredefPal.YellowDark};
	PalYellow                     :: Color.{value=cast(u32)PredefPal.Yellow};
	PalYellowLight                :: Color.{value=cast(u32)PredefPal.YellowLight};
	PalYellowLighter              :: Color.{value=cast(u32)PredefPal.YellowLighter};
	PalBananaDarker               :: Color.{value=cast(u32)PredefPal.BananaDarker};
	PalBananaDark                 :: Color.{value=cast(u32)PredefPal.BananaDark};
	PalBanana                     :: Color.{value=cast(u32)PredefPal.Banana};
	PalBananaLight                :: Color.{value=cast(u32)PredefPal.BananaLight};
	PalBananaLighter              :: Color.{value=cast(u32)PredefPal.BananaLighter};
	PalGreenDarker                :: Color.{value=cast(u32)PredefPal.GreenDarker};
	PalGreenDark                  :: Color.{value=cast(u32)PredefPal.GreenDark};
	PalGreen                      :: Color.{value=cast(u32)PredefPal.Green};
	PalGreenLight                 :: Color.{value=cast(u32)PredefPal.GreenLight};
	PalGreenLighter               :: Color.{value=cast(u32)PredefPal.GreenLighter};
	PalGrassDarker                :: Color.{value=cast(u32)PredefPal.GrassDarker};
	PalGrassDark                  :: Color.{value=cast(u32)PredefPal.GrassDark};
	PalGrass                      :: Color.{value=cast(u32)PredefPal.Grass};
	PalGrassLight                 :: Color.{value=cast(u32)PredefPal.GrassLight};
	PalGrassLighter               :: Color.{value=cast(u32)PredefPal.GrassLighter};
	PalBlueDarker                 :: Color.{value=cast(u32)PredefPal.BlueDarker};
	PalBlueDark                   :: Color.{value=cast(u32)PredefPal.BlueDark};
	PalBlue                       :: Color.{value=cast(u32)PredefPal.Blue};
	PalBlueLight                  :: Color.{value=cast(u32)PredefPal.BlueLight};
	PalBlueLighter                :: Color.{value=cast(u32)PredefPal.BlueLighter};
	PalSkyDarker                  :: Color.{value=cast(u32)PredefPal.SkyDarker};
	PalSkyDark                    :: Color.{value=cast(u32)PredefPal.SkyDark};
	PalSky                        :: Color.{value=cast(u32)PredefPal.Sky};
	PalSkyLight                   :: Color.{value=cast(u32)PredefPal.SkyLight};
	PalSkyLighter                 :: Color.{value=cast(u32)PredefPal.SkyLighter};
	PalPurpleDarker               :: Color.{value=cast(u32)PredefPal.PurpleDarker};
	PalPurpleDark                 :: Color.{value=cast(u32)PredefPal.PurpleDark};
	PalPurple                     :: Color.{value=cast(u32)PredefPal.Purple};
	PalPurpleLight                :: Color.{value=cast(u32)PredefPal.PurpleLight};
	PalPurpleLighter              :: Color.{value=cast(u32)PredefPal.PurpleLighter};
	PalVioletDarker               :: Color.{value=cast(u32)PredefPal.VioletDarker};
	PalVioletDark                 :: Color.{value=cast(u32)PredefPal.VioletDark};
	PalViolet                     :: Color.{value=cast(u32)PredefPal.Violet};
	PalVioletLight                :: Color.{value=cast(u32)PredefPal.VioletLight};
	PalVioletLighter              :: Color.{value=cast(u32)PredefPal.VioletLighter};
	PalNeutralDarker              :: Color.{value=cast(u32)PredefPal.NeutralDarker};
	PalNeutralDark                :: Color.{value=cast(u32)PredefPal.NeutralDark};
	PalNeutral                    :: Color.{value=cast(u32)PredefPal.Neutral};
	PalNeutralLight               :: Color.{value=cast(u32)PredefPal.NeutralLight};
	PalNeutralLighter             :: Color.{value=cast(u32)PredefPal.NeutralLighter};
	
	PalBackgroundDarker           :: Color.{value=cast(u32)PredefPal.BackgroundDarker};
	PalBackgroundDark             :: Color.{value=cast(u32)PredefPal.BackgroundDark};
	PalBackground                 :: Color.{value=cast(u32)PredefPal.Background};
	PalBackgroundLight            :: Color.{value=cast(u32)PredefPal.BackgroundLight};
	PalBackgroundLighter          :: Color.{value=cast(u32)PredefPal.BackgroundLighter};
	PalGreyDarker                 :: Color.{value=cast(u32)PredefPal.GreyDarker};
	PalGreyDark                   :: Color.{value=cast(u32)PredefPal.GreyDark};
	PalGrey                       :: Color.{value=cast(u32)PredefPal.Grey};
	PalGreyLight                  :: Color.{value=cast(u32)PredefPal.GreyLight};
	PalGreyLighter                :: Color.{value=cast(u32)PredefPal.GreyLighter};
	PalBlackDarker                :: Color.{value=cast(u32)PredefPal.BlackDarker};
	PalBlackDark                  :: Color.{value=cast(u32)PredefPal.BlackDark};
	PalBlack                      :: Color.{value=cast(u32)PredefPal.Black};
	PalBlackLight                 :: Color.{value=cast(u32)PredefPal.BlackLight};
	PalBlackLighter               :: Color.{value=cast(u32)PredefPal.BlackLighter};
// +--------------------------------------------------------------+

// +--------------------------------------------------------------+
// |                        Monokai Colors                        |
// +--------------------------------------------------------------+
	NUM_PREDEF_MONOKAI_COLORS       :: 20;
	
	MonokaiColors :: enum u32 #specified
	{
		Back               :: 0xFF3B3A32;
		Yellow             :: 0xFFE6DB74;
		LightYellow        :: 0xFFFFE792;
		FadedYellow        :: 0xFFFFEFB7;
		Purple             :: 0xFFAE81FF;
		LightPurple        :: 0xFFE777FF;
		Green              :: 0xFFA6E22E;
		DarkGreen          :: 0xFF829520;
		Orange             :: 0xFFFD971F;
		Brown              :: 0xFF9D550F;
		Magenta            :: 0xFFF92672;
		Red                :: 0xFFF83333;
		LightRed           :: 0xFFFF5959;
		Blue               :: 0xFF66D9EF;
		LightBlue          :: 0xFFA9FFFF;
		White              :: 0xFFF8F8F2;
		LightGray          :: 0xFFBBBBBB;
		Gray1              :: 0xFFAFAFA2;
		Gray2              :: 0xFF75715E;
		DarkGray           :: 0xFF212121;
	}
	MonokaiColors_NumColors :: cast(u8)( #run enum_values_as_s64(MonokaiColors).count );
	
	MonokaiBack                     :: Color.{value=cast(u32)MonokaiColors.Back};
	MonokaiYellow                   :: Color.{value=cast(u32)MonokaiColors.Yellow};
	MonokaiLightYellow              :: Color.{value=cast(u32)MonokaiColors.LightYellow};
	MonokaiFadedYellow              :: Color.{value=cast(u32)MonokaiColors.FadedYellow};
	MonokaiPurple                   :: Color.{value=cast(u32)MonokaiColors.Purple};
	MonokaiLightPurple              :: Color.{value=cast(u32)MonokaiColors.LightPurple};
	MonokaiGreen                    :: Color.{value=cast(u32)MonokaiColors.Green};
	MonokaiDarkGreen                :: Color.{value=cast(u32)MonokaiColors.DarkGreen};
	MonokaiOrange                   :: Color.{value=cast(u32)MonokaiColors.Orange};
	MonokaiBrown                    :: Color.{value=cast(u32)MonokaiColors.Brown};
	MonokaiMagenta                  :: Color.{value=cast(u32)MonokaiColors.Magenta};
	MonokaiRed                      :: Color.{value=cast(u32)MonokaiColors.Red};
	MonokaiLightRed                 :: Color.{value=cast(u32)MonokaiColors.LightRed};
	MonokaiBlue                     :: Color.{value=cast(u32)MonokaiColors.Blue};
	MonokaiLightBlue                :: Color.{value=cast(u32)MonokaiColors.LightBlue};
	MonokaiWhite                    :: Color.{value=cast(u32)MonokaiColors.White};
	MonokaiLightGray                :: Color.{value=cast(u32)MonokaiColors.LightGray};
	MonokaiGray1                    :: Color.{value=cast(u32)MonokaiColors.Gray1};
	MonokaiGray2                    :: Color.{value=cast(u32)MonokaiColors.Gray2};
	MonokaiDarkGray                 :: Color.{value=cast(u32)MonokaiColors.DarkGray};
// +--------------------------------------------------------------+
