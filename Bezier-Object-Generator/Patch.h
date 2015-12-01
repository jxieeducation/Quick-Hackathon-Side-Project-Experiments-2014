#include <stdlib.h>
#include <math.h>
#ifdef _WIN32
#include <windows.h>
#else
#include <sys/time.h>
#endif

#ifdef OSX
#include <GLUT/glut.h>
#include <OpenGL/glu.h>
#else
#include <GL/glut.h>
#include <GL/glu.h>
#endif

#include <time.h>
#include <math.h>

#ifdef _WIN32
static DWORD lastTime;
#else
static struct timeval lastTime;
#endif

int rendered = 0;
bool flagged = true;

class Vector
{
public:
	float x;
	float y;
	float z;

	Vector(float a = 0, float b = 0, float c = 0) {
		x = a;
		y = b;
		z = c;
	}

	float* getCoors() {
		float* result = (float *) malloc(3*sizeof(float));
		result[0] = x;
		result[1] = y;
		result[2] = z;
		return result;
	}

	Vector operator+(Vector other) {
		float* C = other.getCoors();
		Vector result = Vector(x + C[0], y + C[1], z + C[2]);
		free(C);
		return result;
	}

	Vector operator-(Vector other) {
		float* C = other.getCoors();
		Vector result = Vector(x - C[0], y - C[1], z - C[2]);
		free(C);
		return result;
	}

	Vector operator*(float scale) {
		return Vector(x*scale, y*scale, z*scale);

	}

	Vector operator*(Vector mul) {
		return Vector(x * mul.x, y * mul.y, z * mul.z);
	}

	Vector Vadd(Vector add) {
		float* C = add.getCoors();
		Vector result = Vector(x + C[0], y + C[1], z + C[2]);
		free(C);
		return result;
	}

	Vector Vsub(Vector sub) {
		float* C = sub.getCoors();
		Vector result = Vector(x - C[0], y - C[1], z - C[2]);
		free(C);
		return result;
	}

	Vector Vmul(Vector mul) {
		Vector result = Vector(x * mul.x, y * mul.y, z * mul.z);
		return result;
	}

	Vector Vsca(float scale) {
		Vector result = Vector(x * scale, y * scale, z * scale);
		return result;
	}

	Vector Vdiv(float scale) {
		Vector result = Vector(x / scale, y / scale, z / scale);
		return result;
	}

	Vector Vsqa() {
		Vector result = Vector(x * x, y * y, z * z);
		return result;
	}

	Vector Vsqr() {
		Vector result = Vector(sqrt(x), sqrt(y), sqrt(z));
		return result;
	}

	Vector Vnor() {
		float norm = sqrt(pow(x, 2) + pow(y,2) + pow(z,2));
		Vector result = Vector(x / norm, y / norm, z / norm);
		return result;
	}

	Vector Vcrs(Vector cross) {
		float* C = cross.getCoors();
		Vector result = Vector((y * C[2]) - (z * C[1]), (z * C[0]) - (x * C[2]), (x * C[1]) - (y * C[0]));
		free(C);
		return result;
	}

	float Vdot(Vector dot) {
		float* C = dot.getCoors();
		float result = (x * C[0]) + (y * C[1]) + (z * C[2]);
		free(C);
		return result;
	}

	float getDistance(Vector v) {
		float* C = v.getCoors();
		float result = (x - C[0]) * (x - C[0]) + (y - C[1])*(y - C[1])  + (z - C[2])*(z - C[2]);
		result = sqrt (result);
		free(C);
		return result;
	}

	float getMag() {
		return (float)sqrt(x*x + y*y + z*z);
	}
};

class Bezier {
public:
	Vector curve0, curve1, curve2, curve3;

	Bezier(){}

	Bezier(Vector zero, Vector one, Vector two, Vector three) {
		curve0 = zero;
		curve1 = one;
		curve2 = two;
		curve3 = three;
	}
};

class Patch
{
public:
	Vector** points;
	float threshold;

	Patch(){}

	Patch(Vector** point, float value) {
		points = point;
		threshold = value;
	}

