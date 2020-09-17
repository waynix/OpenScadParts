module JGY_370motor(mode = "model"){
  //OTHER names: worm gear motor
  //46mm motor
  //Key measurements in mm
  gearboxWidth = 46;
  gearboxHeigth = 32;
  gearboxDepth = 22.5;
  motorDiameter = 24.5;
  motorHeight = 31;
  motorCablespace=10;
  gearboxMotorOffsetY = 19;
  gearboxMotorOffsetZ = 9.4;
  transsionStudY = gearboxHeigth / 2;
  
  distanceTransmissionStudX = 6;
  distanceTransmissionStudY = distanceTransmissionStudX;//value guessed
  //#translate([0,0,-2.67])cube([gearboxWidth,gearboxHeigth,2.67]);
  cube([gearboxWidth,gearboxHeigth,gearboxDepth]);
  translate([gearboxWidth,gearboxMotorOffsetY,gearboxMotorOffsetZ])rotate([0,90,0])cylinder(d=motorDiameter,h=motorHeight);
#translate([distanceTransmissionStudX,distanceTransmissionStudY,gearboxDepth]){
mountingHoles();
}
}

module mountingHoles(){
  distanceX=33;
  distanceY=18;
  mountStudHeight = 2;
  mountStudDiameter = 7.5;
  transmissionStudMountDiameter = 13;
  transmissionStudDiameter = 6;
  transmissionWedgeCutoff = 1;
  nodgeDiameter=6.5;
  nodgeLenght = 16-nodgeDiameter;
  nodgeX = 15.5;
  nodgeY =  distanceY / 2-nodgeLenght/2;
  
  for(point = [ [0,0], [0,distanceY], [distanceX,0], [distanceX,distanceY]])
  {
    translate(point)cylinder(d=mountStudDiameter,h=mountStudHeight);
  }
  translate([nodgeX,nodgeY])
  hull(){
    cylinder(d=6.5,h=mountStudHeight);
    translate([0,nodgeLenght])cylinder(d=6.5,h=mountStudHeight);
    
  }
}
//projection(cut=true)
translate([0,0,-23])JGY_370motor();
