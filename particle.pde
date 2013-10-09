ParticleSystem g;

void setup() {
    size(1024, 768);
    frameRate(60);


    ps = new ParticleSystem(width/2, height/2, 200);
    ps.debug = true;
    stroke(255);
    fill(128);
}

void draw(){
    background(0);
    ps.update();
    ps.draw();
}

class ParticleSystem {
    float x, y, angle, spread;
    int genSpeed = 15, genCountdown = 1, pCount;
    boolean debug = false;
    Particle[] particles;

    ParticleSystem(xpos, ypos, sz) {
        this.y = ypos;
        this.x = xpos;
        particles = new Particle[sz];
        angle = 0;
        spread = PI / 6;
    }

    // Has to be called genCountdown times to generate
    void generate() {
        genCountdown--;
        if (genCountdown <= 0){
            genCountdown = genSpeed;

            Particle p = new Particle(x, y, random(angle - spread, angle + spread));

            int targetIndex = pCount % particles.length;
            particles[targetIndex] = p;
            pCount++
        }
    }

    void update() {
        generate();
        int limit = max(particles.length, pCount);
        for (int i = 0; i < limit; i++){
            if(particles[i]) particles[i].update();
        }
    }

    void draw() {
        if (debug) {
            // draw lines showing the angle spread and speed
            float lSize = width/genSpeed/2;
            float lowAngle = angle - spread;
            float highAngle = angle + spread;
            line(x, y, x + lSize * cos(lowAngle), y + lSize * sin(lowAngle));
            line(x, y, x + lSize * cos(highAngle), y + lSize * sin(highAngle));
        }

        int limit = max(particles.length, pCount);
        for (int i = 0; i < limit; i++){
            if(particles[i]) particles[i].draw();
        }
    }
}

class Particle {
    float x, y, life, direction,
        xSpeed, ySpeed;


    float speedScale = 2;
    Particle(x, y, direction){
        this.x = x;
        this.y = y;
        this.setDirection(direction);
    }

    void setDirection(direction) {
        xSpeed = cos(direction) * speedScale;
        ySpeed = sin(direction) * speedScale;
        this.direction = direction;
    }

    void update() {
        if (!isAlive()) return;

        x += xSpeed;
        y += ySpeed;
        life--;
    }

    void draw() {
        if (!isAlive()) return;

        pushMatrix();
        translate(x, y);
        rotate(direction - PI/2);
        triangle(-5, -5, 5, -5, 0, 10);
        popMatrix();
    }

    bool isAlive() {
        return life <= 0;
    }

}
