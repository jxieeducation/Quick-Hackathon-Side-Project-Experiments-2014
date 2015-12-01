#include <stdlib.h>
#include <Eigen/Core>
#include <Eigen/LU>
using namespace Eigen;
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


typedef Matrix<float, 12, 1> Matrixdr;
typedef Matrix<float, 3, 12> Matrixja;
typedef Matrix<float, 12, 3> Matrixjai;

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

class Segment {
public:
	Vector head;
	Vector tail;
	float length;
	Vector r;
	Vector endpoint;
	Matrix3f rm;
	Matrix3f rm2;
	Matrix3f jacob;
	Segment* prev;
	Segment* next;
	Matrix3f I;

	Segment(){}

	Segment(Vector h, Vector t, float l) {
		head = h;
		tail = t;
		length = l;
		r = Vector(1, 1, 1);
		endpoint = Vector(head.x - tail.x, head.y - tail.y, head.z - tail.z);
		rm << 0, -1*r.z, r.y, -1*r.z, 0, -1*r.x, r.y, -1*r.x, 0;
		rm2 << 0, pow(-1*r.z, 2), pow(r.y, 2), pow(-1*r.z, 2), 0, pow(-1*r.x, 2), pow(r.y,2), pow(-1*r.x, 2), 0;
		I << 1, 0, 0, 0, 1, 0, 0, 0, 1;
	}

	Segment(Vector h, Vector t, float l, Segment *p) {
		head = h;
		tail = t;
		length = l;
		r = Vector(1, 1, 1);
		endpoint = Vector(head.x - tail.x, head.y - tail.y, head.z - tail.z);
		rm << 0, -1*r.z, r.y, -1*r.z, 0, -1*r.x, r.y, -1*r.x, 0;
		rm2 << 0, pow(-1*r.z, 2), pow(r.y, 2), pow(-1*r.z, 2), 0, pow(-1*r.x, 2), pow(r.y,2), pow(-1*r.x, 2), 0;
		I << 1, 0, 0, 0, 1, 0, 0, 0, 1;
		prev = p;
		(*prev).next = this;
	}

	void print() {
		glBegin(GL_LINES);
		glLineWidth(2.5);
		glColor3f(1.0, 1.0, 1.0);
		glVertex3f(tail.x, tail.y, tail.z);
		//printf("my tail: %f, %f, %f\n", tail.x, tail.y, tail.z);
		glColor3f(1.0, 1.0, 1.0);
		glVertex3f(head.x, head.y, head.z);
		//printf("my head: %f, %f, %f\n", head.x, head.y, head.z); //-1.#IND00
		//printf("hi\n");
		glEnd();
	}

	void reset(float ox, float oy, float oz) {
		head.x = ox;
		head.y = oy;
		head.z = oz;
		return;
	}

	void testrotate() {
		Matrix3f cr = I + rm*cos(r.getMag()) + rm2*(1-sin(r.getMag()));
		Matrix4f crt;
		crt << cr(0,0), cr(0,1), cr(0,2), 0, cr(1,0), cr(1,1), cr(1,2), 0, cr(2,0), cr(2,1), cr(2,2), 0, 0, 0, 0, 1;
		Matrix4f TO;
		TO << 1, 0, 0, -1*tail.x, 0, 1, 0, -1*tail.y, 0, 0, 1, -1*tail.z, 0, 0, 0, 1;
		Vector4f hv(head.x, head.y, head.z, 1);
		hv = TO * hv;
		hv = crt * hv;
		hv = TO.inverse() * hv;
		head.x = hv(0, 0);
		head.y = hv(1, 0);
		head.z = hv(2, 0);
	}

