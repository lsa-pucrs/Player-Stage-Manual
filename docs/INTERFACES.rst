.. raw:: html

   <!---
   # Chapter 10 - Building a New Interface
   --->

The previous sections, from 1 to 9, focus on the construction of a new
scenario (world and models) and the client side controller software.
However, if you have to build a new interface or device driver for
Player, you will only find out-of-date and incomplete instructions.
Thus, the motivation of this new section is to reduce effort so that new
resources can be built for Player.

10.1 - Definition of a Player Interface
---------------------------------------

An interface is defined in two different parts of Player documentation

-  `Definition
   1 <http://playerstage.sourceforge.net/doc/Player-3.0.2/player/group__interfaces.html>`__.
   All Player communication occurs through interfaces, which specify the
   syntax and semantics for a set of messages.
-  `Definition
   2 <http://playerstage.sourceforge.net/doc/Player-3.0.2/player/group__tutorial__devices.html>`__.
   A specification of how to interact with a certain class of robotic
   sensor, actuator, or algorithm. The interface defines the syntax and
   semantics of all messages that can be exchanged with entities in the
   same class.

Consider the ranger interface. This interface defines a format in which
a generic (vendor independent) range sensor can return range readings.
So it defines the data structure of messages exchanged between a
client-side controller and a serve-side device driver. This is how
Player abstracts the specifics of a hardware module, such as a ranger
device. For example, SICK LMS200 device has its own protocol to
interface with its hardware, however, when integrated with Player, the
Player driver for SICK LMS200 will use the generic vendor independent
ranger interface. Thus, the client-side controller software is not aware
of the laser ranger brand.

So, when a client-side controller software creates the ``sonarProxy``
device based on the ``RangerProxy``, we are defining that this device
obeys the ``ranger interface``, sending and receiving messages according
to the data types (structs) defined in this interface. For instance,
when the ``sonarProxy.GetRange(i)`` method is executed, the read message
has the following format ``player_ranger_data_range_t``, defined in the
file ``libplayerinterface/interfaces/062_ranger.def``.

.. code:: tiobox

    int main (){

    ...
    RangerProxy      sonarProxy(&robot,0);
    ...

    cout << sonarProxy.GetRangeCount() << " sonar ranges: ";
    for (int i=0;i<sonarProxy.GetRangeCount()-1;i++)
        // Method 1
        cout<< sonarProxy[i] << ", ";
        // Method 2
        cout<< sonarProxy.GetRange(i) << ", ";

    }

10.2 - When to Create a New Interface
-------------------------------------

It is unlikely that you have to create a new interface if you are using
a conventional robot because Player already has a vast number of
`interfaces <http://playerstage.sourceforge.net/doc/Player-3.0.2/player/group__interfaces.html>`__
for the most used resources in robots. If you do have to define a new
interface, please follow the recommended guidelines to maintain future
software compatibility and documentation style.

10.3 - How an Interface is Created
----------------------------------

There is a very brief description about adding new interfaces at
``libplayerinterface/interfaces/ADDING_INTERFACES``. It gives the basic
information about interfaces, but it lacks useful information which were
included in this document. The ``ADDING_INTERFACES`` says:

.. code:: tiobox

    To add a new interface create a new file in this directory.
    The file name should be <interface number>_<interface name>.def
    The interface number should be padded to three digits to aid sorting.
    New interfaces should use the next free interface code rather than
    filling in gaps. This is to avoid confusion with old removed interfaces.

    In the file you should have:
     * a description block that contains a description of the interface
       for the documentation
     * a set of message blocks that define the interfaces messages
       these are structured as
         message { TYPE, SUBTYPE, SUBTYPE_CODE, DATA_TYPE };
     * the data types for your interface in standard C code

    The best bet is to have a look at some of the other interfaces and
    copy what they have done

    When modifying an interface try to avoid renumbering the subtype codes.
    If you remove a subtype just leave a gap, this will aid in version
    compatibility.

There is also an example interface located at
``examples\plugins\exampleinterface`` which might be useful for some
users, but I think it is quite complicated for beginners.

The ranger interface is also quite complicated. Thus, it's not an
adequate example to start with. On the other hand, the speech interface
(``libplayerinterface/interfaces/012_speech.def``) is one of the
simplest Players interfaces. This interface is a generic interface to
any speech synthesizer. It is defined as:

