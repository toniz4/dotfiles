#include <string.h>
#include <stdlib.h>

typedef struct {
	char *cmd1, *cmd2, *cmd3, *cmd4, *cmd5, *cmd6;
} commands;

commands *cmdinit(char *cmd1, char *cmd2, char *cmd3, char *cmd4, char *cmd5, char *cmd6);

void freecmds(commands *cmd);

void buttonhandler(commands *cmd);

commands
*cmdinit(char *cmd1, char *cmd2, char *cmd3, char *cmd4, char *cmd5, char *cmd6)
{
	commands *p = malloc(sizeof(commands));

	if (cmd1 != NULL)
		p->cmd1 = strdup(cmd1);
	else
		p->cmd1 = strdup(":");
	if (cmd2 != NULL)
		p->cmd2 = strdup(cmd2);
	else
		p->cmd2 = strdup(":");
	if (cmd3 != NULL)
		p->cmd3 = strdup(cmd3);
	else
		p->cmd3 = strdup(":");
	if (cmd4 != NULL)
		p->cmd4 = strdup(cmd4);
	else
		p->cmd4 = strdup(":");
	if (cmd5 != NULL)
		p->cmd5 = strdup(cmd5);
	else
		p->cmd5 = strdup(":");
	if (cmd6 != NULL)
		p->cmd6 = strdup(cmd6);
	else
		p->cmd6 = strdup(":");

	return p;
}

void
freecmds(commands *cmd)
{
	free(cmd->cmd1);
	free(cmd->cmd2);
	free(cmd->cmd3);
	free(cmd->cmd4);
	free(cmd->cmd5);
	free(cmd->cmd6);
	free(cmd);
}

void
buttonhandler(commands *cmd)
{
	char * value;
	int opt;

	if (!(value = getenv("BUTTON")))
		return;
	else
		opt = atoi(value);

	switch (opt) {
		case 0:
			break;
		case 1:
			system(cmd->cmd1);
			break;
		case 2:
			system(cmd->cmd2);
			break;
		case 3:
			system(cmd->cmd3);
			break;
		case 4:
			system(cmd->cmd4);
			break;
		case 5:
			system(cmd->cmd5);
			break;
		case 6:
			system(cmd->cmd6);
			break;
		default:
			break;
	}
}
