#ifndef __ICCANVASMANAGER_MVBEIZER__H_
#define __ICCANVASMANAGER_MVBEIZER__H_

#include "../icCanvasManager.hpp"

#include <vector>

namespace icCanvasManager {
    /* Spline polynomial interpolation between any lerpable type.
     * 
     *  Order 0: Constant polynomials.
     *  Order 1: Linear polynomials.
     *  Order 2: Quadratic polynomials.
     *  Order 3: Cubic polynomials (used for beizers)
     * 
     * A lerpable type is defined as any type with the following signatures:
     * 
     *  T& operation+ (T&);     //pairwise addition between like types
     *  T& operation- (T&);     //pairwise subtraction between like types
     *  T& operation* (float&); //scalar multiplication against floats
     */
    template <typename _interpolated, int order>
    class TMVBeizer {
        //Beizer storage
        typedef _interpolated _polynomial[order+1];
        std::vector<_polynomial> _storage;
        _interpolated _lerp(_interpolated pt1, float pos1, _interpolated pt2, float pos2, float pos) {
            return pt1 + (pt2 - pt1) * (pos - pos1) / (pos2 - pos1);
        }
    public:
        _interpolated evaluate_for_point(float t) {
            int polynomID = (int)t;
            
            _polynomial thePoly = this->_storage.get(polynomID);
            for (int i = order; i > 0; i--) {
                for (int j = 0; j < i; j++) {
                    thePoly[j] = _lerp(thePoly[j], polynomID, thePoly[j+1], polynomID+1, t);
                }
            }
            
            return thePoly[0];
        }
        
        void extend_to() {
            
        }
    };
};

#endif
