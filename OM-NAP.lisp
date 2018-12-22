;;;===================================================
;;; OM-NAP
;;; Connecting OM score objects to NoteAbilityPro notation software 
;;; Jean Bresson, IRCAM/CNMAT/UBC 2016
;;;===================================================

(in-package :om)

(compile&load (om-relative-path '("sources") "nap-preferences"))
(compile&load (om-relative-path '("sources") "nap-connection"))

(doc-library 
 "OM-NAP is a library connecting OM voice and poly boxes to NoteAbilityPro notation software.

Use contextual menus to attach a box to a NAP document.
See Preferences/Externals for more options.
"
 (find-library "OM-NAP"))

(om::set-lib-release 0.1)

(print 
"
;;;============================
;;; OM-NAP (c) IRCAM/CNMAT/UBC 2016
;;; Connecting OM score objects to 
;;; NoteAbilityPro notation software
;;;============================
")