	Patch(Vector one, Vector two, Vector three, Vector four, float value) {
		points = ((Vector **) malloc(4*sizeof(Vector*)));
		points[0] = ((Vector *) malloc(4*sizeof(Vector)));
		points[1] = ((Vector *) malloc(4*sizeof(Vector)));
		points[2] = ((Vector *) malloc(4*sizeof(Vector)));
		points[3] = ((Vector *) malloc(4*sizeof(Vector)));
		for(int i = 0; i < 4; i++) {
			for(int k = 0; k < 4; k++) {
				points[i][k] = Vector(0,0,0);
			}
		}
		points[0][0] = one;
		points[0][3] = two;
		points[3][0] = three;
		points[3][3] = four;
		threshold = value;
	}

	Patch(Bezier one, Bezier two, Bezier three, Bezier four, float value) {
		points = ((Vector **) malloc(4*sizeof(Vector*)));
		points[0] = ((Vector *) malloc(4*sizeof(Vector)));
		points[1] = ((Vector *) malloc(4*sizeof(Vector)));
		points[2] = ((Vector *) malloc(4*sizeof(Vector)));
		points[3] = ((Vector *) malloc(4*sizeof(Vector)));
		points[0][0] = one.curve0;
		points[0][1] = one.curve1;
		points[0][2] = one.curve2;
		points[0][3] = one.curve3;
		points[1][0] = two.curve0;
		points[1][1] = two.curve1;
		points[1][2] = two.curve2;
		points[1][3] = two.curve3;
		points[2][0] = three.curve0;
		points[2][1] = three.curve1;
		points[2][2] = three.curve2;
		points[2][3] = three.curve3;
		points[3][0] = four.curve0;
		points[3][1] = four.curve1;
		points[3][2] = four.curve2;
		points[3][3] = four.curve3;
		threshold = value;
	}
};

class Vertex {
public:
	Vector world;
	Vector parametric;
	Vector normal;

	Vertex() {}

	Vertex(Vector points, Vector coors, Vector norm) {
		world = points;
		parametric = coors;
		normal = norm;
	}

	Vertex(Vector points, float u, float v, Vector norm) {
		world = points;
		parametric = Vector(u, v, 0);
		normal = norm;
	}

	Vertex(float x, float y, float z, Vector coors, Vector norm) {
		world = Vector(x, y, z);
		parametric = coors;
		normal = norm;
	}

	Vertex(float x, float y, float z, float u, float v, Vector norm) {
		world = Vector(x, y, z);
		parametric = Vector(u, v, 0);
		normal = norm;
	}
};

class Triangle {
public:
	Vertex v1;
	Vertex v2;
	Vertex v3;
	Patch p;

	Triangle() {}

	Triangle(Vertex one, Vertex two, Vertex three, Patch patch) {
		v1 = one;
		v2 = two;
		v3 = three;
		p = patch;
	}
};

Vector* bezcurveinterp(Bezier curve, float u) {
	Vector* result = ((Vector *) malloc(2*sizeof(Vector)));
	Vector A = (curve.curve0 * (1.0-u)) + (curve.curve1 * (u));
	Vector B = (curve.curve1 * (1.0-u)) + (curve.curve2 * (u));
	Vector C = (curve.curve2 * (1.0-u)) + (curve.curve3 * (u));
	Vector D = (A * (1.0-u)) + (B * u);
	Vector E = (B * (1.0-u)) + (C * u);
	result[0] = (D * (1.0-u)) + (E * u);
	result[1] = (E - D).Vsca(3).Vnor();
	return result;
}

