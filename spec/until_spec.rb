describe "An Until node" do
  pre_until_sexp = [
    :until,
     [:call, nil, :a, [:arglist]],
     [:call, [:call, nil, :b, [:arglist]], :+, [:arglist, [:lit, 1]]],
     true
  ]

  relates <<-ruby do
      while not a
        b + 1
      end
    ruby

    parse do
      pre_until_sexp
    end
  end

  relates "b + 1 while not a" do
    parse do
      pre_until_sexp
    end
  end

  relates <<-ruby do
      until a
        b + 1
      end
    ruby

    parse do
      pre_until_sexp
    end
  end

  relates "b + 1 until a" do
    parse do
      pre_until_sexp
    end
  end

  post_until_sexp = [
    :until,
     [:call, nil, :a, [:arglist]],
     [:call, [:call, nil, :b, [:arglist]], :+, [:arglist, [:lit, 1]]],
     false
  ]

  post_until = lambda do |g|
    top    = g.new_label
    rdo    = g.new_label
    brk    = g.new_label
    bottom = g.new_label

    g.push_modifiers

    top.set!

    g.push :self
    g.send :b, 0, true
    g.push 1
    g.send :+, 1, false
    g.pop

    rdo.set!

    g.push :self
    g.send :a, 0, true
    g.git bottom

    g.check_interrupts
    g.goto top

    bottom.set!
    g.push :nil

    brk.set!

    g.pop_modifiers
  end

  relates <<-ruby do
      begin
        b + 1
      end while not a
    ruby

    parse do
      post_until_sexp
    end
  end

  relates <<-ruby do
      begin
        b + 1
      end until a
    ruby

    parse do
      post_until_sexp
    end
  end

  nil_condition_sexp = [:until, [:nil], [:call, nil, :a, [:arglist]], true]

  relates "a until ()" do
    parse do
      nil_condition_sexp
    end
  end

  relates <<-ruby do
      until ()
        a
      end
    ruby

    parse do
      nil_condition_sexp
    end
  end

  relates "a while not ()" do
    parse do
      nil_condition_sexp
    end
  end

  relates <<-ruby do
      while not ()
        a
      end
    ruby

    parse do
      nil_condition_sexp
    end
  end
end
