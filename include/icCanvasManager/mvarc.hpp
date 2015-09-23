#ifndef __ICCANVASMANAGER_MVBEIZER__H_
#define __ICCANVASMANAGER_MVBEIZER__H_

#include "../icCanvasManager.hpp"

#include <vector>
#include <stdexcept>

namespace icCanvasManager {
    namespace GL {
        class Renderer;
    }

    namespace Cairo {
        class Renderer;
    }

    /* Circular arc interpolation between any lerpable type.
     *
     * Every section of curve is defined by three points of which a circle
     * is then fit through. Each point may have additional attributes, which
     * are interpolated as a cubic polynomial spline.
     *
     * (The use of a quadratic polynomial for attributes is to avoid having
     * to generalize circular arcs to arbitrary numbers of dimensions.)
     *
     * Internally, each control point is stored as _x, _y, and _attr members.
     * _x and _y are __Position types and _attr is an __Attribute type.
     *
     * __Attribute must be a lerpable type, which means that we must be able to
     * perform certain operations that behave like numbers do. In practice,
     * __Attribute will most likely be a struct of numerical types with
     * componentwise operations.
     *
     * A lerpable type is defined as any type with the following signatures:
     *
     *  T& operation+ (T&);     //pairwise addition between like types
     *  T& operation- (T&);     //pairwise subtraction between like types
     *  T& operation* (float&); //scalar multiplication against floats
     */
    template <typename __Position, typename __Attribute, typename __CircleFloat = double>
    class TMVArc {
    public:
        struct __Interpolated {
            __Position _x;
            __Position _y;
            __Attribute _attr;
        }
    private:
        //Beizer storage
        struct __Arc {
            __Position _x[3];
            __Position _y[3];
            __Attribute _attr[3];

            bool isCircular;
            __CircleFloat xCtr, yCtr, cRad;
        };
        std::vector<__Arc> _storage;

        __Interpolated _lerp(__Interpolated pt1, float pos1, __Interpolated pt2, float pos2, float pos) {
            return pt1 + (pt2 - pt1) * (pos - pos1) * (1 / (pos2 - pos1));
        }

        void update_segment(int segment) {
            __Arc &thePoly = this->_storage.at(segment);

            //Evaluate position
            float slope1, slope2, xCtr, yCtr, cRad;

            slope1 = (thePoly._y[1] - thePoly._y[0]) / (thePoly._x[1] - thePoly._x[0]);
            slope2 = (thePoly._y[2] - thePoly._y[1]) / (thePoly._x[2] - thePoly._x[1]);

            //Cases where there is no slope for each implied line segment, or
            //where the slope is zero (e.g. identical points) will be treated
            //as a regular line.
            if (slope1 == slope2 || slope1 == 0.0 || slope2 == 0.0) {
                thePoly.isCircular = false;
            } else {
                //Valid circle path
                thePoly.isCircular = true;

                xCtr = (slope1 * slope2 * (thePoly._y[2] - thePoly._y[0]) + slope1 * (thePoly._x[1] + thePoly._x[2]) - slope2 * (thePoly._x[0] + thePoly._x[1])) / (2 * (slope1 - slope2));
                yCtr = (thePoly._y[0] + thePoly._y[1]) / 2 - (xCtr - (thePoly._x[0] + thePoly._x[1]) / 2) / slope1;
                cRad = pow((pow((thePoly._x[1] - xCtr), 2) +
                            pow((thePoly._y[1] - yCtr), 2)), 0.5);
            }

            thePoly.xCtr = xCtr;
            thePoly.yCtr = yCtr;
            thePoly.cRad = cRad;
        }
    public:
        typedef typename std::vector<__Arc>::size_type size_type;

        /* Beizer derivatives are lower-order. */
        typedef TMVBeizer<__Interpolated, 1> derivative_type;

        /* Compute the derivative of the curve.
         * TODO: Figure out derivative for the arc spline bit
         */
        derivative_type derivative() {
            derivative_type out;

            for (int i = 0; i < this->_storage.size(); i++) {
                out.extend_spline();

                for (int j = 0; j < 2; j++) { //2 = quadratic polynom.
                    auto derivPt = out.get_point(i, j);
                    derivPt = (this->get_point(i, j+1) - this->get_point(i, j)) * _order;
                    out.set_point(i, j, derivPt);
                }
            }

            return out;
        };

        /* Interpolate the stored spline at point t.
         *
         * For positions, we compute the circle intersecting the three points
         * of the curve position, and then map the t values [x, x+1) to the
         * range [y, z), where y and z are the angles corresponding to the
         * beginning and ending points in polar coordinates around the implicit
         * center point of the circle.
         *
         * For attributes, we treat the three attribute points as a quadratic
         * polynomial and use de Casteljau's algorithm (iterated lerps) to
         * calculate points on the curve.
         *
         * The range of T is 0 to the number of segments present on the curve.
         * e.g. for a 3-segment curve, T is valid for the half-open range [0.0,
         * 3.0). Points equal to or greater than 3.0 will extrapolate the final
         * segment of the curve.
         *
         * As TMVArc is a spline curve, use segment to specify what spline
         * segment to use. Otherwise, it will be selected by rounding down T.
         * The segment parameter can be useful for non-continuous curves, e.g.
         * to sample off one side or the other of a discontinuity. It can also
         * be used to extrapolate an individual curve segment.
         */
        __Interpolated evaluate_for_point(float t, int segment = -1) {
            if (segment == -1) segment = (int)t;

            __Arc thePoly = this->_storage.at(segment);

            //Evaluate attributes
            for (int i = 2; i > 0; i--) { //2 = quadratic polynomial
                for (int j = 0; j < i; j++) {
                    thePoly._attr[j] = _lerp(thePoly._attr[j], segment, thePoly._attr[j+1], segment+1, t);
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
            if (polypt <= 2) { //2 = quadratic polynom
                __Arc& spl = this->_storage.at(splinept);
                return spl._pt[polypt];
            } else {
                throw std::out_of_range("icCanvasManager::TMVBeizer::get_point");
            }
        };

        void set_point(const int splinept, const int polypt, const __Interpolated& pt) {
            if (polypt <= 2) { //2 = quadratic polynom
                __Arc& spl = this->_storage.at(splinept);
                spl._pt[polypt] = pt;
            }

            this->update_segment(splinept);
        };

        friend class Renderer;
        friend class Cairo::Renderer;
        friend class GL::Renderer;
    };
};

#endif
