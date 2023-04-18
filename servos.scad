/*
                                          Dimensions of a servo

               X ------------->                                         Y --------------->

                                                                          socketdiameter
                                                                             ├─────┤

                  axlecenterX                                              axlediameter
                    ├─────┤                                                   ├───┤

                        ┌┬┬┬┐                                        ──┬──    ┌┬┬┬┐    ──┬── axleheight
                      ┌─┴┴┴┴┴─┐                                        │     ┌┴┴┴┴┴┐   ──┼──
                    ┌─┴───────┴───────────────────┐          ───┬───   │    ┌┴─────┴┐  ──┴── socketheight
                    │                             │             │      │ t  │       │
              ┌─────┘                             └─────┐       │      │ o  ├───────┤  ──┬──
              │                                         │       │      │ t  │       │    │   tabheight
   ──┬───     └─────┐                             ┌─────┘       │ h    │ a  ├───────┤  ──┴──
 t   │              │                             │             │ e    │ l  │       │
 a   │              │                             │             │ i    │ h  │       │
 b   │              │                             │             │ g    │ e  │       │
 o   │              │                             │             │ h    │ i  │       │
 f   │              │                             │             │ t    │ g  │       │
 f   │              │                             │             │      │ h  │       │
 s   │              │                             │             │      │ t  │  ┌─┐  │   -> powerportdimensions
 e   │              │                             │             │      │    │  └─┘  │  ──┬──
 t   │              │                             │             │      │    │       │    | powerportoffset
   ──┴───           └─────────────────────────────┘          ───┴──────┴──  └───────┘  ──┴──


              │     │                             │     │                   │       │
              ├─────┤                             ├─────┤                   ├───────┤
              │     ├─────────────────────────────┤     │                   │ width │
              │ tab │          length             │ tab │                   │       │


                                                                            ├───────┤  ┬─
                                                                            │       │  │  mountingholelengthoffset
                                                       mountingholediameter │ o   o │  ┴─
                                                                            │       │
                                                                            └───────┘
                                                                                | |
                                                                                ├─┤
                                                                     mountingholecenteroffset

 Examples:

 servo(servos[0], model=true);
 servo(servos[0], cutout=true);
 servo(servos[0], holdblock=true, mountingscrewidth=2);

*/

// Array of known servos(see diagram above to derive your values) 
function servoTowerProMG996R() = [
    "TowerProMG996R",  // name
    40.5,              // length
    20,                // width
    7.3,               // tab
    38.4,              // height
    8.5,               // axlecenterX
    28.2,              // taboffset
    2.2,               // tabheight
    2,                 // socketheight
    3.7,               // axleheight
    5.8,               // axlediameter
    4.1,               // mountingholelengthoffset
    5,                 // mountingholecenteroffset
    13.2,              // socketdiameter
    4,                 // mountingholediameter
    4.5,               // powerportoffset
    [30,8,5]           // powerportdimensions (x choosen arbitrary)
];

function operativeHeight(dimensions = servoTowerProMG996R()) = dimensions[4] + dimensions[8];


// Draw a servo
// Note: Set only one of the values [cutout, holdblock, model] to true.
// dimensions: one element of the servo array of known servos
// cutout: will provide a version for the servo that can be subtracted from other objects
// holdblock: will provide an object that can be added to another object to hold a servo
// model: will generat a cad represemtation of the servo for rendering purposes
module servo(dimensions, cutout = false, holdblock=false,model=false, mountingscrewidth = 3.7) {
  length = dimensions[1];
  width = dimensions[2];
  tab = dimensions[3];
  height = dimensions[4];
  axlecenterX = dimensions[5];
  taboffset = dimensions[6];
  tabheight = dimensions[7];
  socketheight = dimensions[8];
  axleheight = dimensions[9];
  axlediameter = dimensions[10];
  mountingholelengthoffset = dimensions[11];
  mountingholecenteroffset = dimensions[12];
  socketdiameter = dimensions[13];
  mountingholediameter = dimensions[14];
  powerportoffset = dimensions[15];
  powerportdimensions = dimensions[16];

  // derived values
  totallength = length + tab * 2;
  totalheight = height + socketheight + axleheight;
  axlecenterY = width / 2;
  sigma = 0.1;
  
  mountingholeoffsets = [
    [-axlecenterX -tab + mountingholelengthoffset ,mountingholecenteroffset],
    [-axlecenterX -tab + mountingholelengthoffset ,-mountingholecenteroffset,0],
    [totallength-axlecenterX -tab - mountingholelengthoffset,mountingholecenteroffset],
    [totallength-axlecenterX -tab - mountingholelengthoffset,-mountingholecenteroffset,0]
  ];
  
  // Move the axle to [0,0,0]
  translate([0,0,-operativeHeight(dimensions)]){
    if(cutout)
    {
      translate([0,0,height+socketheight]) cylinder(d = 2*width,h = 2*axleheight);
      translate([-axlecenterX -tab,-axlecenterY,taboffset]) cube([length+2*tab,width,totalheight - taboffset - axleheight]);
      translate([-axlecenterX,-axlecenterY,0]) cube([length,width,taboffset]);
      for(i = mountingholeoffsets)
        translate(i) cylinder(d=mountingscrewidth, h=totalheight - axleheight,$fn=10);

      translate([-powerportdimensions[0]-tab,-powerportdimensions[1]/2,powerportoffset]) cube(powerportdimensions);
    }
    
    if(holdblock)
    {
        difference(){
            translate([-tab-axlecenterX,-10,0]) cube([totallength,width,taboffset]);
            translate([-axlecenterX,-axlecenterY - sigma, - sigma]) cube([length,width + 2*sigma,taboffset+ 2*sigma]);
            for(i = mountingholeoffsets)
              translate(i) cylinder(d=mountingscrewidth, h=totalheight,$fn=10);
            translate([-powerportdimensions[0]-tab,-powerportdimensions[1]/2,powerportoffset]) cube(powerportdimensions);
        }
    }

    if(model) {
      color("blue") difference() {
        // body
        union() {
          translate([-axlecenterX,-axlecenterY,0]) cube([length,width,height]);
          // tab with holes
          difference() {
            translate([-axlecenterX -tab, -axlecenterY, taboffset]) cube([totallength,width,tabheight]);
            for(i = mountingholeoffsets){
              translate(i) cylinder(d=3, h=totalheight);
            }
          }
          // socket
          translate([0,0,height]) {
              translate([0,0,0]) cylinder(d=socketdiameter, h=socketheight);
          }
        };
      }
      // axle
      color("white") translate([0,0,height+socketheight]) {
        servoAxis(axlediameter, axleheight);
      }
    }
  }
}

// Draw the axis of the servo
// diameter: The outer diameter for the axis
// height: The legth of the axis protuding from the case
// teeth: number of teeth
// teethheight: height of each tooth
module servoAxis( diameter, height, teeth = 25, teethheight=0.5) {
  innerD = diameter - teethheight;
  rs = [diameter/2, innerD/2];
  a = 180/teeth;
  star = [for (i=[0:teeth-1],j=[0,1]) rs[j]*[cos(a*(2*i+j)),sin(a*(2*i+j))]];
  linear_extrude(height) polygon(points=star);
}
