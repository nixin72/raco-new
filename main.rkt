#lang racket/base

(require racket/match
         racket/cmdline
         "src/list.rkt"
         "src/clone.rkt"
         "src/error.rkt")

(define listing? (make-parameter #f))

(module+ main
  (define cli-args
    (command-line
     #:program "new"
     #:once-any
     [("-l" "--list")
      "Lists all available templates to clone"
      (listing? #t)]
     #:args args
     (with-handlers
      ([exn:break?
        (lambda (e)
          (print-error e user-abort-error)
          (exit))]
       [exn?
        (lambda (e) (print-error e unexpected-error #t))])
      (cond
        [(listing?) (print-templates)]
        [else
         (match args
           ;; TODO: Should we be able to initialize an empty repository as a racket project?
           ;; npm init sorta thing, where it'll create a package.json in an empty directory
           [(list) (print-templates)]
           [(list repo) (clone-repo repo repo)]
           [(list repo dir) (clone-repo repo dir)]
           ;; Errors
           [_ (displayln too-many-arguments-error)
              (exit)])
         ])))))

