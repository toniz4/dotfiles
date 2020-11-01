#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include "button.h"

int
main(void)
{
	time_t t = time(NULL);
	struct tm tm = *localtime(&t);

	char month[4];
	char dweek[4];
	char icon[] = "";
	int year = tm.tm_year + 1900;
	int day = tm.tm_mday;

	commands *cmds = cmdinit("LC_ALL=pt_BR.utf8 st -e calcurse", NULL,
			"notify-send \"$(date +%d/%m/%y)\"", NULL, NULL, NULL);
	buttonhandler(cmds);
	freecmds(cmds);

	switch (tm.tm_mon + 1) {
		case 0:
			break;
		case 1: strcpy(month,"jan");
				break;
		case 2: strcpy(month,"fev");
				break;
		case 3: strcpy(month,"mar");
				break;
		case 4: strcpy(month,"abr");
				break;
		case 5: strcpy(month,"mai");
				break;
		case 6: strcpy(month,"jun");
				break;
		case 7: strcpy(month,"jul");
				break;
		case 8: strcpy(month,"ago");
				break;
		case 9: strcpy(month,"set");
				break;
		case 10: strcpy(month,"out");
				break;
		case 11: strcpy(month,"nov");
				break;
		case 12: strcpy(month,"dez");
				break;
		default:
				break;
	}
	switch (tm.tm_wday) {
		case 1: strcpy(dweek, "seg");
				break;
		case 2: strcpy(dweek, "ter");
				break;
		case 3: strcpy(dweek, "qua");
				break;
		case 4: strcpy(dweek, "qui");
				break;
		case 5: strcpy(dweek, "sex");
				break;
		case 6: strcpy(dweek, "sab");
				break;
		case 7: strcpy(dweek, "dom");
				break;
		default:
				break;
	}
	printf("%s %d %s %.2d (%s)\n", icon, year, month, day, dweek);
	return 0;
}