.. code:: tiobox

    description {
     * @brief Speech synthesis

    The @p speech interface provides access to a speech synthesis system.
    }

    /** Command subtype: say a string */
    message { CMD, SAY, 1, player_speech_cmd_t };

    /** @brief Command: say a string (@ref PLAYER_SPEECH_CMD_SAY)

    The @p speech interface accepts a command that is a string to
    be given to the speech synthesizer.*/
    typedef struct player_speech_cmd
    {
      /** Length of string */
      uint32_t string_count;
      /** The string to say */
      char *string;
    } player_speech_cmd_t;

The speech interface has only one message and one data structure
(``player_speech_cmd_t``) carrying the sentence to be spoken by the
robot.

Another interesting interface is the bumper, defined at
``libplayerinterface/interfaces/014_bumper.def``:

.. code:: tiobox

    description {
    @brief An array of bumpers

    The @p bumper interface returns data from a bumper array.  This interface
    accepts no commands.
    }

    message { DATA, STATE, 1, player_bumper_data_t };
    message { DATA, GEOM, 2, player_bumper_geom_t };

    message { REQ, GET_GEOM, 1, player_bumper_geom_t };

    /** @brief Data: state (@ref PLAYER_BUMPER_DATA_GEOM)

    The @p bumper interface gives current bumper state*/
    typedef struct player_bumper_data
    {
      /** the number of valid bumper readings */
      uint32_t bumpers_count;
      /** array of bumper values */
      uint8_t *bumpers;
    } player_bumper_data_t;

    /** @brief The geometry of a single bumper */
    typedef struct player_bumper_define
    {
      /** the local pose of a single bumper */
      player_pose3d_t pose;
      /** length of the sensor [m] */
      float length;
      /** radius of curvature [m] - zero for straight lines */
      float radius;
    } player_bumper_define_t;

    /** @brief Data AND Request/reply: bumper geometry

    To query the geometry of a bumper array, send a null
    @ref PLAYER_BUMPER_GET_GEOM request.  The response will be in this form.  This
    message may also be sent as data with the subtype @ref PLAYER_BUMPER_DATA_GEOM
    (e.g., from a robot whose bumper can move with respect to its body)
    */
    typedef struct player_bumper_geom
    {
      /** The number of valid bumper definitions. */
      uint32_t bumper_def_count;
      /** geometry of each bumper */
      player_bumper_define_t *bumper_def;
    } player_bumper_geom_t;

The bumper interface has three messages and its respective data type.
Note that there are different message parameters in this interface.
According to the Player manual, a message is defined as
``message { TYPE, SUBTYPE, SUBTYPE_CODE, DATA_TYPE };`` The ``TYPE``
field can be DATA, REQ, CMD. Data is used, for example, to read data out
of a sensor, to read the robot's pose, device status, etc. REQ is used
to query a device, in a request/replay communication format. CMD is
mostly used for an actuator to set its state. The ``SUBTYPE`` and
``SUBTYPE_CODE`` is used only to differentiate messages of the same
TYPE. Finally, the ``DATA_TYPE`` is the struct used to carry the actual
data of the message.

10.4 - Creating an Interface
----------------------------

As an example, we are are going to create the so called
**``playsound``** interface. This interface will send the filename of an
audio file so that the robot can play this file. We are assuming that
the client side knows the audio files in the robot's computer. No actual
audio file is transferred in the message, just the audio filename.

Looking at the Player
`interfaces <http://playerstage.sourceforge.net/doc/Player-3.0.2/player/group__interfaces.html>`__
list, there is the
`audio <http://playerstage.sourceforge.net/doc/Player-3.0.2/player/group__interface__audio.html>`__
interface, but it is not adequate for our purposes since it is much more
complicated than our specification. For this reason, we are going to
create the ``playsound`` interface.

10.4.1 - Creating the Message Type
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The playsound interface is defined below, and it is located at
``<source_code>/Ch10.1``.

.. code:: tiobox

    description{
    @brief Interface to an simpler audio system

    It @p plays an audio file stored in the robot's computer.
    }

    /** Cmd subtype: play audio file command */
    message { CMD, VALUES, 1, player_playsound_cmd_t };


    /** @brief Command: audio file
     * Send a @ref PLAYER_PLAYSOUND_CMD_VALUES cmd to play an audio file
     **/
    typedef struct player_playsound_cmd
    {
      /** Length of string */
      uint32_t string_count;
      /** The audio filename to be played*/
      char *string;
    } player_playsound_cmd_t;

