#lang racket/base

(require racket/match
         racket/cmdline
         racket/system
         raco/command-name
         "src/list.rkt"
         "src/clone.rkt"
         "src/error.rkt")

(define listing? (make-parameter #f))

(module+ main
  (define cli-args
    (command-line
     #:program "raco new"
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
           [(list)
            (define cmd-name (short-program+command-name))
            (define help-command
              (if (string=? "raco" (substring cmd-name 0 4))
                "raco new --help"
                (format "racket ~a --help" cmd-name)))
            (system help-command)]
           [(list repo) (clone-repo repo repo)]
           [(list repo dir) (clone-repo repo dir)]
           ;; Errors
           [_ (displayln too-many-arguments-error)
              (exit)])
         ])))))

