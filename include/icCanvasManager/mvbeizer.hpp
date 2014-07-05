#ifndef __ICCANVASMANAGER_MVBEIZER__H_
#define __ICCANVASMANAGER_MVBEIZER__H_

#include "../icCanvasManager.hpp"

#include <vector>
#include <stdexcept>

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
        typedef typename std::vector<__Polynomial>::size_type size_type;
        
        /* Beizer derivatives are lower-order. */
        typedef TMVBeizer<__Interpolated, _order - 1> derivative_type;
        
        /* Compute the derivative of the Beizer curve. */
        derivative_type derivative() {
            derivative_type out;
            
            for (int i = 0; i < this->_storage.size(); i++) {
                out.extend_spline();
                
                for (int j = 0; j < _order; j++) {
                    auto derivPt = out.get_point(i, j);
                    derivPt = (this->get_point(i, j+1) - this->get_point(i, j)) * _order;
                    out.set_point(i, j, derivPt);
                }
            }
            
            return out;
        };
        
        /* Interpolate the stored spline at point t.
         * 
         * Uses de Casteljau's algorithm (iterated lerps) to calculate points
         * on the curve. It's ridiculously easy to understand.
         * 
         * The whole-number portion of t specifies what spline section to use.
         * So, for example, in a three-section spline, the following three half
         * open ranges are defined as follows:
         * 
         *      [0.0, 1.0) - Spline segment 0
         *      [1.0, 2.0) - Spline segment 1
         *      [2.0, 3.0) - Spline segment 2
         * 
         * with all other possible spline ranges undefined (and most likely,
         * crashing the program).
         */
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
        
        auto count_points() -> decltype(this->_storage.size()) {
            return this->_storage.size();
        };

        void extend_spline() {
            this->_storage.emplace_back();
        };

        void contract_spline() {
            this->_storage.pop_back();
        };

        __Interpolated& get_point(const int splinept, const int polypt) {
            if (polypt <= _order) {
                __Polynomial& spl = this->_storage.at(splinept);
                return spl._pt[polypt];
            } else {
                throw std::out_of_range("icCanvasManager::TMVBeizer::get_point");
            }
        };

        void set_point(const int splinept, const int polypt, const __Interpolated& pt) {
            if (polypt <= _order) {
                __Polynomial& spl = this->_storage.at(splinept);
                spl._pt[polypt] = pt;
            }
        };
    };
};

#endif
