
(in-package :om)


(add-external-pref-module 'nap)

(defmethod get-external-name ((module (eql 'nap))) "NoteAbilityPro")

(defmethod get-external-module-vals ((module (eql 'nap)) modulepref) (get-pref modulepref :nap-options))
(defmethod get-external-module-path ((module (eql 'nap)) modulepref) (get-pref modulepref :nap-path))
(defmethod set-external-module-vals ((module (eql 'nap)) modulepref vals) (set-pref modulepref :nap-options vals))
(defmethod set-external-module-path ((module (eql 'nap)) modulepref path) (set-pref modulepref :nap-path path))

(defun def-multiplayer-options () '(7071 7072 ))

(defparameter *nap-app-path* "NoteAbilityPro")
(defparameter *nap-osc-host* "127.0.0.1")
(defparameter *nap-osc-in* 3003)
(defparameter *nap-osc-out* 3004)


(defmethod get-external-def-vals ((module (eql 'nap))) 
    (list :nap-path (probe-file (om-default-application-path '() "NoteAbilityPro"))
          :nap-options '("127.0.0.1" 3003 3004)))

(defmethod save-external-prefs ((module (eql 'nap))) 
  `(:nap-path ,(om-save-pathname *nap-app-path*) 
    :nao-options (list ,*nap-osc-host* ,*nap-osc-in* ,*nap-osc-out*)))


(defmethod put-external-preferences ((module (eql 'nap)) moduleprefs)
  (let ((list-prefs (get-pref moduleprefs :nap-options)))
    (when list-prefs 
      (setf *nap-osc-host* (nth 0 list-prefs))
      (setf *nap-osc-in* (nth 1 list-prefs))
      (setf *nap-osc-out* (nth 2 list-prefs))
      )
    (when (get-pref moduleprefs :nap-path)
      (setf *nap-app-path* (get-pref moduleprefs :nap-path))
      )
    ))

(put-external-preferences 'nap (find-pref-module :externals))

(defmethod show-external-prefs-dialog ((module (eql 'nap)) prefvals)

  (let* ((rep-list (copy-list prefvals))
         (dialog (om-make-window 'om-dialog
                                 :window-title "NiteAbilityPro Options"
                                 :size (om-make-point 360 220)
                                 :position :centered
                                 :resizable nil :maximize nil :close nil))
         (i 10) initem outitem hostitem)
    
    (om-add-subviews dialog
                     
                     (om-make-dialog-item 'om-static-text (om-make-point 10 i) (om-make-point 250 24) "NoteAbilityPro network settings" :font *om-default-font2b*)

                     (om-make-dialog-item 'om-static-text (om-make-point 10 (incf i 35)) (om-make-point 150 24) "UDP Ports" :font *om-default-font2*);

                     (om-make-dialog-item 'om-static-text (om-make-point 90 i) (om-make-point 150 20) "OUT (to NAPro In)" :font *om-default-font2*)
                     
                     (setf outitem (om-make-dialog-item 'om-editable-text (om-make-point 230 i) (om-make-point 42 13)
                                          (format nil "~D" (nth 1 prefvals))
                                          :font *om-default-font1*))
                     
                     (om-make-dialog-item 'om-static-text (om-make-point 90 (incf i 25)) (om-make-point 150 24) "IN (from NAPro Out)" :font *om-default-font2*)
                     
                     (setf initem (om-make-dialog-item 'om-editable-text (om-make-point 230 i) (om-make-point 42 13)
                                          (format nil "~D" (nth 2 prefvals))
                                          :font *om-default-font1*))
                     
                     (om-make-dialog-item 'om-static-text (om-make-point 10 (incf i 35)) (om-make-point 150 24) 
                                          "NoteAbilityPro host IP" :font *om-default-font2*)
                     
                     (setf hostitem (om-make-dialog-item 'om-editable-text (om-make-point 165 i) 
                                                         (om-make-point 100 13)
                                                         (nth 0 prefvals) 
                                                         :font *om-default-font1*))




      
      ;;; boutons
      (om-make-dialog-item 'om-button (om-make-point 15 (incf i 55)) (om-make-point 90 20) "Restore"
                           :di-action (om-dialog-item-act item
                                        (om-set-dialog-item-text outitem (number-to-string (nth 1 (def-multiplayer-options))))
                                        (om-set-dialog-item-text initem (number-to-string (nth 2 (def-multiplayer-options))))
                                        (om-set-dialog-item-text hostitem (number-to-string (nth 0 (def-multiplayer-options))))
                                        ))
      
      (om-make-dialog-item 'om-button (om-make-point 160 i) (om-make-point 90 20) "Cancel"
                           :di-action (om-dialog-item-act item
                                        (om-return-from-modal-dialog dialog nil)))
      
      (om-make-dialog-item 'om-button (om-make-point 250 i) (om-make-point 90 20) "OK"
                           :di-action (om-dialog-item-act item
                                        (let* ((argerror nil)
                                               (intxt (om-dialog-item-text initem)) 
                                               (in (and (not (string= "" intxt)) (read-from-string intxt)))
                                               (outtxt (om-dialog-item-text outitem)) 
                                               (out (and (not (string= "" outtxt)) (read-from-string outtxt))))
                                         
                                          (if (and (integerp in)
                                                   (>= in 0)
                                                   (integerp out)
                                                   (>= out 0)
                                                   (not (= in out)))
                                              (setf (nth 1 rep-list) out
                                                    (nth 2 rep-list) in)
                                            (setf argerror t))
                                          
                                          (if (not (string= "" (om-dialog-item-text hostitem)))
                                              (setf (nth 0 rep-list) (om-dialog-item-text hostitem))
                                            (setf argerror t))
                                          
                                          (if argerror
                                              (om-message-dialog (format nil "Error in a MultiPlayer option!~%Preference values could not be set."))
                                            (om-return-from-modal-dialog dialog rep-list))
                                          ))
                           :default-button t :focus t)
      )
    (om-modal-dialog dialog)))
