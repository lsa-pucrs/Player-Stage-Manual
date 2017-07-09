PLAYERDRIVER_OPTION (soxplayer build_soxplayer ON)
PLAYERDRIVER_REJECT_OS (soxplayer build_soxplayer PLAYER_OS_WIN)
PLAYERDRIVER_REQUIRE_HEADER (soxplayer build_soxplayer soxplayer.h)
PLAYERDRIVER_ADD_DRIVER (soxplayer build_soxplayer LINKFLAGS -lsox SOURCES soxplayer.cc)
