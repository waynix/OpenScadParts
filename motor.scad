$fn=30;
module JGY_370motor(mode = "model"){
  //OTHER names: worm gear motor
  //46mm motor
  //all measurements in mm
  gearboxWidth = 46;
  gearboxHeigth = 32;
  gearboxDepth = 22.5;
  motorDiameter = 24.5;
  motorHeight = 31 + 5;
  motorCablespace=10;
  gearboxMotorOffsetY = 19;
  gearboxMotorOffsetZ = 9.4;
  gearboxTranssionOffsetY = gearboxHeigth / 2;
  gearboxTranssionOffsetX = 15;
  
  
  translate([-gearboxTranssionOffsetX,-gearboxTranssionOffsetY,-22.5]){
    cube([gearboxWidth,gearboxHeigth,gearboxDepth]);
    translate([gearboxWidth,gearboxMotorOffsetY,gearboxMotorOffsetZ]){
      rotate([0,90,0])cylinder(d=motorDiameter,h=motorHeight);
    }
    
  }
  mountingHoles();
}

module mountingHoles(){
  //height of all mount studs
  mountStudHeight = 2;
  //transmission rod measurements
  transmissionCenterX = 9;
  transmissionCenterY = 9;
  transmissionStudMountDiameter = 13.5;
  transmissionStudDiameter = 6;
  transmissionWedgeCutoff = 1;
  transmissionWedgeStart = 2;
  transmissionRodHeight = 14;

  union(){
    cylinder(d=transmissionStudMountDiameter,h=mountStudHeight);
    cylinder(d=transmissionStudDiameter,h=mountStudHeight+transmissionRodHeight);
  }

  translate([-transmissionCenterX,-transmissionCenterY]){
  //mountstuds
  distanceX=33;
  distanceY=18;
  screwholeThickness= 3.5;
  screwholeHeight= 10;
  mountStudDiameter = 7.5;
      
    for(point = [ [0,0], [0,distanceY], [distanceX,0], [distanceX,distanceY]])
    {
      translate(point){
        cylinder(d=mountStudDiameter,h=mountStudHeight);
        cylinder(d=screwholeThickness,h=mountStudHeight+screwholeHeight);
      }
    }
  
    //aligning Nodge
    nodgeDiameter=6.5;
    nodgeLenght = 16-nodgeDiameter;
    nodgeX = 22;
    nodgeY =  distanceY / 2-nodgeLenght/2;
    translate([nodgeX,nodgeY])
    hull(){
      cylinder(d=6.5,h=mountStudHeight);
      translate([0,nodgeLenght])cylinder(d=6.5,h=mountStudHeight);
    
    }
  }
}

//test code here
rotate([180,0])
difference(){
    translate([-16,-17,-4])cube([80,34,7]);
JGY_370motor();
}
