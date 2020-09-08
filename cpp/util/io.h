//
// Created by peixinho on 7/25/20.
//

#ifndef CPP_IO_H
#define CPP_IO_H

#include <iostream>
#include <string_view>

namespace io {

    using namespace  std;

    template <class dtype>
    matrix<dtype> read_csv(const string filepath, const char delimiter = ',') {
        ifstream file ( "file.csv" );
        string line;
        string valuestr;
        dtype value;
        int row = 0, col = 0;
        while ( file.good() ) {
            col = 0;
            getline (file, line);
            stringstream linestream(line);
            while (linestream.good()) {
                getline(linestream, valuestr, delimiter);
                stringstream valuestream(value);
                valuestream >> value;
                ++col;
                cout << value << " ";
            }
            cout << endl;
            ++row;
        }
    }
}


#endif //CPP_IO_H