Vector* bezpatchinterp (Patch patch, float u, float v) {
	Vector* result = ((Vector *) malloc(2*sizeof(Vector)));
	/*printf("Points:\n");
	printf("%f, %f, %f ", patch.points[0][0].x, patch.points[0][0].y, patch.points[0][0].z);
	printf("%f, %f, %f ", patch.points[0][1].x, patch.points[0][1].y, patch.points[0][1].z);
	printf("%f, %f, %f ", patch.points[0][2].x, patch.points[0][2].y, patch.points[0][2].z);
	printf("%f, %f %f\n", patch.points[0][3].x, patch.points[0][3].y, patch.points[0][3].z);
	printf("%f, %f, %f ", patch.points[1][0].x, patch.points[1][0].y, patch.points[1][0].z);
	printf("%f, %f, %f ", patch.points[1][1].x, patch.points[1][1].y, patch.points[1][1].z);
	printf("%f, %f, %f ", patch.points[1][2].x, patch.points[1][2].y, patch.points[1][2].z);
	printf("%f, %f %f\n", patch.points[1][3].x, patch.points[1][3].y, patch.points[1][3].z);
	printf("%f, %f, %f ", patch.points[2][0].x, patch.points[2][0].y, patch.points[2][0].z);
	printf("%f, %f, %f ", patch.points[2][1].x, patch.points[2][1].y, patch.points[2][1].z);
	printf("%f, %f, %f ", patch.points[2][2].x, patch.points[2][2].y, patch.points[2][2].z);
	printf("%f, %f %f\n", patch.points[2][3].x, patch.points[2][3].y, patch.points[2][3].z);
	printf("%f, %f, %f ", patch.points[3][0].x, patch.points[3][0].y, patch.points[3][0].z);
	printf("%f, %f, %f ", patch.points[3][1].x, patch.points[3][1].y, patch.points[3][1].z);
	printf("%f, %f, %f ", patch.points[3][2].x, patch.points[3][2].y, patch.points[3][2].z);
	printf("%f, %f %f\n", patch.points[3][3].x, patch.points[3][3].y, patch.points[3][3].z);*/
	Bezier curve0 = Bezier(patch.points[0][0], patch.points[0][1], patch.points[0][2], patch.points[0][3]);
	Bezier curve1 = Bezier(patch.points[1][0], patch.points[1][1], patch.points[1][2], patch.points[1][3]);
	Bezier curve2 = Bezier(patch.points[2][0], patch.points[2][1], patch.points[2][2], patch.points[2][3]);
	Bezier curve3 = Bezier(patch.points[3][0], patch.points[3][1], patch.points[3][2], patch.points[3][3]);
	Vector* v0 = bezcurveinterp(curve0, u);
	Vector* v1 = bezcurveinterp(curve1, u);
	Vector* v2 = bezcurveinterp(curve2, u);
	Vector* v3 = bezcurveinterp(curve3, u);
	Bezier vcurve = Bezier(v0[0], v1[0], v2[0], v3[0]);
	Bezier curve4 = Bezier(patch.points[0][0], patch.points[1][0], patch.points[2][0], patch.points[3][0]);
	Bezier curve5 = Bezier(patch.points[0][1], patch.points[1][1], patch.points[2][1], patch.points[3][1]);
	Bezier curve6 = Bezier(patch.points[0][2], patch.points[1][2], patch.points[2][2], patch.points[3][2]);
	Bezier curve7 = Bezier(patch.points[0][3], patch.points[1][3], patch.points[2][3], patch.points[3][3]);
	Vector* u0 = bezcurveinterp(curve4, v);
	Vector* u1 = bezcurveinterp(curve5, v);
	Vector* u2 = bezcurveinterp(curve6, v);
	Vector* u3 = bezcurveinterp(curve7, v);
	Bezier ucurve = Bezier(u0[0], u1[0], u2[0], u3[0]);
	Vector* dv = bezcurveinterp(vcurve, v);
	Vector* du = bezcurveinterp(ucurve, u);
	Vector n = (dv[1].Vcrs(du[1])).Vnor();
	result[0] = dv[0]; // == du[0]?
	result[1] = n;
	free(v0);
	free(v1);
	free(v2);
	free(v3);
	free(u0);
	free(u1);
	free(u2);
	free(u3);
	free(dv);
	free(du);
	return result;
}

