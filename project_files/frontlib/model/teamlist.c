#include "teamlist.h"

#include "../util/util.h"
#include "../util/list.h"
#include "../util/logging.h"

#include <stdlib.h>
#include <string.h>

flib_teamlist *flib_teamlist_create() {
	return flib_calloc(1, sizeof(flib_teamlist));
}

void flib_teamlist_destroy(flib_teamlist *list) {
	if(list) {
		for(int i=0; i<list->teamCount; i++) {
			flib_team_release(list->teams[i]);
		}
		free(list->teams);
		free(list);
	}
}

GENERATE_STATIC_LIST_INSERT(insertTeam, flib_team*)
GENERATE_STATIC_LIST_DELETE(deleteTeam, flib_team*)

static int findTeam(const flib_teamlist *list, const char *name) {
	for(int i=0; i<list->teamCount; i++) {
		if(!strcmp(name, list->teams[i]->name)) {
			return i;
		}
	}
	return -1;
}

int flib_teamlist_insert(flib_teamlist *list, flib_team *team, int pos) {
	if(!list || !team) {
		flib_log_e("null parameter in flib_teamlist_insert");
	} else if(!insertTeam(&list->teams, &list->teamCount, team, pos)) {
		flib_team_retain(team);
		return 0;
	}
	return -1;
}

int flib_teamlist_delete(flib_teamlist *list, const char *name) {
	int result = -1;
	if(!list || !name) {
		flib_log_e("null parameter in flib_teamlist_delete");
	} else {
		int itemid = findTeam(list, name);
		if(itemid>=0) {
			flib_team *team = list->teams[itemid];
			if(!deleteTeam(&list->teams, &list->teamCount, itemid)) {
				flib_team_release(team);
				result = 0;
			}
		}
	}
	return result;
}

flib_team *flib_teamlist_find(const flib_teamlist *list, const char *name) {
	flib_team *result = NULL;
	if(!list || !name) {
		flib_log_e("null parameter in flib_teamlist_find");
	} else {
		int itemid = findTeam(list, name);
		if(itemid>=0) {
			result = list->teams[itemid];
		}
	}
	return result;
}

void flib_teamlist_clear(flib_teamlist *list) {
	if(!list) {
		flib_log_e("null parameter in flib_teamlist_clear");
	} else {
		for(int i=0; i<list->teamCount; i++) {
			flib_team_release(list->teams[i]);
		}
		free(list->teams);
		list->teams = NULL;
		list->teamCount = 0;
	}
}
