gobot
=====
A wrapper GoogleAPI to handle deployment tasks that require interacting with our Google services.

Install:
--------
1. Pull the code in locally.
1. `cd gobot`
1. `sudo rake install` (Adds  symlink to the gobot command in the /usr/bin folder.)

Synopsis:
---------
* `gobot --help` -- Show this synopsis.
* `gobot [<command>]` -- The basic signature for the gobot command.

Commands:
---------
* `add-restart-event` -- Adds Live Site Server Restarted event to IT Events Calendar.
