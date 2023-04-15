for i in `seq 1000 1000 10000`
do
    echo $i
        /Applications/VMD\ 1.9.2.app/Contents/MacOS/startup.command -dispdev text -args 9A_200.trr md_init.pdb  euler_angle_out_${i}_200ps_test1 $i < euler1.tcl
#    /Applications/VMD\ 1.9.2.app/Contents/MacOS/startup.command -dispdev text -args 9A_200.trr md_init.pdb  quaternion_euler_angle_out_${i}_200ps_test1 $i < quaternion.tcl
done
	 
	 
