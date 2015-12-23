#include "stdafx.h"
#include <iostream>
#include "ErrorFactory.h"

// See ErrorFactory.h for more info

void error(string msg, int line)
{
	cout << "[Error] [line #" << line << "] " << msg << endl;
	throw;
}

void error(string msg)
{
	cout << "[Error] " << msg << endl;
	throw;
}