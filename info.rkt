#lang info

(define collection "raco-new")
(define version "1.1")
(define pkg-authors '(nixin72))
(define pkg-desc "Download template apps to get started building new projects with Racket")
(define scribblings '(("scribblings/raco-new.scrbl" ())))

(define deps
  '("base" "readline" "http-easy"))

(define build-deps
  '("racket-doc"
    "rackunit-lib"
    "scribble-lib"))

(define raco-commands
  '(("new"
     (submod raco-new main)
     "Install a repo from a template at racket-templates" 50)))