void render(Vector one, Vector two, Vector three, Vector four,
	Vector none, Vector ntwo, Vector nthree, Vector nfour
	) {

	//rendered++;
	glBegin(GL_QUADS);
	//printf("Rendered: %i\n", rendered);
	glColor3f(1.0f, 0.0f, 0.0f);
	glNormal3f(none.x, none.y, none.z);
	glVertex3f(one.x, one.y, one.z);
	//printf("one: %f, %f, %f\n", one.x, one.y, one.z);
	glColor3f(1.0f, 0.0f, 0.0f);
	glNormal3f(ntwo.x, ntwo.y, ntwo.z);
	glVertex3f(two.x, two.y, two.z);
	//printf("two: %f, %f, %f\n", two.x, two.y, two.z);
	glColor3f(1.0f, 0.0f, 0.0f);
	glNormal3f(nthree.x, nthree.y, nthree.z);
	glVertex3f(three.x, three.y, three.z);
	//printf("three: %f, %f, %f\n", three.x, three.y, three.z);
	glColor3f(1.0f, 0.0f, 0.0f);
	glNormal3f(nfour.x, nfour.y, nfour.z);
	glVertex3f(four.x, four.y, four.z);
	//printf("four: %f, %f, %f\n", four.x, four.y, four.z);
	glEnd();
}

void subdividepatch(Patch patch, float step) {
	float numdiv = (1.01 / step) + 1;
	float u = 0, v = 0;
	int div = numdiv;
	Vector** grid = ((Vector **) malloc(div*sizeof(Vector *)));
	Vector** normal = ((Vector **) malloc(div*sizeof(Vector *)));
	for(int i = 0; i < div; i++) {
		grid[i] = ((Vector *) malloc(div*sizeof(Vector)));
		normal[i] = ((Vector *) malloc(div*sizeof(Vector)));
	}
	for(int iu = 0; iu < div; iu++) {
		u = iu * step;
		for(int iv = 0; iv < div; iv++) {
			v = iv * step;
			Vector* next = bezpatchinterp(patch, u, v);
			grid[iu][iv] = next[0];
			normal[iu][iv] = next[1];
		}
	}
	for(int x = 0; x < div-1; x++) {
		for(int k = 0; k < div-1; k++) {
			render(grid[x][k], grid[x][k+1], grid[x+1][k+1], grid[x+1][k],
				normal[x][k], normal[x][k+1], normal[x+1][k+1], normal[x+1][k]
				);
		}
	}
	for(int i = 0; i < div; i++) {
		free(grid[i]);
		free(normal[i]);
	}
	free(normal);
	free(grid);
	return;
}

void render(Triangle t) {
	glBegin(GL_TRIANGLES);
	glColor3f(1.0f, 0.0f, 0.0f);
	//glNormal3f(t.v1.normal.x, t.v1.normal.y,t.v1.normal.z);
	glVertex3f(t.v1.world.x, t.v1.world.y, t.v1.world.z);
	glColor3f(0.0f, 1.0f, 0.0f);
	//glNormal3f(t.v2.normal.x, t.v2.normal.y,t.v2.normal.z);
	glVertex3f(t.v2.world.x, t.v2.world.y, t.v2.world.z);
	glColor3f(0.0f, 0.0f, 1.0f);
	//glNormal3f(t.v3.normal.x, t.v3.normal.y,t.v3.normal.z);
	glVertex3f(t.v3.world.x, t.v3.world.y, t.v3.world.z);
	glEnd();
}

bool test_edge(Vertex v1, Vertex v2, Vertex* v12, Patch p) {
	float two = 2;
	/*float dot = (v1.normal).Vdot(v2.normal);
	printf("dot: %f\n", dot);
	printf("threshold: %f\n", p.threshold);
	if(dot <= p.threshold || dot <= 0.0001) {
		return true;
	}
	Vector midparametric = ((v1.parametric + v2.parametric).Vdiv(two));
	Vector midworld = ((v1.world + v2.world).Vdiv(two));
	Vector midnormal = ((v1.normal + v2.normal).Vdiv(two));
	v12[0] = Vertex(midworld, midparametric, midnormal);
	return false;*/
	Vector midparametric = ((v1.parametric + v2.parametric).Vdiv(two));
	Vector midworld = ((v1.world + v2.world).Vdiv(two));
	Vector* world = bezpatchinterp(p, midparametric.x, midparametric.y);
	//printf("world: %f, %f, %f\n", world[0].x, world[0].y, world[0].z);
	float dist = world[0].getDistance(midworld);
	//printf("dist: %f\n", dist);
	//printf("threshold: %f\n", p.threshold);
	if(dist > p.threshold) {
		v12[0] = Vertex(world[0], midparametric, world[1]);
		free(world);
		return false;
	}
	return true;
}

