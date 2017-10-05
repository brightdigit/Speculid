//
//  speculid_cpp.cpp
//  speculid-cpp
//
//  Created by Leo Dion on 9/27/17.
//  Copyright © 2017 Leo Dion. All rights reserved.
//

#include <iostream>
#include "speculid_cpp.hpp"
#include "speculid_cppPriv.hpp"

void speculid_cpp::HelloWorld(const char * s)
{
    speculid_cppPriv *theObj = new speculid_cppPriv;
    theObj->HelloWorldPriv(s);
    delete theObj;
};

void speculid_cppPriv::HelloWorldPriv(const char * s) 
{
    std::cout << s << std::endl;
};

