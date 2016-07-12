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
     *
     * TODO: Remove __CircleFloat, make operations internally fixed-point
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
            __Interpolated _i[3];

            bool isCircular;
            bool dataDirty;
            __CircleFloat xCtr, yCtr, cRad, startTheta, endTheta;
        };
        std::vector<__Arc> _storage;

        __Interpolated _lerp(__Interpolated pt1, float pos1, __Interpolated pt2, float pos2, float pos) {
            return pt1 + (pt2 - pt1) * (pos - pos1) * (1 / (pos2 - pos1));
        }

        void update_segment(int segment) {
            __Arc &thePoly = this->_storage.at(segment);

            //Evaluate position
            __CircleFloat slope1, slope2, xCtr, yCtr, cRad, aTheta, bTheta, cTheta;

            slope1 = (thePoly._i[1]._y - thePoly._i[0]._y) / (thePoly._i[1]._x - thePoly._i[0]._x);
            slope2 = (thePoly._i[2]._y - thePoly._i[1]._y) / (thePoly._i[2]._x - thePoly._i[1]._x);

            //Cases where there is no slope for each implied line segment, or
            //where the slope is zero (e.g. identical points) will be treated
            //as a regular line.
            if (slope1 == slope2 || slope1 == 0.0 || slope2 == 0.0) {
                thePoly.isCircular = false;
            } else {
                //Valid circle path
                thePoly.isCircular = true;

                xCtr = (slope1 * slope2 * (thePoly._i[2]._y - thePoly._i[0]._y) + slope1 * (thePoly._i[1]._x + thePoly._i[2]._x) - slope2 * (thePoly._i[0]._x + thePoly._i[1]._x)) / (2 * (slope1 - slope2));
                yCtr = (thePoly._i[0]._y + thePoly._i[1]._y) / 2 - (xCtr - (thePoly._i[0]._x + thePoly._i[1]._x) / 2) / slope1;
                cRad = pow((pow((thePoly._i[1]._x - xCtr), 2) +
                            pow((thePoly._i[1]._y - yCtr), 2)), 0.5);

                aTheta = acos((thePoly._i[0]._y - yCtr) / cRad) + ((thePoly._i[0]._x - xCtr) < 0 ? Math.PI / 2 : 0);
                bTheta = acos((thePoly._i[1]._y - yCtr) / cRad) + ((thePoly._i[1]._x - xCtr) < 0 ? Math.PI / 2 : 0);
                cTheta = acos((thePoly._i[2]._y - yCtr) / cRad) + ((thePoly._i[2]._x - xCtr) < 0 ? Math.PI / 2 : 0);

                //TODO: Sort a/b/c theta to form a proper start/end range.
                //Rule: Angles always monotonically increase from startAngle to endAngle.
                //Therefore, pick the lowest of atheta/ctheta to be the startAngle

                if (aTheta <= bTheta && bTheta <= cTheta) { // Order ABC
                    thePoly.startTheta = aTheta;
                    thePoly.endTheta = cTheta;
                } else if (aTheta >= bTheta && bTheta >= cTheta) { // Order CBA
                    thePoly.endTheta = aTheta;
                    thePoly.startTheta = cTheta;
                } else if (aTheta <= cTheta && cTheta <= bTheta) { // Order ACB
                    thePoly.startTheta = aTheta;
                    thePoly.endTheta = bTheta;
                } else if (aTheta >= cTheta && cTheta >= bTheta) { // Order BCA
                    thePoly.endTheta = aTheta;
                    thePoly.startTheta = bTheta;
                } else if (bTheta <= aTheta && aTheta <= cTheta) { // Order BAC
                    thePoly.startTheta = bTheta;
                    thePoly.endTheta = cTheta;
                } else if (bTheta >= aTheta && aTheta >= cTheta) { // Order CAB
                    thePoly.endTheta = bTheta;
                    thePoly.startTheta = cTheta;
                } else { //This branch should NEVER be reached.
                    assert(false);
                }
            }

            thePoly.xCtr = xCtr;
            thePoly.yCtr = yCtr;
            thePoly.cRad = cRad;

            thePoly.dataDirty = false;
        }
    public:
        typedef typename std::vector<__Arc>::size_type size_type;

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
            __Interpolated newPt;

            //TODO: Evaluate X/Y as a circle.
            newPt._attr = _lerp(thePoly._i[j]._attr, segment, thePoly._i[j+1]._attr, segment+1, t);

            return newPt;
        }

        auto count_points() -> decltype(this->_storage.size()) {
            return this->_storage.size();
        };

        void extend_spline() {
            this->_storage.emplace_back();
            this->_storage.at(this->_storage.size() - 1).dataDirty = true;
        };

        void contract_spline() {
            this->_storage.pop_back();
        };

        __Interpolated& get_point(const int splinept, const int polypt) {
            if (polypt <= 2) { //All arcsplines have 3 points per spline segment
                __Arc& spl = this->_storage.at(splinept);

                //Since we are exporting direct memory references to the point,
                //consider the existing circle data invalid.
                spl.dataDirty = true;

                return spl._i[polypt];
            } else {
                throw std::out_of_range("icCanvasManager::TMVBeizer::get_point");
            }
        };

        void set_point(const int splinept, const int polypt, const __Interpolated& pt) {
            if (polypt <= 2) { //2 = quadratic polynom
                __Arc& spl = this->_storage.at(splinept);
                spl._i[polypt] = pt;
            }

            this->update_segment(splinept);
        };

        /* Convert a single spline segment into center/radius form.
         *
         * WARNING: The signature of this function will change when the class
         * is configured to use fixed point maths for arcs.
         */
        void segment_in_center_radius_form(const int splinept, __CircleFloat& x, __CircleFloat& y, __CircleFloat& radius, __CircleFloat& startAngle, __CircleFloat& endAngle) {
            __Arc& spl = this->_storage.at(splinept);
            if (spl.dataDirty) {
                this->update_segment(splinept);
            }

            x = spl.xCtr;
            y = spl.yCtr;
            radius = spl.cRad;
            startAngle = spl.startTheta;
            endAngle = spl.endTheta;
        }

        friend class Renderer;
        friend class Cairo::Renderer;
        friend class GL::Renderer;
        friend class CPU::Renderer;
    };
};

#endif
