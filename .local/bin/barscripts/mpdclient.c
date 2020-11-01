#include <mpd/client.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "button.h"

#define MAX_LINES 30

int
main(void)
{
	char paused[4];
	char *full_status;
	char icon[] = " ";
	const char *artistname;
	const char *songname;
	struct mpd_connection *conn = mpd_connection_new(NULL, 0, 0);
	struct mpd_status *status;
	struct mpd_song *song;

	// error handling
	if (conn == NULL) {
		fprintf(stderr, "Out of memory\n");
		return 1;
	}
	if (mpd_connection_get_error(conn) != MPD_ERROR_SUCCESS) {
		mpd_connection_free(conn);
		return 1;
	}
	commands *cmds = cmdinit("mpc -q toggle", NULL, "nowplaying", "mpc -q next", "mpc -q prev", NULL);

	buttonhandler(cmds);

	freecmds(cmds);

	/* If song name is not accecible, just print play/pause icon */
	if((song = mpd_run_current_song(conn))) {
		artistname = mpd_song_get_tag(song, MPD_TAG_ARTIST, 0);
		songname = mpd_song_get_tag(song, MPD_TAG_TITLE, 0);
		status =  mpd_run_status(conn);

		full_status = (char*) malloc((strlen(artistname) + strlen(songname) + 10) * sizeof(full_status));

		strcpy(full_status, icon);
		strcat(full_status, artistname);
		strcat(full_status, " - ");
		strcat(full_status, songname);
		strcat(full_status, "\0");

		if (mpd_status_get_state(status) == MPD_STATE_PLAY)
			strcpy(paused, "");
		else
			strcpy(paused, "");

		mpd_song_free(song);
		mpd_status_free(status);

		/* puts tree dots at the end of full_status, if it exedes MAX_LINES */
		for (int i = 0, over = 0; strcmp(&full_status[i], "\0"); i++) {
			if (i >= MAX_LINES)
				over++;
			if (over > 3 && over < 5) {
				full_status[i] = *".";
				full_status[i-1] = *".";
				full_status[i-2] = *".";
			} else if (over >= 5)
				full_status[i] = *"\0";
		}

		printf("%s%s\n", full_status, paused);
		free(full_status);
	} else {
		strcpy(paused, "");
		printf("%s\n", paused);
	}

	// close the connection and free memory
	mpd_connection_free(conn);
}
