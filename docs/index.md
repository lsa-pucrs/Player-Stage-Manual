# How to Use Player/Stage

5th Edition

Using Player 3.0.2 and Stage 4.1.1 (development versions)

Kevin Nickels and Jennifer Owen

15 September 2015

A user manual for the Player/Stage robot simulator.

This document is intended as a guide for anyone learning Player/Stage for the
first time. It explains the process of setting up a new simulation
environment and how to then make your simulation do something, using a case
study along the way. Whilst it is aimed at Player/Stage users, those just
wishing to use Player on their robot may also find sections of this
document useful (particularly the parts about coding with Player).

If you have any questions about using Player/Stage there is a guide to getting
help from the Player community at
[http://playerstage.sourceforge.net/wiki/Getting_help](http://playerstage.sourceforge.net/wiki/Getting_help)

This edition of the manual uses the development versions of Player and
Stage.  They can be found at 
[https://github.com/playerproject/player.git]
(https://github.com/playerproject/player.git)
and
at 
[https://github.com/rtv/Stage.git]
(https://github.com/rtv/Stage.git)
.  The build process for player and
stage is outside the scope of this manual - excellent instructions can be
found at
[http://playerstage.sourceforge.net/doc/Player-3.0.2/player/install.html] 
(http://playerstage.sourceforge.net/doc/Player-3.0.2/player/install.html)
and
[http://rtv.github.io/Stage/install.html]
(http://rtv.github.io/Stage/install.html)

There are only minor changes from v4.0.0 to this version of the manaul.
Other versions of this manual are available at

* [v2.0.0 - Using player-3.0.2 and stage-3.2.x (PDF)](http://player-stage-manual-readthedocs.org/en/v2.0.0/)
* [v4.0.0 - Using player-3.0.2 and stage-4.1.1 (PDF)](http://player-stage-manual-readthedocs.org/en/v4.0.0/)
* [v4.1.0/stable - Using latest stable releases - player-3.0.2 and * stage-4.1.1](http://player-stage-manual-readthedocs.org/en/stable/)
* [latest - Using very latest code from github.com - player-3.0.2-svn and Stage from (RTD)](http://player-stage-manual-readthedocs.org/en/latest/)


# TABLE OF CONTENTS
1. [Introduction](INTRO.md)
2. [The Basics](BASICS.md)
3. [Building a World](WORLDFILES.md)
4. [Writing a Configuration (.cfg) File](CFGFILES.md)
5. [Getting Your Simulation to Run Your Code](CONTROLLERS.md)
5. [Controllers (C++)](CONTROLLER_CPP.md)
5. [Controllers (C)](CONTROLLER_C.md)
5. [Controllers (Py-libplayercpp)](CONTROLLER_PYCPP.md)
5. [Controllers (Py-libplayerc)](CONTROLLER_PYC.md)

### Change Log
* 15 Sept 2015 forked off development version of manual
* 7 Aug 2015 released v4.1.0 covering stable versions
* 30 June 2015 updating markdown for [readthedocs.org](http://readthedocs.org)
* 18 May 2015 began migration from LaTeX to MARKDOWN on [GitHub](http://github.com)
* August 2013 updated manual to Stage 4.1.1
* 1st August 2013 Source code made available online
* 16th April 2010 updated manual to Stage 3.2.2
* 10th July 2009 original manual covering Stage versions 2.1.1 and 3.1.0