	void rotate() {
		printf("r: %f, %f, %f\n", r.x, r.y, r.z);
		printf("rm: %f, %f, %f\n", rm(0,0), rm(0,1), rm(0,2));
		printf("rm: %f, %f, %f\n", rm(1,0), rm(1,1), rm(1,2));
		printf("rm: %f, %f, %f\n", rm(2,0), rm(2,1), rm(2,2));
		Matrix3f cr = I + (rm * (cos(r.getMag()))) + (rm2 * ((1-sin(r.getMag()))));
		printf("cr: %f, %f, %f\n", cr(0,0), cr(0,1), cr(0,2));
		printf("cr: %f, %f, %f\n", cr(1,0), cr(1,1), cr(1,2));
		printf("cr: %f, %f, %f\n", cr(2,0), cr(2,1), cr(2,2));
		Matrix4f crt;
		crt << cr(0,0), cr(0,1), cr(0,2), 0, cr(1,0), cr(1,1), cr(1,2), 0, cr(2,0), cr(2,1), cr(2,2), 0, 0, 0, 0, 1;
		printf("crt: %f, %f, %f, %f\n", crt(0,0), crt(0,1), crt(0,2), crt(0,3));
		printf("crt: %f, %f, %f, %f\n", crt(1,0), crt(1,1), crt(1,2), crt(1,3));
		printf("crt: %f, %f, %f, %f\n", crt(2,0), crt(2,1), crt(2,2), crt(2,3));
		printf("crt: %f, %f, %f, %f\n", crt(3,0), crt(3,1), crt(3,2), crt(3,3));
		Matrix4f TO;
		TO << 1, 0, 0, -1*tail.x, 0, 1, 0, -1*tail.y, 0, 0, 1, -1*tail.z, 0, 0, 0, 1;
		printf("head: %f, %f, %f\n", head.x, head.y, head.z);
		Vector4f hv(head.x, head.y, head.z, 1);
		printf("hv1: %f, %f, %f, %f\n", hv(0,0), hv(1,0), hv(2,0), hv(3,0));
		hv = TO * hv;
		printf("hv2: %f, %f, %f, %f\n", hv(0,0), hv(1,0), hv(2,0), hv(3,0));
		hv = crt * hv;
		printf("hv3: %f, %f, %f, %f\n", hv(0,0), hv(1,0), hv(2,0), hv(3,0));
		hv= TO.inverse() * hv;
		printf("hv4: %f, %f, %f, %f\n", hv(0,0), hv(1,0), hv(2,0), hv(3,0));
		head.x = hv(0, 0);
		head.y = hv(1, 0);
		head.z = hv(2, 0);
		printf("head: %f, %f, %f\n", head.x, head.y, head.z);
		Segment current = *this;
		int i = 1;
		while(current.next) {
			printf("current loop runs %i times\n", i++);
			Vector diff = current.head - (*current.next).tail;
			printf("prevhead: %f, %f, %f\n", current.head.x, current.head.y, current.head.z);
			printf("tail: %f, %f, %f\n", (*current.next).tail.x, (*current.next).tail.y, (*current.next).tail.z);
			printf("diff: %f, %f, %f\n", diff.x, diff.y, diff.z);
			(*current.next).tail.x = (*current.next).tail.x + diff.x;
			(*current.next).tail.y = (*current.next).tail.y + diff.y;
			(*current.next).tail.z = (*current.next).tail.z + diff.z;
			(*current.next).head.x = (*current.next).head.x + diff.x;
			(*current.next).head.y = (*current.next).head.y + diff.y;
			(*current.next).head.z = (*current.next).head.z + diff.z;
			current = *current.next;
		}
	}

	void setJacobian() {
		float orx = r.x, ory = r.y, orz = r.z;
		float ox = head.x, oy = head.y, oz = head.z;
		r.x = r.x + 1;
		testrotate();
		float xrx = head.x, yrx = head.y, zrx = head.z;
		r.x = orx;
		reset(ox, oy, oz);
		r.y = r.y + 1;
		testrotate();
		float xry = head.x, yry = head.y, zry = head.z;
		r.y = ory;
		reset(ox, oy, oz);
		r.z = r.z + 1;
		testrotate();
		float xrz = head.x, yrz = head.y, zrz = head.z;
		r.z = orz;
		reset(ox, oy, oz);
		jacob << (xrx - ox), (xry - ox), (xrz - ox), (yrx - oy), (yry - oy), (yrz - oy), (zrx - oz), (zry - oz), (zrz - oz);
		return;
	}

	Matrix3f RMatrix() {
		Matrix3f cr = I + rm*cos(r.getMag()) + rm2*(1-sin(r.getMag()));
		Matrix3f R = cr.inverse();
		return R;
	}

	void movef(Vector goal) {
		Vector move = goal - head;
		Vector pasthead = Vector(head.x, head.y, head.z);
		head = head + move;
		Vector side = ((pasthead - head).Vnor()).Vsca(.1);
		tail = Vector(head.x, head.y, head.z);
		for(int i = 0; i < 10*length; i++) {
			tail = tail + side;
		}
	}

	void moveb(Vector goal) {
		Vector move = goal - tail;
		Vector pasttail = Vector(tail.x, tail.y, tail.z);
		tail = tail + move;
		Vector side = ((pasttail - tail).Vnor()).Vsca(.1);
		head = Vector(tail.x, tail.y, tail.z);
		for(int i = 0; i < 10*length; i++) {
			head = head + side;
		}
	}
};

class Arm {
public:
	Segment* segments;
	Vector head;
	Segment root;

	Arm(){}

	Arm(Segment *one, Segment *two, Segment *three, Segment *four) {
		segments = ((Segment *) malloc(4*sizeof(Segment)));
		segments[0] = *one;
		segments[1] = *two;
		segments[2] = *three;
		segments[3] = *four;
		root = *one;
		head = (*four).head;
	}

	void print() {
		for(int i = 0; i < 4; i++) {
			segments[i].print();
		}
	}

