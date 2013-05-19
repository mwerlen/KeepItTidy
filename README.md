KeepItTidy
==========

A light shell script to keep all my movies and TV shows files tidy

Usage: ../keepItTidy.sh [folder]
Dispatch all files in folder to movies or tv shows folders
Environment variables used:
	- KIT_TV_SHOWS_ROOT	TV Show top folder. Tv shows will be inserted as : 
				<tv_show_name>/S<season_number>/<tv_show_short_name>S<season_number>E<episode_number>.<file_extension>
	- KIT_MOVIES_ROOT	Movies folder. All movies will be inserted as :
				<IMBD_name> (<year>).<file_extension>

