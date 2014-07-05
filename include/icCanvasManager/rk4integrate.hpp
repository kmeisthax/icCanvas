#ifndef __ICCANVASMANAGER_RK4_HPP__
#define __ICCANVASMANAGER_RK4_HPP__

#include "../icCanvasManager.hpp"

namespace icCanvasManager {
    /**
     * Integrate using the Runge-Kutta method.
     * 
     * Given an initial value initialPos of some function at a particular time,
     * move that value forward by step using the derivative provided by the
     * functor derivative (a class that implements operator() accepting a value
     * of type time and a value of type initialpos).
     */
    template <typename __XVar, typename __TVar, typename __DerivFunctor>
    __XVar RK4Integrate(__XVar &initialPos, __TVar &time, __TVar &step, __DerivFunctor &derivative) {
        auto k1 = derivative(time, initialPos);
        auto k2 = derivative(time + (step / 2), initialPos + (step / 2) * k1);
        auto k3 = derivative(time + (step / 2), initialPos + (step / 2) * k2);
        auto k4 = derivative(time + step, initialPos + step * k3);
        
        return initialPos + (step / 6) * (k1 + 2 * k2 + 2 * k3 + k4);
    };
    
    /**
     * Integrate using the derivative as it's own timestep.
     * 
     * I have no clue if this even makes sense, but it's done in this paper:
     * http://www.geometrictools.com/Documentation/MovingAlongCurveSpecifiedSpeed.pdf
     */
    template <typename __TVar, typename __DerivFunctor>
    __TVar RK4Integrate(__TVar &time, __DerivFunctor &derivative) {
        auto k1 = derivative(time);
        auto k2 = derivative(time + (k1 / 2.0));
        auto k3 = derivative(time + (k2 / 2.0));
        auto k4 = derivative(time + k3);
        
        return time + (k1 + 2 * k2 + 2 * k3 + k4) / 6.0;
    };
}

#endif