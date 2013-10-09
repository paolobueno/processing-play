int[] position = new int[2];
float[] speed = new float[2];
float[] accel = new float[2];
int diameter = 40;
float dampness = 0.005;
float sc = 0.004;

void move () {
    position[0] += speed[0];
    position[1] += speed[1];
}

void damp () {
    speed[0] *= 1 - dampness;
    speed[1] *= 1 - dampness;
}

void accelerate () {
    speed[0] += accel[0];
    speed[1] += accel[1];
}

void track (targetX, targetY) {
    // accelerate towards target
    // magnitude depends on distance
    float dx = targetX - position[0];
    float dy = targetY - position[1];

    float distance = dist(position[0], position[1], targetX, targetY);
    float direction = atan2(dy, dx);
    accel[0] = cos(direction) * sc * distance;
    accel[1] = sin(direction) * sc * distance;
}

void bump () {
    // check if ball bumps against edges
    // north & south
    if (position[0] - diameter <= 0 || position[0] + diameter >= width){
        speed[0] *= -1
    }
    if (position[1] - diameter <= 0 || position[1] + diameter >= height){
        speed[1] *= -1
    }
}

void update () {
    damp();
    accelerate();
    move();
    bump();
}


void setup() {
    size(1600,1200);

    position[0] = width/2;
    position[1] = height/2;

    speed[0] = 2;
    speed[1] = 2;

    accel[0] = 0;
    accel[1] = 0;

    smooth();

    frameRate(60);
    colorMode(HSB, 240);
    stroke(200, 150);
}

void draw() {
    background(0);

    float speedMag = sqrt(sq(speed[0]) + sq(speed[1]^2));

    diameter = 30 + speedMag;

    fill(160 + speedMag * 3, 240, 200);


    ellipse(position[0], position[1], diameter, diameter);
    if (mousePressed) {
        track(mouseX, mouseY);
        line(position[0], position[1], mouseX, mouseY);
    } else {
        accel[0] = 0;
        accel[1] = 0;
    }
    update();
}