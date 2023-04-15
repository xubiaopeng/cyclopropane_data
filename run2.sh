for i in `seq 10000 10000 100000`
do
    echo $i
#    /Applications/VMD\ 1.9.2.app/Contents/MacOS/startup.command -dispdev text -args 9A_200.trr md_init.pdb  euler_angle_out_${i}_200ps_rotation $i < rotation_euler.tcl
    /Applications/VMD\ 1.9.2.app/Contents/MacOS/startup.command -dispdev text -args 9A_200.trr md_init.pdb  quaternion_out_${i}_200ps_rotation $i < rotation_quaternion.tcl
done
	 
	 
