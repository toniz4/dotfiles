#include <stdio.h>
#include <time.h>

int
main(void)
{
	char icon[]	= "";
	time_t t = time(NULL);
	struct tm tm = *localtime(&t);

	printf("%s %.2d:%.2d\n",icon, tm.tm_hour, tm.tm_min);
	return 0;
}
