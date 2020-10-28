difference(){
union(){
 translate([0,-4,-2]) cube([76,58,9]);    
 
}
cube([70,50,5]);
translate([0,7.5,-5])    cube([67,50-15,10]);
translate([-20,25,-15])cube([70,50,20]);
translate([35,25,-20])rotate([0,0,115])cube([70,50,20]);
translate([0,45,0])cube([50,2,20]);

}
translate([-10,47,5])cube([45,7,2]);
translate([-1.5,47+7,5.5])rotate([90,-30,0])cylinder($fn=6, d=3,h=7);