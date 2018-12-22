;;;==============================================================
;;; NoteAbilityPro connection in OM voice/poly boxes
;;;==============================================================


(in-package :om)

;;;============
;;; TEMP: TO REMOVE IN FINAL RELEASE

(defclass OMBoxRelatedWClass (OMBoxcall) 
  ((uniquename :initform nil :accessor uniquename))
   (:documentation "Boxes with a class as reference are instances of this class.#enddoc#
#seealso# (OMBoxcall  OMBoxEditCall OMSlotsBox) #seealso#")
   (:metaclass omstandardclass))

(defmethod initialize-instance :after ((self OMBoxRelatedWClass) &key controls)
  (declare (ignore controls))
  (setf (uniquename self) (gensym (name (reference self))))
  (get&corrige-icon (icon (reference self))))

;;;============


;;; IN THE CONTEXT MENU

(defmethod object-box-specific-menu ((self voice) box) (nap-connection-menu box))
(defmethod object-box-specific-menu ((self poly) box) (nap-connection-menu box))
  
(defun nap-connection-menu (box)
  (let ((attached? (get-edit-param box :nap)))
       (list (om-new-leafmenu 
              (if attached? "Detach from NAPro..." "Edit with NAPro...")
              #'(lambda () 
                  (when (not attached?) 
                    (om-cmd-line (string+ *om-open-cmd* " " (namestring *nap-app-path*)))
                    ;;; open/focus the document
                    (send-contents-to-nap box))
                  (set-edit-param box :nap (not attached?))
                  )))))

(defun send-contents-to-nap (box)
  (osc-send (list 
             (list "/nap/docid" (uniquename box))
             (list "/nap/contents" (container->coom-string 
                                    (objfromobjs (value box) (make-instance 'poly))
                                    0 (or (get-edit-param box 'approx) 2))))
            *nap-osc-host* *nap-osc-in*))



;;; UPDATE TO NAP
;;; HACKS

(defmethod update-if-editor :after ((self OMBoxEditCall))
  (when (get-edit-param self :nap)
    (send-contents-to-nap self)))

(defmethod self-notify :before ((self OMBoxEditCall) &optional (separate-thread t))
  (when (get-edit-param self :nap)
    (send-contents-to-nap self)))
