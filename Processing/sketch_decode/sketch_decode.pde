import java.text.DecimalFormat;

ArrayList<String> headings = new ArrayList<String>(); // column headings
ArrayList<ArrayList<Integer>> data = new ArrayList<ArrayList<Integer>>(); // all spike data
boolean stateChange = true;

boolean animateFixedTime = false;

int iterations = 0;  // track number of times through loop to control timing of animation
int startCell = 1;  // activity of 3 consecutive cells = {x,y,z}, starting at this cell #
int shift = 0;      // moves animation along the x-axis
int graphTime = 1;   // if animating single time, but changing cells, set time here

int cellCount = 0;

void setup() {  
  // read the csv files that has all spike data (created in Matlab)
  String allData[] = loadStrings("allSpikes.txt");  // looks inside "data" folder

  // takes a bit of time to load data, so this gives option to not load
  if (true) {

    // parse each line and save them into hash maps
    for (int row = 1; row < allData.length; row++) {
      //  for (int row = 3; row < 10; row++) { // optional smaller dataset for debug
      String[] timepointString = split(allData[row], ",");
      //println( timepointString );

      // convert string to integer and add to timepoint
      ArrayList<Integer> timepoint = new ArrayList<Integer>();
      for (int col = 0; col < timepointString.length; col++) {
        int point = int(timepointString[col].trim());
        //println( timepointString[col] + ' ' + point );
        timepoint.add(point);
      }
      //println( timepoint.size() );
      data.add(timepoint);
    }
  }
  cellCount = data.get(0).size() - 2;
  println( data.size() );
  // set the application properties 
  size(640, 480, P3D);
  frameRate(10); // default is 30: 30 frames per second
}
void draw() {

  iterations++;

  // Gives option of slowing down animation and shifting along x-axis
  if ( 0 == ( iterations % 2 )) {
    //println(iterations);
    stateChange = true;
    if (animateFixedTime) startCell++;
    if ( (startCell+3) > cellCount ) {
      stateChange = false;
    }
    shift = shift + 5;
    if (!animateFixedTime) graphTime++;
  }

  // if something has changed ...
  if (stateChange) {
    background(200);  // set background - clear screen

    pushMatrix();
    translate(0, height/2, 0);
    translate(10, 10, 10);
    makeAxes();

    textSize(12); 
    fill(0); 
    textAlign(CENTER, CENTER);
    text("Graphing", width/2, height/2-50);

    for (int row = 0; row < data.size(); row++ ) {
      //  for (int row = 0; row < 50 ; row=row+10 ) {
      ArrayList<Integer> datapoint = data.get(row);
      Integer cueType = datapoint.get(0);
      Integer time = datapoint.get(1);
      Integer cell1 = datapoint.get(2+startCell);
      Integer cell2 = datapoint.get(2+startCell+1);
      Integer cell3 = datapoint.get(2+startCell+2);
      //print(datapoint);
      if ( time == graphTime ) {
        if (( cell1 > 0 ) || ( cell2 > 0) || (cell3 > 0)) {
          if (animateFixedTime) {
            if ( cueType == 1 ) {
              plotCueA( time*8, cell1*20, -cell2*20 );
            } else {
              plotCueB( time*8, -cell1*20, -cell2*20 );
            }
          } else {
            if ( cueType == 1 ) {
              plotCueA( cell1*20+shift, -cell2*20, cell3*20 );
            } else {
              plotCueB( cell1*20+shift, cell2*20, cell3*20 );
            }
          }
        } // ends cell1 > 0 ...
      } // end if time == graphTime ...
    } // ends for row ...
    popMatrix();
    stateChange = false;
  }
}

void makeAxes() {
  stroke(0);
  line(0, 0, width, 0);
  line(0, -height/2, 0, height/2);
  pushMatrix();
  rotateX(PI);
  line(0, 0, 0, height);
  popMatrix();
}

void makePlane() {
  for ( int x = 0; x < width; x = x+50 ) {
    line(x, 0, x, height);
  }
  for ( int y = 0; y < height; y = y+50 ) {
    line(0, y, width, y);
  }
}

void makeGrid() {
  stroke(125);  
  for ( int z = 0; z < 100; z = z+50 ) {
    pushMatrix();
    translate(0, 0, z);
    makePlane();
    popMatrix();
  }
}

void plotCueA(int x, int y, int z) {
  pushMatrix();
  translate(x, y, z);
  //rotateY(PI/4);
  stroke(255);
  fill(40, 230, 52);
  ellipse(0, 0, 5, 5);
  popMatrix();
}

void plotCueB(int x, int y, int z) {
  pushMatrix();
  translate(x, y, z);
  //rotateY(PI/4);
  stroke(255);
  fill(188, 29, 206);
  rect(0, 0, 5, 5);
  popMatrix();
}

void plotMarker(int x, int y, int z) {
  pushMatrix();
  translate(x, y, z);
  stroke(#9ECE08);
  fill(#9ECE08);
  sphere(5);
  popMatrix();
}