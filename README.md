What?
=====

A work in progress generic router that takes JSON from one
middleware source and route it to another destination based
on an expression language from JGrep.

This is a work in progress, can't be used yet.

Route Example
-------------

_foo.route_

    expression "headers.scode >= 300 and body.origin = 'apache'"

    processor do |headers, body|
      case body.vhost
        when "foo.com"
	   target "/queue/errors.foo"

	when "bar.com"
	   target "/queue/errors.bar"

      end

      target "/queue/errors.all"
    end

The idea is that the expression is used to do course selection over a
stream of messages on the middleware that contains JSON, the processor
block is then called for ones that match the expression where it can
create a series of STOMP destinations where the message will be sent.

In this case any HTTP log with a status >= 300 will be processed by
this router.  Errors from the vhost foo.com and bar.com goes to specific
destinations while everything also goes to the all errors destination.
