KeepItTidy
==========

Description
-----------

A light shell script to keep all my movies and TV shows files tidy

Usage
-----

<pre>
Usage: ../keepItTidy.sh [folder]

Dispatch all files in folder to movies or tv shows folders

Options
    -d --debug  Debug mode
    -h --help   Print Usage
Environment variables used:
    - KIT_TV_SHOWS_ROOT	TV Show top folder. 
    
Notice :
    - Tv shows will be inserted as : House/S09/House.S09E04.avi
</pre>

Development
-----------

You need to use Shunit2

````bash
sudo apt-get install shunit2
````

To launch tests :

````bash
cd tests
./tests.sh
````
