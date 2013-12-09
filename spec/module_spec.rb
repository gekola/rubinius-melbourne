describe "A Module node" do
  relates <<-ruby do
      module X
        def y
        end
      end
    ruby

    parse do
      [:module, :X, [:scope, [:defn, :y, [:args], [:scope, [:block, [:nil]]]]]]
    end
  end

  relates <<-ruby do
      module ::Y
        c
      end
    ruby

    parse do
      [:module, [:colon3, :Y], [:scope, [:call, nil, :c, [:arglist]]]]
    end
  end

  relates <<-ruby do
      module X::Y
        c
      end
    ruby

    parse do
      [:module, [:colon2, [:const, :X], :Y], [:scope, [:call, nil, :c, [:arglist]]]]
    end
  end

  relates <<-ruby do
      "prevent the above from infecting rdoc"

      module Graffle
      end
    ruby

    parse do
      [:module, :Graffle, [:scope]]
    end
  end
end
