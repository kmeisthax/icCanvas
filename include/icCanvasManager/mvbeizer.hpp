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
    template <typename __Interpolated, int _order>
    class TMVBeizer {
        //Beizer storage
        struct __Polynomial {
            __Interpolated _pt[_order+1];
        };
        std::vector<__Polynomial> _storage;

        __Interpolated _lerp(__Interpolated pt1, float pos1, __Interpolated pt2, float pos2, float pos) {
            return pt1 + (pt2 - pt1) * (pos - pos1) * (1 / (pos2 - pos1));
        }
    public:
        __Interpolated evaluate_for_point(float t) {
            int polynomID = (int)t;
            
            __Polynomial thePoly = this->_storage.at(polynomID);
            for (int i = _order; i > 0; i--) {
                for (int j = 0; j < i; j++) {
                    thePoly._pt[j] = _lerp(thePoly._pt[j], polynomID, thePoly._pt[j+1], polynomID+1, t);
                }
            }
            
            return thePoly._pt[0];
        }
        
        void extend_to() {
            
        }
    };
};

#endif
