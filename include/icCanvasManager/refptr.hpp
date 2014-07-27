#ifndef __ICCANVASMANAGER_REFPTR__H_
#define __ICCANVASMANAGER_REFPTR__H_

#include "../icCanvasManager.hpp"

#include <cstddef>

namespace icCanvasManager {
    template <typename __RefCls>
    class RefPtr {
        __RefCls* tgt;
    public:
        RefPtr() : tgt(NULL) {};

        RefPtr(__RefCls* ptr) : tgt(ptr) {
            if (tgt != NULL) {
                tgt->ref();
            }
        };

        RefPtr(const RefPtr<__RefCls>& ptr) : tgt(ptr.tgt) {
            if (tgt != NULL) {
                tgt->ref();
            }
        }

        virtual ~RefPtr() {
            if (tgt != NULL && tgt->deref() == 0) {
                delete tgt;
            }
        };

        /* Take the object out of the smartptr.
         * Be sure to ref/deref it as needed!
         */
        __RefCls& operator *() {
            return *tgt;
        }

        __RefCls* operator ->() {
            return tgt;
        }

        bool operator ==(RefPtr<__RefCls> &optr) {
            return tgt == *optr;
        }

        bool operator ==(__RefCls *optr) {
            return tgt == optr;
        }

        bool operator !=(RefPtr<__RefCls> &optr) {
            return tgt != *optr;
        }

        bool operator !=(__RefCls *optr) {
            return tgt != optr;
        }

        RefPtr<__RefCls>& operator =(RefPtr<__RefCls> &optr) {
            if (tgt != NULL && tgt->deref() == 0) {
                delete tgt;
            }

            tgt = optr.tgt;
            if (tgt != NULL) {
                tgt->ref();
            }

            return *this;
        }

        RefPtr<__RefCls>& operator =(__RefCls *optr) {
            if (tgt != NULL && tgt->deref() == 0) {
                delete tgt;
            }

            tgt = optr;
            if (tgt != NULL) {
                tgt->ref();
            }

            return *this;
        }

        operator bool() {
            return tgt != NULL;
        }

        operator void*() {
            return (void*)tgt;
        }

        operator __RefCls*() {
            return tgt;
        }
    };
}

#endif
