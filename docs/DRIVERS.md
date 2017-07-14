<!---
# Chapter 11 - Building a New Driver
--->


## 11.1 - Definition of a Player Device Driver

A device driver, or just driver, is defined in the [Player documentation](http://playerstage.sourceforge.net/doc/Player-3.0.2/player/group__tutorial__devices.html) as
```
A piece of software (usually written in C++) that talks to a robotic sensor, actuator, or algorithm, and translates its inputs and outputs to conform to one or more interfaces. The driver's job is hide the specifics of any given entity by making it appear to be the same as any other entity in its class.
```

The driver is a vendor specific and it actually accesses the device hardware. However, it uses Player interfaces an proxies to abstract the vendor specifics details from the client controller software.
The Player documentation gives and example of a laser range finder. A driver is an implementation of a specific laser model of a specific vendor, such as SICK LMS200.
However, the Player programmer uses RangerProxy to access a generic laser ranger. The specific laser running on the robot is informed in the cfg file.


## 11.2 - The Architecture of a Player Device Driver

A Player driver source codes are located in the `server\drivers` dir, where the robot drivers are located under `server\drivers\mixed` dir.
The drivers `opaque` and `speech` are probably the simplest ones, so they are recommended to start understanding the driver architecture.

There are example drivers located at `examples\plugins\exampledriver`

This section explains the driver architecture using an example of a new Player driver for the audio library called [LibSoX](www.libsox.org).
The existing audio resources in Player are quite complicated, motivating the creation of a simpler and modern audio interface for robots.

The source code and compilation scripts for the `soxplayer` driver are located at `<source_code>/Ch11.1/`.
As can be seem  in `<source_code>/Ch11.1/soxplayer.h`, a Player driver is an extension of the class `ThreadedDriver`.
This class has virtual methods that must be defined in the new driver, such as:

- `virtual int ProcessMessage(QueuePointer & resp_queue, player_msghdr * hdr, void * data);`
It deals with messages coming from the clients
- `virtual int MainSetup();`
Set up the device when a client connects to the driver
- `virtual void MainQuit();`
Shutdown the device when the client is shutdown
- `virtual void Main();`
Main function for device thread

It is also mandatory to have a constructor which parses the cfg file, such as:

- `Soxplayer(ConfigFile* cf, int section);`

The driver must also have a device address attribute, declared as

- `player_devaddr_t sound_addr;`



The most important method is the `ProcessMessage`, where the incoming messages are checked and processed.
`PLAYER_PLAYSOUND_CMD_VALUES` and `player_playsound_cmd_t` must match with the interface used by the driver, in this case, the `playsound` interface, defined in [Chapter 10](INTERFACES.md).
The `MatchMessage` compares the incoming message header (`hdr`) with the expected interface header. If they match, then the incoming data (`data`) is typecasted to data interface type (`player_playsound_cmd_t`) and executed accordingly.

```tiobox
int Soxplayer::ProcessMessage(QueuePointer & resp_queue, player_msghdr * hdr, void * data){
	#ifndef NDEBUG
	  PLAYER_MSG0(MESSAGE_INFO,"[soxplayer] Msg received");
	#endif
	if (Message::MatchMessage(hdr, PLAYER_MSGTYPE_CMD, PLAYER_PLAYSOUND_CMD_VALUES, sound_addr)){
		Play((reinterpret_cast<player_playsound_cmd_t*>(data))->filename);
		return(0);
	}

	return(-1);
}
```

The `Play` method actually deals with the lib SoX details such as, open/read the audio file, apply effects, and send it to audio device driver at the OS level, in this case, `alsa`.

The SoxPlayer driver is a fairly simple driver dealing with a single interface, but a driver can be more complex and dealing with multiple interfaces.
It is highly recommended after doing this tutorial to experiment with more complex existing drivers in the `server\drivers` dir.


## 11.2 - Compiling the Player Device Driver

You can compile the driver as a stand-alone library or integrated to the Player source code distribution.
Usually, you would start with the stand-alone compilation until the driver is fully tested. Once it is
stable, documented, and it useful for other people, you can submit it as a patch for the Player maintainer, as explained next.


### 11.2.1 - Driver Depedencies

The soxplayer driver depends on the [LibSoX](http://sox.sourceforge.net/libsox.html). So, now it is the time to install this library with the following command:

```
> sudo apt-get install -y libsox-dev
```

### 11.2.2 - Compiling the Player Device Driver as a Stand-Alone driver

Initially, while you are still developing and testing your new driver, it is better to compile it separately from Player.
This section shows you how to compile like this. The environment variables `CMAKE_MODULE_PATH` and `PKG_CONFIG_PATH`
are very important in this step. Please check the [Section 1.1 - A Note on Installing Player/Stage](INTRO.md#11-a-note-on-installing-player-stage)
to see how to set these variables.
Details of [CMake](https://cmake.org/) and [PKGConfig](https://en.wikipedia.org/wiki/Pkg-config) are beyond the scope of this manual, but it is highly recommended subject of study if you plan to be a serious Player/stage developer or Linux software developer.

```
> cd <source_code>/Ch11.1/
> mkdir -p build
> cd build/
> cmake ../
> make
```

The driver library will be created in the current dir (`Ch11.1/build`). For convenience, there is a `compile.sh` script that does the same thing with a single command.
Alternatively, there is a the `Ch11.1/Mafefile`, which uses PKGConfig definitions instead of CMake.
Both scripts can be used as a template to compile other drivers.


### 11.2.3 - Compiling the Player Device Driver as part of Player distribution

If you really think that your driver can be useful for other people, it is highly recommended to include it into the Player source code distribution.
Here were are assuming a git version system is used for [Player](www.github/playerproject/player).

Download a new, clean, and updated Player source code it from [www.github/playerproject/player](www.github/playerproject/player) and follow these steps to add the soxplayer source code and scripts.
For this step, you cannot reuse an existing local copy because it might have your local changes.

```
> git clone https://github.com/playerproject/player.git
> cd  player/server/drivers
> mkdir sox
> cd sox
> cp <source_code>/Ch11.1/soxplayer.cc .
> cp <source_code>/Ch11.1/soxplayer.h .
> cp <source_code>/Ch11.2/soxplayer.cfg .
> cp <source_code>/Ch11.2/soxplayer-test.cc .
> cp <source_code>/Ch11.3/CMakeLists.txt .
```

Change the `player/server/drivers/CMakeLists.txt` file from

```
ADD_SUBDIRECTORY (sonar)
ADD_SUBDIRECTORY (speech)
```

to

```
ADD_SUBDIRECTORY (sonar)
ADD_SUBDIRECTORY (sox)
ADD_SUBDIRECTORY (speech)
```

Now it is time to recompile Player with its new driver

```
> cd  player/
> mkdir build
> ccmake ..
check the option soxplayer if it is ON or OFF
> cmake ..
> make -j 8
```

If it is ok, then create a patch file and submitted it to the [https://github.com/playerproject/player](https://github.com/playerproject/player)

```
> cd  player/
> git diff --cached > soxplayer_driver.patch
```

TO DO - this step gives this error.
```
CMakeFiles/playerdrivers.dir/__/drivers/sox/soxplayer.o: In function `player_driver_init':
soxplayer.cc:(.text+0x7d): multiple definition of `player_driver_init'
CMakeFiles/playerdrivers.dir/__/drivers/position/snd/snd.o:snd.cc:(.text+0x82): first defined here
collect2: error: ld returned 1 exit status
make[2]: *** [server/libplayerdrivers/libplayerdrivers.so.3.1.1-dev] Error 1
make[2]: Leaving directory `/home/osboxes/repos/player-new/build'
make[1]: *** [server/libplayerdrivers/CMakeFiles/playerdrivers.dir/all] Error 2
make[1]: Leaving directory `/home/osboxes/repos/player-new/build'
```

## 11.3 - TRY IT OUT

This test will fully test not only the soxplayer driver, but also the playsound interface developed in [Chapter 10](INTERFACES.md).
The example is located at `<source_code>/Ch11.2`.


The CFG file defines the soxplayer driver, without any parameter:
```tiobox
driver
(
	name "soxplayer"
	plugin "libsoxplayer"
	provides ["playsound:0"]
)
```

It assumes that the driver library is located in the same  directory or its path is defined in the LD_LIBRARY_PATH environment variable.

C++ client controller:
```tiobox
#include <iostream>
#include <libplayerc++/playerc++.h>

int main(int argc, char *argv[]){
	using namespace PlayerCc;
 	PlayerClient   robot("localhost",6665);
	PlaySoundProxy sound(&robot, 0);

	if(argc>1){
		sound.play(argv[1]);
	}else {
		std::cout << "and audio file name is expected'\n";
		return 1;
	}

	return 0;
}

```

It defines the `PlaySoundProxy` and it executes the filename `sound.play(argv[1])` passed as argument.

Launch Player:
```tiobox
> cd <source_code>/Ch11.2
> player soxplayer.cfg &
```

and finally, on another terminal, compile and run the controller software.  
```tiobox
> cd <source_code>/Ch11.2
> cmake .
> make
> ./soxplayer-test R2D2.mp3
```

It will play the R2D2 sound file and the client side terminal will show the following message.

```
$ ./soxplayer-test R2D2.mp3
playerc warning   : warning : [Player v.3.1.1-dev] connected on [localhost:6665] with sock 3

closing Player client
```

![img](http://nojsstats.appspot.com/UA-66082425-1/player-stage-manual.readthedocs.org)
