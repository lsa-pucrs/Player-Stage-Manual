#include <stdio.h>
#include <libplayerc++/playerc++.h>

int main(int argc, char *argv[])
{
      using namespace PlayerCc; /*need to do this line in c++ only*/

      PlayerClient    robot("localhost");

      OpaqueProxy     opaqueProxy(&robot,0);
      PlaySoundProxy  soundProxy(&robot,0);

      printf(" bye bye Player !\n");
      //some control code
      return 0;
}
