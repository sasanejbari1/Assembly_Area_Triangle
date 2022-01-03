#include <iostream>
#include <iomanip> 

extern "C" void show_results(double a, double b, double c, double area){
	std::cout <<"The area of a triangle with sides " << std::fixed  << std::setprecision(10) << a << ", " << b << ", and " << c << " is " << area << " square units." << std::endl << std::endl;
}