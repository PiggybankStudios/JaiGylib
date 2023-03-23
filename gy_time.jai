
GetDayOfMonthString :: (dayOfMonth: u16) -> string
{
	if dayOfMonth ==
	{
		case 0;  return "1st";
		case 1;  return "2nd";
		case 2;  return "3rd";
		case 3;  return "4th";
		case 4;  return "5th";
		case 5;  return "6th";
		case 6;  return "7th";
		case 7;  return "8th";
		case 8;  return "9th";
		case 9;  return "10th";
		case 10; return "11th";
		case 11; return "12th";
		case 12; return "13th";
		case 13; return "14th";
		case 14; return "15th";
		case 15; return "16th";
		case 16; return "17th";
		case 17; return "18th";
		case 18; return "19th";
		case 19; return "20th";
		case 20; return "21st";
		case 21; return "22nd";
		case 22; return "23rd";
		case 23; return "24th";
		case 24; return "25th";
		case 25; return "26th";
		case 26; return "27th";
		case 27; return "28th";
		case 28; return "29th";
		case 29; return "30th";
		case 30; return "31st";
		case; return "Unk";
	};
}

GetPlacementNumberString :: (placement: int) -> string
{
	hundredModulo := (placement % 100);
	if (hundredModulo < 11 || hundredModulo > 13) //11th, 12th, and 13th don't follow convention
	{
		lastDigit := (placement % 10);
		if (lastDigit == 1) { return tprint("%st", placement); }
		else if (lastDigit == 2) { return tprint("%nd", placement); }
		else if (lastDigit == 3) { return tprint("%rd", placement); }
	}
	return tprint("%th", placement);
}
