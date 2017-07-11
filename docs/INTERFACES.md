<!---
# Chapter 10 - Building a New Interface
--->

The previous sections, from 1 to 9, focus on the construction of a new scenario (world and models) and the client side controller software.
However, if you have to build a new interface or device driver for Player, you will only find out-of-date and incomplete instructions. 
Thus, the motivation of this new section is to reduce effort so that new resources can be built for Player.

## 10.1 - Definition of a Player Interface

An interface is defined in two different parts of Player documentation 

* [Definition 1](http://playerstage.sourceforge.net/doc/Player-3.0.2/player/group__interfaces.html).
All Player communication occurs through interfaces, which specify the syntax and semantics for a set of messages.
* [Definition 2](http://playerstage.sourceforge.net/doc/Player-3.0.2/player/group__tutorial__devices.html).
A specification of how to interact with a certain class of robotic sensor, actuator, or algorithm. The interface defines the syntax and semantics of all messages that can be exchanged with entities in the same class.

Consider the ranger interface. This interface defines a format in which a generic (vendor independent) range sensor can return range readings. So it defines the data structure of messages exchanged between a client-side controller and a serve-side device driver. This is how Player abstracts the specifics of a hardware module, such as a ranger device. For example, SICK LMS200 device has its own protocol to interface with its hardware, however, when integrated with Player, the Player driver for SICK LMS200 will use the generic vendor independent ranger interface. Thus, the client-side controller software is not aware of the laser ranger brand. 

So, when a client-side controller software creates the `sonarProxy` device based on the `RangerProxy`, we are defining that this device obeys the `ranger interface`, sending and receiving messages according to the data types (structs) defined in this interface. For instance, when the `sonarProxy.GetRange(i)` method is executed, the read message has the following format `player_ranger_data_range_t`, defined in the file `libplayerinterface/interfaces/062_ranger.def`. 

```tiobox
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
```

## 10.2 - When to Create a New Interface

It is unlikely that you have to create a new interface if you are using a conventional robot because Player already has a vast number of [interfaces](http://playerstage.sourceforge.net/doc/Player-3.0.2/player/group__interfaces.html) for the most used resources in robots. If you do have to define a new interface, please follow the recommended guidelines to maintain future software compatibility and documentation style. 

## 10.3 - How an Interface is Created


There is a very brief description about adding new interfaces at `libplayerinterface/interfaces/ADDING_INTERFACES`. It gives the basic information about interfaces, but it lacks useful information which were included in this document. The `ADDING_INTERFACES` says:

```tiobox
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
```
There is also an example interface located at `examples\plugins\exampleinterface` which might be useful for some users, but I think it is quite complicated for beginners. 

The ranger interface is also quite complicated. Thus, it's not an adequate example to start with. 
On the other hand, the speech interface (`libplayerinterface/interfaces/012_speech.def`) is one of the simplest Players interfaces. 
This interface is a generic interface to any speech synthesizer.  It is defined as:

```tiobox
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
```

The speech interface has only one message and one data structure (`player_speech_cmd_t`) carrying the sentence to be spoken by the robot. 

Another interesting interface is the bumper, defined at `libplayerinterface/interfaces/014_bumper.def`: 

```tiobox
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

```

The bumper interface has three messages and its respective data type. Note that there are different message parameters in this interface. 
According to the Player manual, a message is defined as  `message { TYPE, SUBTYPE, SUBTYPE_CODE, DATA_TYPE };`
The `TYPE` field can be DATA, REQ, CMD. Data is used, for example, to read data out of a sensor, to read the robot's pose, device status, etc.
REQ is used to query a device, in a request/replay communication format. CMD is mostly used for an actuator to set its state. 
The `SUBTYPE` and `SUBTYPE_CODE` is used only to differentiate messages of the same TYPE. Finally, the `DATA_TYPE` is the struct used to carry the actual data of the message.

## 10.4 - Creating an Interface

As an example, we are are going to create the so called `sound interface`. This interface will send the filename of an audio file so that the robot can play this file. We are assuming that the client side knows the audio files in the robot's computer. No actual audio file is transferred in the message, just the audio filename. 

Looking at the Player [interfaces](http://playerstage.sourceforge.net/doc/Player-3.0.2/player/group__interfaces.html) list, there is the [audio](http://playerstage.sourceforge.net/doc/Player-3.0.2/player/group__interface__audio.html) interface, but it is not adequate for our purposes since it is much more complicated than our specification. For this reason, we are going to create a new interface called **`playsound`**.

### 10.4.1 - Creating the Message Type

The playsound interface is defined bellow, and it is located at `<source_code>/Ch10.1`. 

```tiobox
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
  char *filename;
} player_playsound_cmd_t;
```

It has a single message and data type, which is used to send the audio filename to be played at the robot. 
This file must be saved as `libplayerinterface/interfaces/066_playsound.def`. The number 066 must be the last interface number used in the directory `libplayerinterface/interfaces/`.

Now we have to edit the `libplayerinterface/CMakeLists.txt` file to compile our new interface. The part of the CMakefile that defines the interface files must change from 

```tiobox
                     interfaces/063_vectormap.def
                     interfaces/064_blackboard.def
                     interfaces/065_stereo.def)
```

to 

```tiobox
                     interfaces/063_vectormap.def
                     interfaces/064_blackboard.def
                     interfaces/065_stereo.def
                     interfaces/066_playsound.def)
```

The next step is to create the new Proxies that use the playsound interface. We are going to call them **PlaySound Proxy**. Two versions are created, one for C (PlayerC) and C++ (PlayerCpp).

### 10.4.2 - Creating the PlayerC Proxy

This file, located at `<source_code>/Ch10.1`, must be copied to `client_libs/libplayerc/dev_playsound.c`. 

```tiobox
/*
 *  libplayerc : a Player client library
 *  Copyright (C) Andrew Howard 2002-2003
 *   2017: Guilherme Marques and Alexandre Amory 
 *
 *  This program is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU General Public License
 *  as published by the Free Software Foundation; either version 2
 *  of the License, or (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 *
 */
/*
 *  Player - One Hell of a Robot Server
 *  Copyright (C) Andrew Howard 2003
 *
 *
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public
 *  License as published by the Free Software Foundation; either
 *  version 2.1 of the License, or (at your option) any later version.
 *
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this library; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
/*  playsound Proxy for libplayerc library.
 *  Structure based on the rest of libplayerc.
 */
#include <assert.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>

#include "playerc.h"
#include "error.h"

// Local declarations
void playerc_playsound_putmsg(playerc_sound_t *device,
                           player_msghdr_t *header,
                           player_playsound_cmd_t *data,
                           size_t len);

// Create a new sound proxy
playerc_playsound_t *playerc_playsound_create(playerc_client_t *client, int index)
{
  playerc_playsound_t *device;

  device = malloc(sizeof(playerc_playsound_t));
  memset(device, 0, sizeof(playerc_playsound_t));
  playerc_device_init(&device->info, client, PLAYER_SOUND_CODE, index,
                      (playerc_putmsg_fn_t) playerc_playsound_putmsg);

  return device;
}

// Destroy a sound proxy
void playerc_playsound_destroy(playerc_playsound_t *device)
{
  playerc_device_term(&device->info);
  free(device);
}

// Subscribe to the sound device
int playerc_playsound_subscribe(playerc_playsound_t *device, int access)
{
  return playerc_device_subscribe(&device->info, access);
}

// Un-subscribe from the sound device
int playerc_playsound_unsubscribe(playerc_playsound_t *device)
{
  return playerc_device_unsubscribe(&device->info);
}

// Process incoming data
void playerc_playsound_putmsg(playerc_playsound_t *device, player_msghdr_t *header,
                            player_playsound_cmd_t *data, size_t len)
//                            char *data, size_t len)
//                            void *data, size_t len)
{
  /* there's no much to do in this proxy. 
     check out for the dev_bumper or dev_opaque to see a not empty, but still simple example.
     basically, it checks wheter it is the expected header format and it 
     transfers data from 'data' to 'device' for each datatype defined in the interface.
  */
}

// set the file to be played into the audio device
int playerc_playsound_play(playerc_playsound_t *device, char *filename)
{
  player_playsound_cmd_t cmd;
  memset(&cmd, 0, sizeof(cmd));

  //strcpy(cmd.filename,filename);
  memset(&cmd, 0, sizeof(cmd));
  cmd.filename = filename;
  cmd.string_count = strlen(filename) + 1;   

  return playerc_client_write(device->info.client,
    &device->info, PLAYER_PLAYSOUND_CMD_VALUES,&cmd,NULL);
}
```

The next step is to edit the `client_libs/libplayerc/playerc.h` file to define the playsound class. At the end of the file insert the following code:


```tiobox
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
PLAYERC_EXPORT int playerc_playsound_play(playerc_sound_t *playdevice, char *filename);

/** @} */
/***************************************************************************/
```

Edit the `client_libs/libplayerc/CMakeLists.txt` file from 

```tiobox
                     dev_vectormap.c
                     dev_wifi.c
                     dev_wsn.c)
```

to 

```tiobox
                     dev_vectormap.c
                     dev_wifi.c
                     dev_wsn.c
                     dev_playsound.c)
```

including the new proxy file for compilation.


### 10.4.3 - Creating the PlayerCpp Proxy

This file, located at `<source_code>/Ch10.1`, must be copied to `client_libs/libplayerc++/playsoundproxy.cc`. 

```tiobox
/*
 *  Player - One Hell of a Robot Server
 *  Copyright (C) 2000-2003
 *     Brian Gerkey, Kasper Stoy, Richard Vaughan, & Andrew Howard
 *   2017: Guilherme Marques and Alexandre Amory
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */
/********************************************************************
 *
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public
 *  License as published by the Free Software Foundation; either
 *  version 2.1 of the License, or (at your option) any later version.
 *
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this library; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 ********************************************************************/

/*
 * $Id: playsoundproxy.cc $
 */

#include "playerc++.h"
 
using namespace PlayerCc;

PlaySoundProxy::PlaySoundProxy(PlayerClient *aPc, uint32_t aIndex)
  : ClientProxy(aPc, aIndex),
  mDevice(NULL)
 {
  Subscribe(aIndex);
  mInfo = &(mDevice->info);
}
 
PlaySoundProxy::~PlaySoundProxy()
{
  Unsubscribe();
}

void PlaySoundProxy::Subscribe(uint32_t aIndex)
{
  scoped_lock_t lock(mPc->mMutex);
  mDevice = playerc_playsound_create(mClient, aIndex);
  if (NULL==mDevice)
    throw PlayerError("PlaySoundProxy::PlaySoundProxy()", "could not create");

  if (0 != playerc_playsound_subscribe(mDevice, PLAYER_OPEN_MODE))
    throw PlayerError("PlaySoundProxy::PlaySoundProxy()", "could not subscribe");
}
 
void PlaySoundProxy::Unsubscribe()
{
  assert(NULL!=mDevice);
  scoped_lock_t lock(mPc->mMutex);
  playerc_playsound_unsubscribe(mDevice);
  playerc_playsound_destroy(mDevice);
  mDevice = NULL;
}

void PlaySoundProxy::play(char *filename)
{
  scoped_lock_t lock(mPc->mMutex);
  if (0 != playerc_playsound_play(mDevice, filename))
    throw PlayerError("PlaySoundProxy::play()", "error playing file");
  return;
}
```


The next step is to edit the `client_libs/libplayerc++/playerc++.h` file to define the playsound class. At the end of the file insert the following code:


```tiobox
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
```

At the very end of the same file, there is block of << operator such as

```tiobox
   PLAYERCC_EXPORT std::ostream& operator << (std::ostream& os, const PlayerCc::RFIDProxy& c);
   PLAYERCC_EXPORT std::ostream& operator << (std::ostream& os, const PlayerCc::WSNProxy& c);
```

just insert another definition, like this one. 

```tiobox
   PLAYERCC_EXPORT std::ostream& operator << (std::ostream& os, const PlayerCc::RFIDProxy& c);
   PLAYERCC_EXPORT std::ostream& operator << (std::ostream& os, const PlayerCc::WSNProxy& c);
   PLAYERCC_EXPORT std::ostream& operator << (std::ostream& os, const PlayerCc::PlaySoundProxy& c);
```

Edit the `client_libs/libplayerc++/CMakeLists.txt` file from 

```tiobox
                         vectormapproxy.cc
                         wifiproxy.cc
                         wsnproxy.cc)
```

to 

```tiobox
                         vectormapproxy.cc
                         wifiproxy.cc
                         wsnproxy.cc
                         playsoundproxy.cc)
```

including the new proxy file for compilation. 

## 10.5 - Compiling the Interface

**TO BE DONE !!!**

## 10.6 - TRY IT OUT

An interface and proxy do anything except abstract the hardware. 
At least one driver is required to use this new interface. 
So, the actual test of the new interface is postponed to the next chapter, 
where we are going to build a device driver using the PlaySound. 

For now, we will create a controller using the new proxies, just to test the compilation process. 
It won't produce any noticeable result. We are going to use the following files for this test.

Player CFG:
```tiobox
driver
(
      name "opaque"
      provides ["6665:opaque:0" ]
)
```

Client Controller:
```tiobox
#include <stdio.h>
#include <libplayerc++/playerc++.h>

int main(int argc, char *argv[])
{
      using namespace PlayerCc; /*need to do this line in c++ only*/
	
      PlayerClient    robot("localhost");

      OpaqueProxy     opaqueProxy(&robot,0);
      PlaySoundProxy  soundProxy(&robot,0);

      //some control code
      return 0;
}
```

Launch Player: 
```tiobox
> cd <source_code>/Ch10.2
> player simple.cfg &
```


and finally, on another terminal, compile and run the controller software.  
```tiobox
> cd <source_code>/Ch10.2
> make playSoundCpp
> ./playSoundCpp
```

It will only connect to Player and disconnect right after.


![img](http://nojsstats.appspot.com/UA-66082425-1/player-stage-manual.readthedocs.org)