It has a single message and data type, which is used to send the audio
filename to be played at the robot. This file must be saved as
``libplayerinterface/interfaces/067_playsound.def``. The number 067 does
not matter. But it must be the last interface number used in the
directory ``libplayerinterface/interfaces/``.

Now we have to edit the ``libplayerinterface/CMakeLists.txt`` file to
compile our new interface. The part of the CMakefile that defines the
interface files must change from

.. code:: tiobox

                         interfaces/064_blackboard.def
                         interfaces/065_stereo.def
                         interfaces/066_coopobject.def)

to

.. code:: tiobox




                         interfaces/064_blackboard.def
                         interfaces/065_stereo.def
                         interfaces/066_coopobject.def
                         interfaces/067_playsound.def)

The next step is to create the new Proxies that use the playsound
interface. We are going to call them **PlaySound Proxy**. Two versions
are created, one for C (PlayerC) and C++ (PlayerCpp).

10.4.2 - Creating the PlayerC Proxy
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The ``<source_code>/Ch10.1/dev_playsound.c`` file must be copied to
``client_libs/libplayerc/dev_playsound.c``. The functions defined in
this proxy are listed below. Except for the last function, the other are
mandatory for all proxies, with very similar prototypes across diferent
proxies.

::

    void playerc_playsound_putmsg(playerc_playsound_t *device,
                               player_msghdr_t *header,
                               player_playsound_cmd_t *data,
                               size_t len);

    // Create a new sound proxy
    playerc_playsound_t *playerc_playsound_create(playerc_client_t *client, int index);

    // Destroy a sound proxy
    void playerc_playsound_destroy(playerc_playsound_t *device);


    // Subscribe to the sound device
    int playerc_playsound_subscribe(playerc_playsound_t *device, int access);


    // Un-subscribe from the sound device
    int playerc_playsound_unsubscribe(playerc_playsound_t *device);


    // Process incoming data
    void playerc_playsound_putmsg(playerc_playsound_t *device, player_msghdr_t *header,
                                player_playsound_cmd_t *data, size_t len);


    // set the file to be played into the audio device
    int playerc_playsound_play(playerc_playsound_t *device, char *filename);

The next step is to edit the ``client_libs/libplayerc/playerc.h`` file
to define the playsound class. At the end of the file insert the
following code:

.. code:: tiobox

    /**************************************************************************/
    /** @ingroup playerc_proxies
     * @defgroup playerc_proxy_playsound playsound
     * @brief The PlaySound proxy provides an interface to play audio files stored into the robot's computer.

    @{
    */

    /** PlaySound proxy data. */
    typedef struct
    {
      /** Device info; must be at the start of all device structures. */
      playerc_device_t info;
      // if the proxy requires any attribute, it would be placed here
    } playerc_playsound_t;


    /** Create a playsound proxy. */
    PLAYERC_EXPORT playerc_playsound_t *playerc_playsound_create(playerc_client_t *client, int index);

    /** Destroy a playsound proxy. */
    PLAYERC_EXPORT void playerc_playsound_destroy(playerc_playsound_t *device);

    /** Subscribe to the sound device. */
    PLAYERC_EXPORT int playerc_playsound_subscribe(playerc_playsound_t *device, int access);

    /** Un-subscribe from the playsound device. */
    PLAYERC_EXPORT int playerc_playsound_unsubscribe(playerc_playsound_t *device);

    /** Play a playsound file by name. */
    PLAYERC_EXPORT int playerc_playsound_play(playerc_playsound_t *playdevice, char *filename);

    /** @} */
    /***************************************************************************/

Edit the ``client_libs/libplayerc/CMakeLists.txt`` file from

.. code:: tiobox

                         dev_vectormap.c
                         dev_wifi.c
                         dev_wsn.c)

to

.. code:: tiobox

                         dev_vectormap.c
                         dev_wifi.c
                         dev_wsn.c
                         dev_playsound.c)

including the new proxy file for compilation.

