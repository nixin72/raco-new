#lang racket/base

(require
  racket/string
  racket/function
  racket/port
  threading
  net/http-easy)

(define template-list "https://raw.githubusercontent.com/racket-templates/racket-templates/refs/heads/main/templates/.all")

(struct template (name desc from repo) #:transparent)
(define [hash->template h]
  ;; Could just take hash-values, but we want to make sure they're in the right order.
  ;; Also don't want to format them each every time...
  (define t (list (hash-ref h 'name) (hash-ref h 'desc) (hash-ref h 'from) (hash-ref h 'repo)))
  (apply template (map (curry format "~a") t)))

;; Create a map containing the data for all of the templates
;; { template-name -> template }
(define [list-templates]
  (with-handlers ([exn:fail:http-easy:timeout? (lambda () (list-templates))])
    (let* [(templates-str (~> (get template-list)
                              (response-body)
                              (bytes->string/utf-8)))
           (templates (with-input-from-string
                         templates-str
                         (lambda () (read))))]
      (foldl (lambda (t ts)
               (let [(h (hash->template (apply hash t)))]
                 (hash-set ts (template-name h) h)))
             (hash)
             templates))))

(define normal "\033[0m")
(define [color color strs] (string-append color (string-join strs " ") normal))
(define [bold . strings] (color "\033[0;1m" strings))

;; NOTE: I was thinking that it might be nice to make the list queryable, so users could
;; do something like:
;; $ raco new --list web
;; And get a list of all templates that might be used for web related stuff, but I
;; think that's also a problem perfectly solveable by just using grep. But something
;; to think about. Might be nice for those unfamiliar with grep or using Windows.

;; Gets the list of templates and prints them all
(define [print-templates]
  (for [(x (hash-values (list-templates)))]
    (printf "~a - ~a\n"
            (bold (template-name x))
            (template-desc x))))

(provide
  list-templates
  template-name
  template-desc
  template-from
  template-repo
  print-templates)