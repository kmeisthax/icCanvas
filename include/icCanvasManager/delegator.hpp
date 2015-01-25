#ifndef __ICCANVASMANAGER__DELEGATOR_HPP__
#define __ICCANVASMANAGER__DELEGATOR_HPP__

namespace icCanvasManager {
    /* Represents a class whose objects possess a Delegate, allowing them to
     * provide signals to another object which owns this one.
     *
     * Delegates are not required, but are strongly recommended, to be RefCnt
     * objects. When the Delegator is destroyed, if the delegate is a RefCnt
     * object, then we deref it. Otherwise it's fully destroyed.
     */
    template <typename __Delegated, typename __Delegate>
    class Delegator {
        RefPtr<RefCnt> _delegate_lifetime;
    protected:
        __Delegate* _delegate;
    public:
        Delegator() : _delegate(NULL), _delegate_lifetime(NULL) {};
        virtual ~Delegator() {};

        void set_delegate(__Delegate* del) {
            if (del == this->_delegate) return;

            if (this->_delegate && this->_delegate_lifetime) this->_delegate_lifetime = NULL;

            if (del) {
                auto* del_rc = dynamic_cast<icCanvasManager::RefCnt*>(del);
                if (del_rc) this->_delegate_lifetime = del_rc;

                this->_delegate = del;
            }
        };

        __Delegate* get_delegate() {
            return this->_delegate;
        };
    };
}

#endif