10.4.3 - Creating the PlayerCpp Proxy
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The
``<source_code>/Ch10.1/playsoundproxy.cc`` file must be copied to``\ client\_libs/libplayerc++/playsoundproxy.cc\ ``. This file encapsulates the functions defined in``\ client\_libs/libplayerc/dev\_playsound.c\ ``as a C++ class called``\ PlaySoundProxy.\`

The next step is to edit the ``client_libs/libplayerc++/playerc++.h``
file to define the playsound class. At the end of the file insert the
following code:

.. code:: tiobox

    /**
    The @p PlaySoundProxy class is used to play an audio file located in the robot's computer.
    */
    class PLAYERCC_EXPORT PlaySoundProxy : public ClientProxy
    {
      private:

        void Subscribe(uint32_t aIndex);
        void Unsubscribe();

        /// the interface data structure
        playerc_playsound_t *mDevice;

      public:
        /// constructor
        PlaySoundProxy(PlayerClient *aPc, uint32_t aIndex=0);
        /// destructor
        ~PlaySoundProxy();
        /// the main method of the proxy, used to send the audio filename to be player
        void play(char *filename);
    };

At the very end of the same file, there is block of << operator such as

.. code:: tiobox

       PLAYERCC_EXPORT std::ostream& operator << (std::ostream& os, const PlayerCc::RFIDProxy& c);
       PLAYERCC_EXPORT std::ostream& operator << (std::ostream& os, const PlayerCc::WSNProxy& c);

just insert another definition, like this one.

.. code:: tiobox

       PLAYERCC_EXPORT std::ostream& operator << (std::ostream& os, const PlayerCc::RFIDProxy& c);
       PLAYERCC_EXPORT std::ostream& operator << (std::ostream& os, const PlayerCc::WSNProxy& c);
       PLAYERCC_EXPORT std::ostream& operator << (std::ostream& os, const PlayerCc::PlaySoundProxy& c);

Edit the ``client_libs/libplayerc++/CMakeLists.txt`` file from

.. code:: tiobox

                             vectormapproxy.cc
                             wifiproxy.cc
                             wsnproxy.cc)

to

.. code:: tiobox

                             vectormapproxy.cc
                             wifiproxy.cc
                             wsnproxy.cc
                             playsoundproxy.cc)

including the new proxy file for compilation.

10.5 - Compiling the Interface
------------------------------

Go to the Player source code dir where you edited the files above. If
there is not a build dir, then create it and proceed with the Player
normal compilation procedure.

.. code:: tiobox

    > cd <player_source>/build
    > cmake  ..
    > make

When you change some interface definition, Player is recompiled from
strach.

10.6 - TRY IT OUT
-----------------

An interface and proxy do anything except abstract the hardware. At
least one driver is required to use this new interface. So, the actual
test of the new interface is postponed to the next chapter, where we are
going to build a device driver using the PlaySound.

For now, we will create a controller using the new proxies, just to test
the compilation process. It won't produce any noticeable result. We are
going to use the following files for this test.

Player CFG:

.. code:: tiobox

    driver
    (
          name "dummy"
          provides ["playsound:0" ]
          rate 30
    )

    driver
    (
          name "dummy"
          provides ["opaque:0" ]
          rate 30
    )

Client Controller:

.. code:: tiobox

    #include <stdio.h>
    #include <libplayerc++/playerc++.h>

    int main(int argc, char *argv[])
    {
          using namespace PlayerCc; /*need to do this line in c++ only*/

          PlayerClient    robot("localhost");

          OpaqueProxy     opaqueProxy(&robot,0);
          PlaySoundProxy  soundProxy(&robot,0);

          printf("bye bye Player !\n");
          //some control code
          return 0;
    }

Go to a terminal an launch Player:

.. code:: tiobox

    > cd <source_code>/Ch10.1
    > player simple.cfg &

and finally, on another terminal, compile and run the controller
software.

.. code:: tiobox

    > cd <source_code>/Ch10.1
    > make client
    > ./client

It will only connects to Player, prints a message, and disconnects right
after. On the Player terminal it will show

::

    $ player simple.cfg
    Player v.3.1.1-dev

    * Part of the Player/Stage/Gazebo Project [http://playerstage.sourceforge.net].
    * Copyright (C) 2000 - 2013 Brian Gerkey, Richard Vaughan, Andrew Howard,
    * Nate Koenig, and contributors. Released under the GNU General Public License.
    * Player comes with ABSOLUTELY NO WARRANTY.  This is free software, and you
    * are welcome to redistribute it under certain conditions; see COPYING
    * for details.

    Listening on ports: 6665
    accepted TCP client 0 on port 6665, fd 15
    closing TCP connection to client 0 on port 6665

and on the client terminal it will show

::

    $ ./client
    playerc warning   : warning : [Player v.3.1.1-dev] connected on [localhost:6665] with sock 3

    bye bye Player !

.. figure:: http://nojsstats.appspot.com/UA-66082425-1/player-stage-manual.readthedocs.org
   :alt: img

   img
