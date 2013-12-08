require File.dirname(__FILE__) + '/../spec_helper'

describe "An Ensure node" do
  relates <<-ruby do
      begin
        # do nothing
      rescue
        # do nothing
      ensure
        # do nothing
      end
    ruby

    parse do
      [:ensure, [:rescue, [:resbody, [:array], nil]], [:nil]]
    end

    compile do |g|
      top    = g.new_label
      dunno  = g.new_label
      bottom = g.new_label

      g.setup_unwind dunno

      top.set!

      g.push_modifiers
      g.push :nil
      g.pop_modifiers
      g.pop_unwind
      g.goto bottom

      dunno.set!

      g.push_exception

      g.push :nil
      g.pop

      g.pop_exception
      g.reraise

      bottom.set!

      g.push :nil
      g.pop
    end
  end

  relates <<-ruby do
      begin
        (1 + 1)
      rescue SyntaxError => e1
        2
      rescue Exception => e2
        3
      else
        4
      ensure
        5
      end
    ruby

    parse do
      [:ensure,
         [:rescue,
          [:call, [:lit, 1], :+, [:arglist, [:lit, 1]]],
          [:resbody,
           [:array, [:const, :SyntaxError], [:lasgn, :e1, [:gvar, :$!]]],
           [:lit, 2]],
          [:resbody,
           [:array, [:const, :Exception], [:lasgn, :e2, [:gvar, :$!]]],
           [:lit, 3]],
          [:lit, 4]],
         [:lit, 5]]
    end

    compile do |g|
      in_rescue :SyntaxError, :Exception, :ensure, 2 do |section|
        case section
        when :body then
          g.push 1
          g.push 1
          g.send :+, 1, false
        when :SyntaxError then
          g.push_exception
          g.set_local 0
          g.pop
          g.push 2
        when :Exception then
          g.push_exception
          g.set_local 1
          g.pop
          g.push 3
        when :else then
          g.pop         # TODO: should this be built in?
          g.push 4
        when :ensure then
          g.push 5
          g.pop
        end
      end
    end
  end

  relates <<-ruby do
      begin
        a
      rescue
        # do nothing
      ensure
        # do nothing
      end
    ruby

    parse do
      [:ensure,
         [:rescue, [:call, nil, :a, [:arglist]], [:resbody, [:array], nil]],
         [:nil]]
    end

    compile do |g|
      in_rescue :StandardError, :ensure do |section|
        case section
        when :body then
          g.push :self
          g.send :a, 0, true
        when :StandardError then
          g.push :nil
        when :ensure then
          g.push :nil
          g.pop
        end
      end
    end
  end

  relates <<-ruby do
      begin
        14
        return 2
      ensure
        13
      end
    ruby

    parse do
      [:ensure, [:block, [:lit, 14], [:return, [:lit, 2]]], [:lit, 13]]
    end

    compile do |g|
      ok = g.new_label
      g.exceptions(:ensure) do |ex|
        g.push 14
        g.pop
        g.push 2
        g.ensure_return
        ex.escape ok

        ex.handle!
        g.push_exception

        g.push 13
        g.pop

        g.pop_exception
        g.reraise
      end

      ok.set!

      g.push 13
      g.pop
    end
  end

  relates <<-ruby do
      begin
        begin
          14
          return 2
        ensure
          13
        end
      ensure
        15
      end
    ruby

    parse do
      [:ensure,
       [:ensure, [:block, [:lit, 14], [:return, [:lit, 2]]], [:lit, 13]],
       [:lit, 15]]
    end

    # TODO
  end

  relates <<-ruby do
      begin
        14
        return 2
      ensure
        begin
          15
          return 3
        ensure
          16
        end
      end
    ruby

    parse do
      [:ensure,
        [:block, [:lit, 14], [:return, [:lit, 2]]],
        [:ensure, [:block, [:lit, 15], [:return, [:lit, 3]]], [:lit, 16]]]
    end
  end

  # TODO
end
