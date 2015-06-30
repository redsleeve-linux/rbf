QEMU README
===========
You need to be root to issue the commands mentioned in this README
Steps
------
- Generate the image using 

        ./rbf.py build templates/qemu.xml
        
- Mount the boot partition using and copy over the required files

        commonscripts/mountpart.sh qemu-centos-image.img 1 /media/qemu
        cp -iv /media/qemu/vmlinuz* /media/qemu/initramfs* /media/qemu/dtb*/vexpress-v2p-ca9.dtb .
        umount /media/qemu

- You might want to expand the image. To do so
    
        qemu-img resize qemu-centos-image.img +10G
        
- The above step just allocates space, to actually resize the image you need gparted

        losetup /dev/loop0 qemu-centos-image.img
        partprobe /dev/loop0
        gparted /dev/loop0 #Right click on the partition and select Resize/Move
        losetup -d /dev/loop0
        
- Run the following command to launch qemu

        qemu-system-arm -m 1024M -M vexpress-a9 -cpu cortex-a9 -append "console=ttyAMA0,115200n8 rw root=/dev/mmcblk0p3" -nographic -dtb vexpress-v2p-ca9.dtb -kernel vmlinuz-4.0.0-1.el7.armv7hl -initrd initramfs-4.0.0-1.el7.armv7hl.img -sd qemu-centos-image.img
  
  
- To use bridge networking with QEMU. First setup bridge networking on you host. Then use the qemu-ifup script along with the command below

        qemu-system-arm -m 1024M -M vexpress-a9 -cpu cortex-a9 -append "console=ttyAMA0,115200n8 rw root=/dev/mmcblk0p3" -nographic -dtb vexpress-v2p-ca9.dtb -kernel vmlinuz-4.0.0-1.el7.armv7hl -initrd initramfs-4.0.0-1.el7.armv7hl.img -sd qemu-centos-image.img -net nic,vlan=0 -net tap,vlan=0,ifname=tap0,script=./qemu-ifup
        
- Login as root and password as password1234. 

- The QEMU image generated by RootFS Build Factory can be used to generate ARMv7 images on x86_64.