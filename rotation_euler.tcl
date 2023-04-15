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
set com [measure center [atomselect top "resid 2 5 8 and name CA" frame $i] ]
#    puts $com
#    set r21 [vecsub [lindex $coords2 0] [lindex $coords1 0]]
set r1 [vecsub [lindex $coords1 0] $com]
set r2 [vecsub [lindex $coords2 0] $com]
set c [veccross $r1 $r2]
set Z [vecnorm $c] 
set X [vecnorm $r1]
set b [veccross $Z $X]
set Y [vecnorm $b]


for {set i 0 } {$i < $nf-1 } {incr i $sep} {
    
    set resd1 [atomselect top "resid 2 and name CA" frame [expr $i] ]
    set resd2 [atomselect top "resid 5 and name CA" frame [expr $i] ]
    set resd3 [atomselect top "resid 8 and name CA" frame [expr $i] ]
    set coord1 [$resd1 get {x y z}]
    set coord2 [$resd2 get {x y z}]
    set coord3 [$resd3 get {x y z}]
    set com [measure center [atomselect top "resid 2 5 8 and name CA" frame [expr $i] ] ]
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
    
    set alpha [expr atan2(-$R32,$R33)]
    #    set beta [expr atan2(sqrt(1-$R33*$R33),$R33)]
    set beta [expr atan2($R31,sqrt(1-$R31*$R31))]
    set gamma [expr atan2(-$R21,$R11)]

#    set tmp [format "%.15f" $tmp1]
#    set theta [expr acos($tmp)]
#lappend thetalist [expr acos($tmp)]
#    set tmpy [vecdot $R $B]
#    set tmpx [vecdot $R $A]
#    set phi [expr atan2($tmpy,$tmpx)]
#lappend philist [expr atan2($tmpy,$tmpx)]
    puts $fileId1 "$i $alpha $beta $gamma"
#    puts $fileId2 "$i $philist"
}
close $fileId1
#close $fileId2
