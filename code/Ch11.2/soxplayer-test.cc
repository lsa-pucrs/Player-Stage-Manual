#include <iostream>
#include <libplayerc++/playerc++.h>
 
int main(int argc, char *argv[]){
	using namespace PlayerCc;
 	PlayerClient   robot("localhost",6665);
	SoundProxy     sound(&robot, 0);

	if(argc>1){
		sound.play(argv[1]);
	}else {
		std::cout << "and audio file name is expected'\n";
		return 1;
	}

	return 0;
}
