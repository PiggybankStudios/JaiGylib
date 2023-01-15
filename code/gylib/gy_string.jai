
// +--------------------------------------------------------------+
// |                  Nice Formatting Functions                   |
// +--------------------------------------------------------------+
FormatBytes :: (numBytes: u64) -> string
{
	gigabytes := numBytes / Giga;
	megabytes := (numBytes % Giga) / Mega;
	kilobytes := (numBytes % Mega) / Kilo;
	remainder := (numBytes % Kilo);
	if (numBytes >= Kilo)
	{
		if (numBytes >= Mega)
		{
			if (numBytes >= Giga) { return tprint("%G %M %k %b", gigabytes, megabytes, kilobytes, remainder); }
			else { return tprint("%M %k %b", megabytes, kilobytes, remainder); }
		}
		else { return tprint("%k %b", kilobytes, remainder); }
	}
	else { return tprint("%b", remainder); }
}
