<h1>kaOS-2</h1>
<h2>Overall</h2><p>KaOS is a personal OS development project with little/no end goal. It's purpose is simply for learning. Version two is designed to solve infrastructural issues in the previous iteration. 
It has a <i>slightly</i> more clear goal and will not rely on the BIOS as the (yet unpushed to github) previous version did.</p>
<h2>Building</h2><p>KaOS must be built on linux. The building system must have a cross-platform gcc build targeting the i386 architecture, and this must be placed in the directory '/home/opt/cross'</p>
<p>To build the operating system simply run 'make' in the project directory. If qemu-system-i386 is installed you may run 'make run' in order to run KaOS in qemu. If you are building in a VM, you may want to mount a shared folder. Naming this folder 'sf_shared' lets you run 'make exp' which places the build .iso in the shared folder immediately for debugging or sharing.</p>
<h2>Running</h2><p>KaOS is yet untested on physical hardware (lord.) It may run on any x86 emulator but I haven't tested every single one of them.</p><p>Emulators I've tested KaOS in successfully:</p>
<ul>
  <li>Bochs (For debugging).</li>
  <li>Qemu (For quick tests).</li>
  <li>Oracle Virtualbox (For masochists).</li>
</ul>
