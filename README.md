KeepItTidy
==========

A light shell script to keep all my movies and TV shows files tidy

<pre>
Usage: ../keepItTidy.sh [folder]
Dispatch all files in folder to movies or tv shows folders
Environment variables used:
	- KIT_TV_SHOWS_ROOT	TV Show top folder. Tv shows will be inserted as : 
				&lt;tv_show_name&gt;/S&lt;season_number&gt;/&lt;tv_show_short_name&gt;S&lt;season_number&gt;E&lt;episode_number&gt;.&lt;file_extension&gt;
	- KIT_MOVIES_ROOT	Movies folder. All movies will be inserted as :
				&lt;IMBD_name&gt; (&lt;year&gt;).&lt;file_extension&gt;
</pre>
