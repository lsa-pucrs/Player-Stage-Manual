How to Use Player/Stage
=======================

6th Edition

Using Player 3.0.2 and Stage 4.1.1 (development versions)

Kevin Nickels, Jennifer Owen, Alexandre Amory

2 July 2017

A user manual for the Player/Stage robot simulator.

This document is intended as a guide for anyone learning Player/Stage
for the first time. It explains the process of setting up a new
simulation environment and how to then make your simulation do
something, using a case study along the way. Whilst it is aimed at
Player/Stage users, those just wishing to use Player on their robot may
also find sections of this document useful (particularly the parts about
coding with Player).

If you have any questions about using Player/Stage there is a guide to
getting help from the Player community at
http://playerstage.sourceforge.net/wiki/Getting_help

This edition of the manual uses the development versions of Player and
Stage. They can be found at https://github.com/playerproject/player.git
and at https://github.com/rtv/Stage.git . The build process for player
and stage is described in
http://playerstage.sourceforge.net/doc/Player-3.0.2/player/install.html
and http://rtv.github.io/Stage/install.html

There are only minor changes from v4.1.0 to this version of the manual.
Versions older than that contain significant changes are are now
outdated. Other versions of this manual are available at

-  `master/latest - Using very latest code from github.com -
   player-3.0.2-svn and
   Stage <http://player-stage-manual.readthedocs.org/en/latest/>`__
   (RTD)
-  `v4.1.0/stable - Using latest stable releases - player-3.0.2 and
   stage-4.1.1 <http://player-stage-manual.readthedocs.org/en/stable/>`__
   (RTD)
-  `v4.0.0 - Using player-3.0.2 and
   stage-4.1.1 <http://player-stage-manual.readthedocs.org/en/v4.0.0/>`__
   (PDF)
-  `v2.0.0 - Using player-3.0.2 and
   stage-3.2.x <http://player-stage-manual.readthedocs.org/en/v2.0.0/>`__
   (PDF)

TABLE OF CONTENTS
=================

1.  `Introdução <INTRO.rst>`__
2.  `O Básico <BASICS.rst>`__
3.  `Construindo um Mundo <WORLDFILES.rst>`__
4.  `Escrevendo a Configuração (.cfg) File <CFGFILES.rst>`__
5.  `Fazendo Sua Simulação Rodar Seu Código <CONTROLLERS.rst>`__
6.  `Controllers (C++) <CONTROLLER_CPP.rst>`__
7.  `Controllers (C) <CONTROLLER_C.rst>`__
8.  `Controllers (Py-libplayercpp) <CONTROLLER_PYCPP.rst>`__
9.  `Controllers (Py-libplayerc) <CONTROLLER_PYC.rst>`__
10. `Construindo uma Nova Interface (C/C++) <INTERFACES.rst>`__
11. `Construindo um Novo Driver (C/C++) <DRIVERS.rst>`__

Change Log
~~~~~~~~~~

-  3 July 2017 forked by `LSA (Laboratório de Sistemas
   Autônomos) <lsa.pucrs.br>`__ to include updated instructions for the
   build process and instruction to create new drivers and interfaces.
-  15 Sept 2015 forked off development version of manual
-  7 Aug 2015 released v4.1.0 covering stable versions
-  30 June 2015 updating markdown for
   `readthedocs.org <http://readthedocs.org>`__
-  18 May 2015 began migration from LaTeX to MARKDOWN on
   `GitHub <http://github.com>`__
-  August 2013 updated manual to Stage 4.1.1
-  1st August 2013 Source code made available online
-  16th April 2010 updated manual to Stage 3.2.2
-  10th July 2009 original manual covering Stage versions 2.1.1 and
   3.1.0
