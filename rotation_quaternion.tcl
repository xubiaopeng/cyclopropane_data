set trrfile [lindex $argv 0]
set pdbfile [lindex $argv 1]
set output [lindex $argv 2]
set sep [lindex $argv 3]

package require topotools
mol load trr $trrfile pdb $pdbfile
set pi 3.1415926535897931
set fileId1 [open $output "w"]
#set fileId2 [open $nor_phi "w"]
set nf [molinfo top get numframes]
set i 0
set res1 [atomselect top "resid 2 and name CA" frame $i]
set res2 [atomselect top "resid 5 and name CA" frame $i]
set res3 [atomselect top "resid 8 and name CA" frame $i]
set coords1 [$res1 get {x y z}]
set coords2 [$res2 get {x y z}]
set coords3 [$res3 get {x y z}]
set com [measure center [atomselect top "resid 2 5 8 and name CA" frame $i] ];list
#    puts $com
#    set r21 [vecsub [lindex $coords2 0] [lindex $coords1 0]]
set r1 [vecsub [lindex $coords1 0] $com]
set r2 [vecsub [lindex $coords2 0] $com]
set c [veccross $r1 $r2]
set Z [vecnorm $c] 
set X [vecnorm $r1]
set b [veccross $Z $X]
set Y [vecnorm $b]

for {set i $sep } {$i < $nf-1 } {incr i $sep} {
#    puts "hi $i"    
    set resd1 [atomselect top "resid 2 and name CA" frame [expr $i] ]
    set resd2 [atomselect top "resid 5 and name CA" frame [expr $i] ]
    set resd3 [atomselect top "resid 8 and name CA" frame [expr $i] ]
    set coord1 [$resd1 get {x y z}]
    set coord2 [$resd2 get {x y z}]
    set coord3 [$resd3 get {x y z}]
    set com [measure center [atomselect top "resid 2 5 8 and name CA" frame [expr $i] ] ];list
    set r1 [vecsub [lindex $coord1 0] $com ]
    set r2 [vecsub [lindex $coord2 0] $com ]
    set c1  [veccross $r1 $r2]
    set Z1 [vecnorm $c1]
    set X1 [vecnorm $r1]
    set b1 [veccross $Z1 $X1]
    set Y1 [vecnorm $b1]

    set R11 [vecdot $X1 $X]
    set R12 [vecdot $X1 $Y]
    set R13 [vecdot $X1 $Z]
    set	R21 [vecdot $Y1 $X]
    set	R22 [vecdot $Y1 $Y]
    set	R23 [vecdot $Y1 $Z]
    set	R31 [vecdot $Z1 $X]
    set	R32 [vecdot $Z1 $Y]
    set	R33 [vecdot $Z1 $Z]
#    puts "$R11 $R22 $R33" 
    set absq0 [expr sqrt((1+$R11+$R22+$R33))]
    set absq1 [expr sqrt((1+$R11-$R22-$R33))]
    set absq2 [expr sqrt((1-$R11+$R22-$R33))]
    set absq3 [expr sqrt((1-$R11-$R22+$R33))]
#    puts "$absq0 $absq1 $absq2 $absq3"
    set u1 [list $absq0 [expr ($R32-$R23)/$absq0] [expr ($R13-$R31)/$absq0] [expr ($R21-$R12)/$absq0] ]
    set u2 [list [expr ($R32-$R23)/$absq1] $absq1 [expr ($R12+$R21)/$absq1] [expr ($R13+$R31)/$absq1] ]
    set u3 [list [expr ($R13-$R31)/$absq2] [expr ($R12+$R21)/$absq2] $absq2 [expr ($R23+$R32)/$absq2] ]
    set u4 [list [expr ($R21-$R12)/$absq3] [expr ($R31+$R13)/$absq3] [expr ($R32+$R23)/$absq3] $absq3 ]
    set tr1 [expr $R11+$R22+$R33]

    if {$tr1>=$R11 && $tr1>=$R22 && $tr1>=$R33} {
        set q $u1
    } elseif {$R11>=$tr1 && $R11>=$R22 && $R11>=$R33} {
        set q $u2
    } elseif {$R22>=$R11 && $R22>=$tr1 && $R22>=$R33} {
        set q $u3
    } elseif {$R33>=$R11 && $R33>=$R22 && $R33>=$tr1} {
        set q $u4
    } else {
        puts "error"
    }
#    puts $q
    set qw [expr 0.5*[lindex $q 0]]
    set qx [expr 0.5*[lindex $q 1]]
    set qy [expr 0.5*[lindex $q 2]]
    set qz [expr 0.5*[lindex $q 3]]
    #    puts "[expr 2*($qw*$qy-$qx*$qz)]"
    set alpha [expr atan2(2*($qw*$qx+$qy*$qz),1-2*($qx*$qx+$qy*$qy))]
    set beta [expr asin(2*($qw*$qy-$qx*$qz))]
    set gamma [expr atan2(2*($qw*$qz+$qx*$qy),1-2*($qy*$qy+$qz*$qz))]
#    puts "$i $alpha $beta $gamma"    
#    set tmp [format "%.15f" $tmp1]
#    set theta [expr acos($tmp)]
#lappend thetalist [expr acos($tmp)]
#    set tmpy [vecdot $R $B]
#    set tmpx [vecdot $R $A]
#    set phi [expr atan2($tmpy,$tmpx)]
#lappend philist [expr atan2($tmpy,$tmpx)]
    #    puts $fileId1 "$i $alpha $beta $gamma"
    puts $fileId1 "$i $qw $qx $qy $qz"
#    puts $fileId2 "$i $philist"
}
close $fileId1
#close $fileId2