void subdivide(Triangle t) {
	Vertex* v12 = ((Vertex *) malloc(sizeof(Vertex)));
	Vertex* v23 = ((Vertex *) malloc(sizeof(Vertex)));
	Vertex* v13 = ((Vertex *) malloc(sizeof(Vertex)));
	//printf("triangle %f, %f, %f | %f, %f, %f | %f, %f, %f\n", t.v1.world.x, t.v1.world.y, t.v1.world.z, t.v2.world.x, t.v2.world.y, t.v2.world.z, t.v3.world.x, t.v3.world.y, t.v3.world.z);
	bool e1 = test_edge(t.v1, t.v2, v12, t.p);
	bool e2 = test_edge(t.v1, t.v3, v13, t.p);
	bool e3 = test_edge(t.v2, t.v3, v23, t.p);
	Vertex onetwo = v12[0];
	Vertex twothree = v23[0];
	Vertex onethree = v13[0];
	free(v12);
	free(v23);
	free(v13);
	if(e1 && e2 && e3) {
		render(t);
	}
	else if(!e1 && e2 && e3) {
		subdivide(Triangle(t.v1, onetwo, t.v3, t.p));
		subdivide(Triangle(onetwo, t.v2, t.v3, t.p));
	}
	else if(e1 && !e2 && e3) {
		subdivide(Triangle(t.v1, t.v2, onethree, t.p));
		subdivide(Triangle(onethree, t.v2, t.v3, t.p));
	}
	else if(e1 && e2 && !e3) {
		subdivide(Triangle(t.v1, t.v2, twothree, t.p));
		subdivide(Triangle(t.v1, twothree, t.v3, t.p));
	}
	else if(!e1 && !e2 && e3) {
		subdivide(Triangle(t.v1, onetwo, onethree, t.p));
		subdivide(Triangle(onetwo, t.v2, onethree, t.p));
		subdivide(Triangle(onethree, t.v2, t.v3, t.p));
	}
	else if(e1 && !e2 && !e3) {
		subdivide(Triangle(t.v1, t.v2, twothree, t.p));
		subdivide(Triangle(t.v1, twothree, onethree, t.p));
		subdivide(Triangle(onethree, twothree, t.v3, t.p));
	}
	else if(!e1 && e2 && !e3) {
		subdivide(Triangle(t.v1, onetwo, t.v3, t.p));
		subdivide(Triangle(onetwo, t.v2, twothree, t.p));
		subdivide(Triangle(onetwo, twothree, t.v3, t.p));
	}
	else if(!e1 && !e2 && !e3) {
		subdivide(Triangle(t.v1, onetwo, onethree, t.p));
		subdivide(Triangle(onetwo, twothree, onethree, t.p));
		subdivide(Triangle(onetwo, t.v2, twothree, t.p));
		subdivide(Triangle(onethree, twothree, t.v3, t.p));
	}
	return;
}

void tesselate (Patch patch, bool type) {
		if(type) {
			Vector* v1 = bezcurveinterp(Bezier(patch.points[0][0], patch.points[0][1], patch.points[0][2], patch.points[0][3]), 0);
			Vector* v2 = bezcurveinterp(Bezier(patch.points[0][0], patch.points[0][1], patch.points[0][2], patch.points[0][3]), 1);
			Vector* v3 = bezcurveinterp(Bezier(patch.points[3][0], patch.points[3][1], patch.points[3][2], patch.points[3][3]), 0);
			Vector* v4 = bezcurveinterp(Bezier(patch.points[3][0], patch.points[3][1], patch.points[3][2], patch.points[3][3]), 1);
			Vertex one = Vertex(v1[0], 0, 0, v1[1]);
			Vertex two = Vertex(v2[0], 0, 1, v2[1]);
			Vertex three = Vertex(v3[0], 1, 0, v3[1]);
			Vertex four = Vertex(v4[0], 1, 1, v4[1]);
			Triangle first = Triangle(two, one, three, patch);
			Triangle second = Triangle(two, four, three, patch);
			subdivide(first);
			subdivide(second);
			free(v1);
			free(v2);
			free(v3);
			free(v4);
		} else {
			subdividepatch(patch, patch.threshold);
		}
		return;
	}