	Matrixja getJacobian() {
		for(int i = 0; i < 4; i++) {
			segments[i].setJacobian();
		}
		Matrix3f J0 = segments[0].jacob;
		Matrix3f J1 = segments[1].jacob;
		Matrix3f J2 = segments[2].jacob;
		Matrix3f J3 = segments[3].jacob;
		Matrix3f R0 = segments[0].RMatrix();
		Matrix3f R1 = segments[1].RMatrix();
		Matrix3f R2 = segments[2].RMatrix();
		J1 = R0 * J1;
		J2 = R0 * R1 * J2;
		J3 = R0 * R1 * R2 * J3;
		Matrixja Jacob;
		Jacob << J0, J1, J2, J3;
		return Jacob;
	}

	void updaterotation(Matrixdr *dr) {
		for(int i = 0; i < 12; i=i+3) {
			printf("dr%i: %f, %f, %f\n", i, (*dr)(i,0), (*dr)(i+1,0), (*dr)(i+2,0));
		}
			segments[0].r.x = (*dr)(0, 0);
			segments[0].r.y = (*dr)(1, 0);
			segments[0].r.z = (*dr)(2, 0);
			Vector r = segments[0].r;
			segments[0].rm << 0, -1*r.z, r.y, -1*r.z, 0, -1*r.x, r.y, -1*r.x, 0;
			segments[0].rm2 << 0, pow(-1*r.z, 2), pow(r.y, 2), pow(-1*r.z, 2), 0, pow(-1*r.x, 2), pow(r.y,2), pow(-1*r.x, 2), 0;
			segments[1].r.x = (*dr)(3, 0);
			segments[1].r.y = (*dr)(4, 0);
			segments[1].r.z = (*dr)(5, 0);
			r = segments[1].r;
			segments[1].rm << 0, -1*r.z, r.y, -1*r.z, 0, -1*r.x, r.y, -1*r.x, 0;
			segments[1].rm2 << 0, pow(-1*r.z, 2), pow(r.y, 2), pow(-1*r.z, 2), 0, pow(-1*r.x, 2), pow(r.y,2), pow(-1*r.x, 2), 0;
			segments[2].r.x = (*dr)(6, 0);
			segments[2].r.y = (*dr)(7, 0);
			segments[2].r.z = (*dr)(8, 0);
			r = segments[2].r;
			segments[2].rm << 0, -1*r.z, r.y, -1*r.z, 0, -1*r.x, r.y, -1*r.x, 0;
			segments[2].rm2 << 0, pow(-1*r.z, 2), pow(r.y, 2), pow(-1*r.z, 2), 0, pow(-1*r.x, 2), pow(r.y,2), pow(-1*r.x, 2), 0;
			segments[3].r.x = (*dr)(9, 0);
			segments[3].r.y = (*dr)(10, 0);
			segments[3].r.z = (*dr)(11, 0);
			r = segments[3].r;
			segments[3].rm << 0, -1*r.z, r.y, -1*r.z, 0, -1*r.x, r.y, -1*r.x, 0;
			segments[3].rm2 << 0, pow(-1*r.z, 2), pow(r.y, 2), pow(-1*r.z, 2), 0, pow(-1*r.x, 2), pow(r.y,2), pow(-1*r.x, 2), 0;
	}

	void rotate() {
		for(int i = 0; i < 4; i++) {
			segments[i].rotate();
		}
		head = segments[3].head;
	}
};

void move(Arm *arm, Vector goal) {
	Vector point = (*arm).head;
	Vector dist = goal - point;
	float distance = (point - goal).getMag();
	float lastdistance = 1000000;
	while(lastdistance != distance && distance > 0.1) {
		Vector3f diff(dist.x, dist.y, dist.z);
		//diff << dist.x, 0, 0, dist.y, 0, 0, dist.z, 0, 0;
		float alpha = 0.01;
		Matrixja jacob = (*arm).getJacobian();
		for(int i = 0; i < 3; i++) {
			printf("jacob%i: %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f\n", i, jacob(i,0), jacob(i,1), jacob(i,2), jacob(i,3), jacob(i,4), jacob(i,5), jacob(i,6), jacob(i,7), jacob(i,8), jacob(i,9), jacob(i,10), jacob(i,11));
		}
		Matrixjai Ji = jacob.transpose() * (jacob * jacob.transpose()).inverse();
		for(int i = 0; i < 12; i++) {
			printf("ji%i: %f, %f, %f\n", i, Ji(i,0), Ji(i,1), Ji(i,2));
		}
		diff = alpha * diff;
		Matrixdr dr = Ji * diff;
		(*arm).updaterotation(&dr);
		(*arm).rotate();
		point = (*arm).head;
		lastdistance = distance;
		distance = (point - goal).getMag();
		dist = goal - point;
	}
	(*arm).print();
}

void testmove(Arm arm, Vector goal) { //REMASTERED!
	Vector point = goal;
	for(int i = 0; i <= 3; i++) {
		arm.segments[i].movef(point);
		point = arm.segments[i].tail;
	}
	point = Vector(0,0,0);
	for(int k = 3; k >= 0; k--) {
		arm.segments[k].moveb(point);
		point = arm.segments[k].head;
	}
	arm.print();
}