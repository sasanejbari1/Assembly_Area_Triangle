#include <iostream>
#include <iomanip> 

extern "C" double triangle();

int main(){
	std::cout <<"Welcome to CPSC 240 Assignment 4 brought to you by Sasan Ejbari" << std::endl << std::endl;
	double value = triangle();
	std::cout <<"Heron received this number: " << std::fixed  << std::setprecision(10) << value << std::endl;
	std::cout <<"Have a nice day. The program will return control to the operating system." << std::endl;
	return 0;
}