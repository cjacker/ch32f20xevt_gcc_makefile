# ch32f20xevt with gcc and makefile support

This is pre-converted ch32f20x firmware library with gcc and makefile support from WCH official CH32F20xEVT.ZIP. It is converted by '[ch32f_evt_makefile_gcc_project_template](https://github.com/cjacker/ch32f_evt_makefile_gcc_project_template)'

This firmware library support below parts from WCH:

- ch32f203c6t6
- ch32f203k8t6
- ch32f203c8t6
- ch32f203c8u6
- ch32f203cbt6
- ch32f203rbt6
- ch32f203rct6
- ch32f203vct6
- ch32f205rbt6
- ch32f207vct6
- ch32f208rbt6
- ch32f208wbu6

The default part is set to 'ch32f203c8t6', you can change it with `./setpart.sh`. the corresponding 'Link.ld' and 'Startup file' will update automatically.

The default 'User' codes is 'GPIO_Toggle' from the EVT example, all examples shipped in original EVT package provided in 'Examples' dir.

To build the project, type `make`.
