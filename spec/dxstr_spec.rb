require File.dirname(__FILE__) + '/../spec_helper'

describe "A Dxstr node" do
  relates <<-ruby do
      t = 5
      `touch \#{t}`
    ruby

    parse do
      [:block, [:lasgn, :t, [:lit, 5]], [:dxstr, "touch ", [:evstr, [:lvar, :t]]]]
    end

    compile do |g|
      g.push 5
      g.set_local 0
      g.pop

      g.push :self

      g.push_local 0
      g.send :to_s, 0, true

      g.push_literal "touch "
      g.string_dup

      g.string_append

      g.send :"`", 1, true
    end
  end
end
