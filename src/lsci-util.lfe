(defmodule lsci-util
  (export all))

(defun get-lsci-version ()
  (lutil:get-app-src-version "src/lsci.app.src"))

(defun get-py-version ()
  (lists:map #'string:strip/1
             (string:tokens (lsci:py 'sys 'version.__str__ '())
                            "\n")))

(defun get-versions ()
  (++ (lutil:get-version)
      `(#(lsci ,(get-lsci-version))
        #(python ,(get-py-version)))))

(defun make-func
  ((`(,lfe-func-name ,func-arity) mod)
    (let ((py-func-name (kla:replace-dash lfe-func-name))
          (func-args (kla:make-args func-arity)))
      `(defun ,lfe-func-name ,func-args
        (lsci:py ',mod ',py-func-name (list ,@func-args))))))

(defun make-funcs (func-list mod)
  (lists:map
    (lambda (x)
      (make-func x mod))
    func-list))