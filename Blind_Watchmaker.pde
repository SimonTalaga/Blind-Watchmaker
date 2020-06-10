/* Blind Watchmaker 
----------------------------- */

// CONSTANTS
int N = 4;
int MAX_LEVEL = 10;
int PROGENY = N * N;

// GENES ARRAYS
int G_Branching[] = new int[PROGENY];
float G_Height[] = new float[PROGENY];
float G_Angles[][] = new float[PROGENY][MAX_LEVEL];
float G_ShrinkFactor[][] = new float[PROGENY][MAX_LEVEL];

void initGenes() {
  G_Branching[0] = (int) random(3) + 2;
  G_Height[0] = height / N / 6;
  
  for(int i = 0; i < MAX_LEVEL; i++) {
    G_Angles[0][i] = random(64) * PI / 64;
    G_ShrinkFactor[0][i] = map(random(100), 0, 100, 0.5, 1.5);
  }
}

void reproduction() {
  int sign = random(2) < 1 ? -1 : 1;
  
  for(int i = 1; i < PROGENY; i++) {
    G_Branching[i] = G_Branching[0];
    G_Height[i] = G_Height[0];
    G_Angles[i] = G_Angles[0].clone();
    G_ShrinkFactor[i] = G_ShrinkFactor[0].clone();
    
    for(int j = 1; j < MAX_LEVEL; j++) {
      if(random(10) < 3.3)
        G_Angles[i][j] += sign * PI / 64; 
    }
    
    for(int j = 1; j < MAX_LEVEL; j++) {
     if(random(10) < 3.3)
        G_ShrinkFactor[i][j] += sign * 0.25; 
    }
    
    if(random(10) < 3.3)
      G_Branching[i] = max(1, min(G_Branching[i] + sign * 1, 14));
  }
}

void biomorph(int ox, int oy, int num, int iteration) {
  pushMatrix();
    translate(ox, oy);
    line(0, 0, 0, -G_Height[num] * G_ShrinkFactor[num][G_Branching[num] - iteration]);
    translate(0, -G_Height[num] * G_ShrinkFactor[num][G_Branching[num] - iteration]);
    
    iteration--;
    if(iteration > 0 & G_Branching[num] < MAX_LEVEL) {
      pushMatrix();
        rotate(G_Angles[num][G_Branching[num] - iteration]);
        biomorph(0, 0, num, iteration);
      popMatrix();
    
      pushMatrix();
        rotate(-G_Angles[num][G_Branching[num] - iteration]);
        biomorph(0, 0, num, iteration);
      popMatrix();
    }
  popMatrix();
}

void setup() {
  size(1000, 1000);
  background(255);
  initGenes();
  reproduction();
}

void draw() {
  strokeWeight(3);
  int tileSize = width / N;
  // Draws the Grid
  for(int i = tileSize; i < width; i += tileSize) {
    line(0, i, width, i);
    line(i, 0, i, height);
  }  
  
  strokeWeight(1);
  translate(tileSize / 2, tileSize);
  // Draws progeny
  for(int i = 0; i < PROGENY; i++) {
    if(i == 0)
      stroke(255, 0, 0);
    else
      stroke(0);
      
    biomorph(i * tileSize % width, i * tileSize / height * tileSize, i, G_Branching[i]); 
  }
}

void mousePressed() {
  int x = mouseX / (width / N);
  int y = mouseY / (height / N);

  int newParent = y * N + x;
  
  G_Branching[0] = G_Branching[newParent];
  G_Height[0] = G_Height[newParent];
  G_Angles[0] = G_Angles[newParent].clone();
  G_ShrinkFactor[0] = G_ShrinkFactor[newParent].clone();
  
  reproduction();
  background(255);
}