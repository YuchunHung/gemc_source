#ifndef ftm_strip_H
#define ftm_strip_H 1

// CLHEP units
#include "CLHEP/Units/PhysicalConstants.h"
using namespace CLHEP;

#include <vector>
#include <string>
using namespace std;

// gemc headers
#include "HitProcess.h"

// ftm constants
// these are loaded with initWithRunNumber
class ftmConstants
{
public:
    
    // runNo is mandatory variable to keep track of run number changes
    int runNo;
    string variation;
    string date;
    string connection;
    char   database[80];
    
    double sigma_0      ;  // transverse diffusion
    double w_i          ;  // ionization energy
    
    double rmin ;          // inner radius of disks
    double rmax ;          // outer radius of disks
    double pitch;          // strip pitch
    int    nstrips;        // number of strips per layer
	int    nb_sigma;       // To define the number of strips to look at around the closest one
    //	voltage signal parameters, using double gaussian + delay (function DGauss, need documentation for it)
    double vpar[4];
};


class ftm_strip
{
public:
    /*
	double pitch;
	double Pi;

	double interlayer;       // distance between 2 layers of a superlayer
	double intersuperlayer;  // distance between 2 superlayers
	double R_min;             // inner radius of disks
	double R_max;             // outer radius of disks
	double Z_1stlayer;       // z position of the 1st layer

	vector<double> Z0;       // z of the upstream part of the layer
	vector<double> R;        // radii of layers
	vector<double> MidTile;  // mid angle of the sector
	int N_str;             // Number of strips for 1 card
	int N_halfstr;             // Number of strips cut in the middle
	int N_sidestr;             // Number of strips on one side, running from negative to positive x (unlike the half strips)
	double y_central;        // Limit the central part for strip finding
	double xc,yc;            // Center of the Closest strip
	double hDrift;           // Size of the drift gap
	double hStrip2Det;       // distance between strips and the middle of the conversion gap (~half the drift gap)
	double sigma_td_max;     // maximum value of the transverse diffusion
	double sigma_td;         // current value of the transverse diffusion
	double w_i;              // mean ionization potential
	int Nel;                 // number of electrons (Nt) for a given hit
	double strip_x;          // strip_x is the middle of the strips X-coord
	double strip_y;          // strip_y is the position of the strips
	double strip_length;     // length of the strip
	double y_real; 		 // y position in the detector coordinate system
	double x_real;		 // x position in the detector coordinate system
	int nb_sigma;            // To define the number of strips to look at around the closest one
     */
//	void fill_infos();

	vector<double> FindStrip( int layer, double x, double y, double z, double Edep, detector Detector,ftmConstants ftmcc);   // Strip Finding Routine
    int    get_strip_ID(double x, double y,ftmConstants ftmcc);   // return strip number based on coordinate
    double get_strip_X(double x, double y,ftmConstants ftmcc);    // return strip x coordinate
    double get_strip_L(double x, double y,ftmConstants ftmcc);    // return strip length
//	void Carac_strip(int strip); //length and position of a strip
//	double Weight_td(double xs, double ys, double x, double y, double z,ftmConstants ftmcc); //Compute the fraction of Nel falling onto the strip, depending on x,y in the FMT coordinate system
};

#endif