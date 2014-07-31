#ifndef __ICCANVASMANAGER__SINGLETON_HPP__
#define __ICCANVASMANAGER__SINGLETON_HPP__

#include <icCanvasManager.hpp>

namespace icCanvasManager {
    /* Represents an object intended to be constructed once, at the start of
     * the application run, and destructed once, at the end of the application
     * run.
     *
     * To prevent application crashes from attempting to hold reference-counted
     * pointers to a Singleton, we define the Singleton as constantly having
     * exactly one reference attached to it through dummy ref/deref methods.
     *
     * As Singletons can only exist once, you cannot subclass a Singleton. We
     * also refrain from the usual behavior of declaring a virtual destructor
     * as there is no need for polymorphism in this case.
     */
    template <typename __Derived>
    class Singleton {
        static __Derived instance;
    protected:
        Singleton() {};
        ~Singleton() {};
    public:
        int ref() { return 1; };
        int deref() { return 1; };

        static __Derived& get_instance() { return Singleton<__Derived>::instance; };
    };
}

#endif
