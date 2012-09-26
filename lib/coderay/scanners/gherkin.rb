# encoding: utf-8
# Grabbed from https://gist.github.com/1076987
module CodeRay
  module Scanners

    # Simple Scanner for Gherkin (Cucumber).
    #
    class Gherkin < Scanner

      register_for :gherkin
      file_extension 'feature'
      title 'Gherkin'

      def scan_tokens(tokens, options)
        until eos?
          match = scan(/.*\n?/)
          if match =~ /^(\s*)(Feature:|Egenskap:|Scenario:|Scenario Outline:|Background:|Bakgrunn:|Examples:|Given |Gitt |When |Når |Then |Så |And |Og |But |Men |\* )(.*)$/
            tokens << [ $1, :output ]
            tokens << [ $2, :keyword ]
            tokens << [ "#{$3}\n", :output ]
          elsif match =~ /^\s*#/
            tokens << [ match, :comment ]
          elsif match =~ /^\s*@/
            tokens << [ match, :string ]
          elsif match =~ /^\s*"""/
            tokens << [ match, :keyword ]
          elsif match =~ /^\s*\|/
            match.scan(/([^\|]*)(\|\s*)/) do |cell, bar|
              tokens << [ cell, :output ]
              tokens << [ bar, :keyword ]
            end
          else
            tokens << [ match, :output ]
          end
        end
        tokens
      end

    end

  end
end
